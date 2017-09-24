
//
//  SearchByCategoryView.m
//  HalalMeatDelivery
//
//  Created by Mango Software Lab on 26/08/2016.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import "SearchByShop.h"
#import "HalalMeatDelivery.pch"
#import "SearchByCatCell.h"
#import "UIImageView+WebCache.h"
#import "NearByView.h"
#import "NearByCell.h"
#import "RestaurantDetailView.h"
#import <CoreLocation/CoreLocation.h>
#import "CategoryCell.h"
#import "NewNearbyCell.h"

#import "HNKGooglePlacesAutocompleteQuery.h"
#import "HNKGooglePlacesAutocompleteQueryConfig.h"
#import "HNKGooglePlacesAutocompleteQueryResponse.h"
#import "HNKGooglePlacesAutocompletePlace.h"
#import "HNKGooglePlacesAutocompletePlaceSubstring.h"
#import "HNKGooglePlacesAutocompletePlaceTerm.h"
#import "CLPlacemark+HNKAdditions.h"



static dispatch_once_t predicate;

#define SelectedButtonColor [UIColor colorWithRed:242.0f/255.0f green:18.0f/255.0f blue:43.0f/255.0f alpha:1.0f]
#define UnSelectedButtonColor [UIColor colorWithRed:101.0f/255.0f green:100.0f/255.0f blue:98.0f/255.0f alpha:1.0f]

@interface SearchByShop ()<CLLocationManagerDelegate,UIScrollViewDelegate,UISearchBarDelegate>
{
    NSDictionary *DataDic;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    
    double Latitude,Logitude;
    NSInteger limit_only,NoResponseInt,MapLocationcall;
    
    NSMutableArray *resultObjectsArray;
    NSMutableArray *SearchDictnory,*NewArr;
    
    NSMutableArray *CatArr,*CatselectedArr;
    NSMutableArray *DistanceArr,*DistanceSelectArr;
    NSMutableArray *FreeDelArr,*FreeDelSelectArr;
    NSMutableArray *ReviewStarArr,*ReviewStarSelectArr;
    NSMutableArray *SortByPriceArr;
    NSInteger SelectedShort;
    NSMutableDictionary *FilterDict;
    
    NSMutableArray *filter_idArry;
    
    NSMutableArray *catParsingArr;
    NSMutableArray *PriceParsingArr;
    NSMutableArray *RatingParsingArr;
    NSMutableArray *DistanceParsingArr;
    NSMutableArray *FreDelParsingArr;
    
    NSString *MaxPriceSTR;
    NSInteger indexAuto;
    
}
@property AppDelegate *appDelegate;
@property (strong, nonatomic) HNKGooglePlacesAutocompleteQuery *searchQuery;
@property (strong, nonatomic) NSArray *searchResults;

@end

@implementation SearchByShop
@synthesize Table,Filter_BTN,SearchPlaceTBL;
@synthesize SearchBar,Search_IMG,Searc_BTN;
@synthesize FilterView,SearchByCatBTN,SearchByRatBTN,SearchByDistBTN,SearchByPriceBTN,FreeDelevBTN;
@synthesize CatTBL,PriceView,AddressView,PlaceSearch;


#pragma mark - UISearchBar Delegate


- (void)handleSearchError:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length > 0)
    {
        [SearchPlaceTBL setHidden:NO];
        
        [_searchQuery fetchPlacesForSearchQuery: searchText completion:^(NSArray *places, NSError *error)
        {
             if (error)
             {
                 NSLog(@"ERROR: %@", error);
                 [self handleSearchError:error];
             }
             else
             {
                 self.searchResults = places;
                 [SearchPlaceTBL reloadData];
             }
         }];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [SearchPlaceTBL setHidden:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [HNKGooglePlacesAutocompleteQuery setupSharedQueryWithAPIKey: @"AIzaSyDFE1wLYBzn_T5JtMMoedh6fJWehL4kiL4"];

    self.searchQuery = [HNKGooglePlacesAutocompleteQuery sharedQuery];
    indexAuto=0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(Getlocationuser:)
                                                 name:@"GetLocation" object:nil];
    
    self.rangeSliderCurrency.hidden=YES;
    AddressView.hidden=YES;
    SelectedShort=0;
    CatTBL.hidden=NO;
    [SearchByCatBTN setBackgroundColor:SelectedButtonColor];
    [SearchByCatBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    FilterView.hidden=YES;
    
    // Getting Lat Log
    geocoder = [[CLGeocoder alloc] init];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager requestWhenInUseAuthorization];
    predicate = 0;
    [locationManager startUpdatingLocation];
    
    
    SearchDictnory=[[NSMutableArray alloc]init];
    NewArr=[[NSMutableArray alloc]init];
    
    SearchBar.hidden=YES;
    //[[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    [SearchBar setImage:[UIImage imageNamed:@"SearchIcon.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    self.appDelegate = [AppDelegate sharedInstance];
    
    
    UINib *nib = [UINib nibWithNibName:@"NewNearbyCell" bundle:nil];
    NewNearbyCell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    Table.rowHeight = cell.frame.size.height;
    [Table registerNib:nib forCellReuseIdentifier:@"NewNearbyCell"];
    
    UINib *nib2 = [UINib nibWithNibName:@"CategoryCell" bundle:nil];
    CategoryCell *cell2 = [[nib2 instantiateWithOwner:nil options:nil] objectAtIndex:0];
    CatTBL.rowHeight = cell2.frame.size.height;
    [CatTBL registerNib:nib2 forCellReuseIdentifier:@"CategoryCell"];
    
    limit_only=0;
    MapLocationcall=0;
    // Do any additional setup after loading the view.
    
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        // [self getFilterData];
         [self performSelector:@selector(getFilterData) withObject:nil afterDelay:0.0];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    }
    
   
    
    catParsingArr=[[NSMutableArray alloc]init];
    PriceParsingArr=[[NSMutableArray alloc]init];
    RatingParsingArr=[[NSMutableArray alloc]init];
    DistanceParsingArr=[[NSMutableArray alloc]init];
    FreDelParsingArr=[[NSMutableArray alloc]init];
}

-(void)Getlocationuser:(NSNotification *)notification
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager requestWhenInUseAuthorization];
    predicate = 0;
    [locationManager startUpdatingLocation];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:NO];
    
}

-(void)getFilterData
{
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:getFilterServiceName  forKey:@"service"];
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,Filter_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleGetFilterResponse:response];
     }];
}

- (void)handleGetFilterResponse:(NSDictionary*)response
{
   // NSLog(@"GetFilterResponse ===%@",response);
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        FilterDict=[response valueForKey:@"result"];
        filter_idArry=[[NSMutableArray alloc]init];
        filter_idArry=[FilterDict valueForKey:@"filter_id"];
        for (NSArray *filtername in FilterDict)
        {
            if ([[filtername valueForKey:@"filter_name"] isEqualToString:@"Search By Category"])
            {
                // Search By Category.
                CatArr=[[NSMutableArray alloc]init];
                CatArr=[filtername valueForKey:@"data"];
                CatselectedArr=[[NSMutableArray alloc]init];
                for (int i= 0; i<CatArr.count; i++)
                {
                    [CatselectedArr addObject:@"0"];
                }
            }
            else if ([[filtername valueForKey:@"filter_name"] isEqualToString:@"Sort By Distance"])
            {
                // Search By Distance.
                DistanceArr=[[NSMutableArray alloc]init];
                DistanceArr=[filtername valueForKey:@"data"];
                DistanceSelectArr=[[NSMutableArray alloc]init];
                for (int i= 0; i<DistanceArr.count; i++)
                {
                    [DistanceSelectArr addObject:@"0"];
                }
            }
            else if ([[filtername valueForKey:@"filter_name"] isEqualToString:@"Free Delivery"])
            {
                // Search By FreeDelivery.
                FreeDelArr=[[NSMutableArray alloc]init];
                FreeDelArr=[filtername valueForKey:@"data"];
                FreeDelSelectArr=[[NSMutableArray alloc]init];
                for (int i= 0; i<FreeDelArr.count; i++)
                {
                    [FreeDelSelectArr addObject:@"0"];
                }
            }
            else if ([[filtername valueForKey:@"filter_name"] isEqualToString:@"Sort By Rating"])
            {
                // Search By FreeDelivery.
                ReviewStarArr=[[NSMutableArray alloc]init];
                ReviewStarArr=[filtername valueForKey:@"data"];
                ReviewStarSelectArr=[[NSMutableArray alloc]init];
                for (int i= 0; i<ReviewStarArr.count; i++)
                {
                    [ReviewStarSelectArr addObject:@"0"];
                }
            }
            else if ([[filtername valueForKey:@"filter_name"] isEqualToString:@"Sort By Price"])
            {
                // Search By Range Bar.
                SortByPriceArr=[[NSMutableArray alloc]init];
                SortByPriceArr=[filtername valueForKey:@"data"];
                
                NSInteger MaxRang=[[[SortByPriceArr valueForKey:@"filter_value_name"] objectAtIndex:0] integerValue];
                //currency range slider
                self.rangeSliderCurrency.delegate = self;
                self.rangeSliderCurrency.minValue = 0;
                self.rangeSliderCurrency.maxValue = MaxRang;
                self.rangeSliderCurrency.selectedMinimum = 0;
                self.rangeSliderCurrency.selectedMaximum = MaxRang;
                self.rangeSliderCurrency.handleColor = SelectedButtonColor;
                self.rangeSliderCurrency.handleDiameter = 20;
                self.rangeSliderCurrency.selectedHandleDiameterMultiplier = 1;
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterCurrencyStyle;
                // self.rangeSliderCurrency.numberFormatterOverride = formatter;
                [self.rangeSliderCurrency bringSubviewToFront:self.view];
            }
        }
       [CatTBL reloadData];
    }
    else
    {
       
    }
}

-(void)CallForSearchByShop
{
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:SerachByShopServiceName  forKey:@"service"];
    
    [dictParams setObject:[NSString stringWithFormat:@"%.8f", Latitude]  forKey:@"lat"];
    [dictParams setObject:[NSString stringWithFormat:@"%.8f", Logitude]  forKey:@"long"];
    
   // [dictParams setObject:@"22.2795076"  forKey:@"lat"];
   // [dictParams setObject:@"70.7696403"  forKey:@"long"];
    
   [dictParams setObject:[NSString stringWithFormat:@"%ld", (long)limit_only]  forKey:@"limit_only"];
    NSLog(@"dictParams search by Shop===%@",dictParams);
    
   
   
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,SerachByShop_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleCategoryResponse:response];
     }];
    
}

- (void)handleCategoryResponse:(NSDictionary*)response
{
    NSLog(@"response ===%@",response);
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        if (MapLocationcall==1)
        {
            SearchDictnory=[[NSMutableArray alloc]init];
            NewArr=[[NSMutableArray alloc]init];
            DataDic=[response valueForKey:@"result"];
            for (NSDictionary *dic in DataDic)
            {
                [SearchDictnory addObject:dic];
            }
            NewArr=[[NSMutableArray alloc]initWithArray:SearchDictnory];
            limit_only=limit_only+DataDic.count;
            NoResponseInt=1;
            [Table reloadData];
            MapLocationcall=0;
        }
        else
        {
            DataDic=[response valueForKey:@"result"];
            for (NSDictionary *dic in DataDic)
            {
                [SearchDictnory addObject:dic];
            }
            NewArr=[[NSMutableArray alloc]initWithArray:SearchDictnory];
            limit_only=limit_only+DataDic.count;
            NoResponseInt=1;
            [Table reloadData];
        }
        
    }
    else
    {
        if (MapLocationcall==1)
        {
            SearchDictnory=[[NSMutableArray alloc]init];
            NewArr=[[NSMutableArray alloc]init];
            [AppDelegate showErrorMessageWithTitle:@"" message:[response objectForKey:@"ack_msg"] delegate:nil];
            NoResponseInt=0;
            [Table reloadData];
        }
        else
        {
            MapLocationcall=0;
            //[AppDelegate showErrorMessageWithTitle:@"" message:[response objectForKey:@"ack_msg"] delegate:nil];
            NoResponseInt=0;
            [Table reloadData];
        }
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - photoShotSavedDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection = %li", (long)selectionIndex);
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1; // in your case, there are 3 cells
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==CatTBL)
    {
        if (SelectedShort==0)
        {
            return CatArr.count;
        }
        else if (SelectedShort==2)
        {
            return ReviewStarArr.count;
        }
        else if (SelectedShort==3)
        {
            return DistanceArr.count;
        }
        else if (SelectedShort==4)
        {
            return FreeDelArr.count;
        }
        
    }
    else if (tableView==SearchPlaceTBL)
    {
        return self.searchResults.count;
    }
    return SearchDictnory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==CatTBL)
    {
        static NSString *CellIdentifier = @"CategoryCell";
        CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell=nil;
        if (cell == nil)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
        }
        
        if (SelectedShort==0)
        {
            [cell.StarView setHidden:YES];
            [cell.CatTitle_LBL setHidden:NO];
           
            if ([[CatselectedArr objectAtIndex:indexPath.row] isEqualToString:@"0"])
            {
                cell.CatIMG.image=[UIImage imageNamed:@"UnselectChkBox"];
            }
            else
            {
                cell.CatIMG.image=[UIImage imageNamed:@"SelectChkBox"];
            }
            
            cell.CatTitle_LBL.text=[[CatArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row];
        }
        if (SelectedShort==2)
        {
             [cell.StarView setHidden:NO];
             [cell.CatTitle_LBL setHidden:YES];
            
            if ([[ReviewStarSelectArr objectAtIndex:indexPath.row] isEqualToString:@"0"])
            {
                cell.CatIMG.image=[UIImage imageNamed:@"UnselectChkBox"];
            }
            else
            {
                cell.CatIMG.image=[UIImage imageNamed:@"SelectChkBox"];
            }
            if ([[[ReviewStarArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row] integerValue]<=5)
            {
                NSLog(@"reviewStar=%@",[[ReviewStarArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row]);
                
                if ([[[ReviewStarArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row] integerValue]==5) {
                    [cell.Start1 setHidden:NO];
                    [cell.Start2 setHidden:NO];
                    [cell.Start3 setHidden:NO];
                    [cell.Start4 setHidden:NO];
                    [cell.Start5 setHidden:NO];
                   
                }
                if ([[[ReviewStarArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row] integerValue]==4) {
                    [cell.Start1 setHidden:NO];
                    [cell.Start2 setHidden:NO];
                    [cell.Start3 setHidden:NO];
                    [cell.Start4 setHidden:NO];
                    [cell.Start5 setHidden:YES];
                }
                if ([[[ReviewStarArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row] integerValue]==3) {
                    [cell.Start1 setHidden:NO];
                    [cell.Start2 setHidden:NO];
                    [cell.Start3 setHidden:NO];
                    [cell.Start4 setHidden:YES];
                    [cell.Start5 setHidden:YES];
                }
                if ([[[ReviewStarArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row] integerValue]==2) {
                    [cell.Start1 setHidden:NO];
                    [cell.Start2 setHidden:NO];
                    [cell.Start3 setHidden:YES];
                    [cell.Start4 setHidden:YES];
                    [cell.Start5 setHidden:YES];
                }
                if ([[[ReviewStarArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row] integerValue]==1) {
                    [cell.Start1 setHidden:NO];
                    [cell.Start2 setHidden:YES];
                    [cell.Start3 setHidden:YES];
                    [cell.Start4 setHidden:YES];
                    [cell.Start5 setHidden:YES];
                }
            }
            
        }
        else if (SelectedShort==3)
        {
             [cell.StarView setHidden:YES];
            [cell.CatTitle_LBL setHidden:NO];
            if ([[DistanceSelectArr objectAtIndex:indexPath.row] isEqualToString:@"0"])
            {
                cell.CatIMG.image=[UIImage imageNamed:@"UnselectChkBox"];
            }
            else
            {
                cell.CatIMG.image=[UIImage imageNamed:@"SelectChkBox"];
            }
            
            cell.CatTitle_LBL.text=[[DistanceArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row];
        }
        else if (SelectedShort==4)
        {
             [cell.StarView setHidden:YES];
            [cell.CatTitle_LBL setHidden:NO];
            if ([[FreeDelSelectArr objectAtIndex:indexPath.row] isEqualToString:@"0"])
            {
                cell.CatIMG.image=[UIImage imageNamed:@"UnselectChkBox"];
            }
            else
            {
                cell.CatIMG.image=[UIImage imageNamed:@"SelectChkBox"];
            }
            
            cell.CatTitle_LBL.text=[[FreeDelArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row];
        }
        
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else if (tableView==SearchPlaceTBL)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HNKDemoSearchResultsCellIdentifier" forIndexPath:indexPath];
        
        HNKGooglePlacesAutocompletePlace *thisPlace = self.searchResults[indexPath.row];
        cell.textLabel.text = thisPlace.name;
        return cell;
    }
    else
    {
        
        
        static NSString *CellIdentifier = @"NewNearbyCell";
        NewNearbyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell=nil;
        if (cell == nil)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
        }
        
        NSString *Urlstr=[[SearchDictnory valueForKey:@"image_path"] objectAtIndex:indexPath.row];
        Urlstr = [Urlstr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [cell.RestIMG sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
        [cell.RestIMG setShowActivityIndicatorView:YES];
        
        
        cell.RestName_LBL.text=[[SearchDictnory valueForKey:@"name"] objectAtIndex:indexPath.row];
        cell.Distance_LBL.text=[NSString stringWithFormat:@" %@ ",[[SearchDictnory valueForKey:@"distance"] objectAtIndex:indexPath.row]] ;
        cell.Address_LBL.text=[NSString stringWithFormat:@" %@ ",[[SearchDictnory valueForKey:@"address"] objectAtIndex:indexPath.row]] ;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        NSInteger linecout=[self hight:cell.Address_LBL];
        if (linecout==1)
        {
            cell.BottonViewHeightAddr.constant=56;
        }
        else
        {
            cell.BottonViewHeightAddr.constant=66;
            
        }
        NSLog(@"linecout==%ld",(long)linecout);
        return cell;
    }
    return nil;
}
-(NSInteger)hight :(UILabel *)lbl
{
    NSInteger lineCount = 0;
    CGSize textSize = CGSizeMake(lbl.frame.size.width, MAXFLOAT);
    int rHeight = lroundf([lbl sizeThatFits:textSize].height);
    int charSize = lroundf(lbl.font.lineHeight);
    return  rHeight/charSize;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==CatTBL)
    {
        if (SelectedShort==0)
        {
            if ([[CatselectedArr objectAtIndex:indexPath.row] isEqualToString:@"0"])
            {
                [CatselectedArr replaceObjectAtIndex:indexPath.row withObject:@"1"];
                
                NSMutableDictionary *fliterdic = [[NSMutableDictionary alloc] init];
                [fliterdic setObject:[[CatArr valueForKey:@"filter_value_id"] objectAtIndex:indexPath.row]  forKey:@"filter_value_id"];
                [fliterdic setObject:[[CatArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row]  forKey:@"filter_value_name"];
                [fliterdic setObject:[[CatArr valueForKey:@"filter_value"] objectAtIndex:indexPath.row]  forKey:@"filter_value"];
                [catParsingArr addObject:fliterdic];
                
            }
            else
            {
                [CatselectedArr replaceObjectAtIndex:indexPath.row withObject:@"0"];
                for (int i=0; i<catParsingArr.count; i++)
                {
                    if ([[[catParsingArr objectAtIndex:i] valueForKey:@"filter_value_name"] isEqualToString:[[CatArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row]])
                    {
                        [catParsingArr removeObjectAtIndex:i];
                    }
                }
            }

        }
        else if (SelectedShort==2)
        {
            if ([[ReviewStarSelectArr objectAtIndex:indexPath.row] isEqualToString:@"0"])
            {
                [ReviewStarSelectArr replaceObjectAtIndex:indexPath.row withObject:@"1"];
                
                NSMutableDictionary *fliterdic = [[NSMutableDictionary alloc] init];
                [fliterdic setObject:[[ReviewStarArr valueForKey:@"filter_value_id"] objectAtIndex:indexPath.row]  forKey:@"filter_value_id"];
                [fliterdic setObject:[[ReviewStarArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row]  forKey:@"filter_value_name"];
                [fliterdic setObject:[[ReviewStarArr valueForKey:@"filter_value"] objectAtIndex:indexPath.row]  forKey:@"filter_value"];
                [RatingParsingArr addObject:fliterdic];
            }
            else
            {
                [ReviewStarSelectArr replaceObjectAtIndex:indexPath.row withObject:@"0"];
                for (int i=0; i<RatingParsingArr.count; i++)
                {
                    if ([[[RatingParsingArr objectAtIndex:i] valueForKey:@"filter_value_name"] isEqualToString:[[ReviewStarArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row]])
                    {
                        [RatingParsingArr removeObjectAtIndex:i];
                    }
                }
            }
            
        }
        else if (SelectedShort==3)
        {
            if ([[DistanceSelectArr objectAtIndex:indexPath.row] isEqualToString:@"0"])
            {
                [DistanceSelectArr replaceObjectAtIndex:indexPath.row withObject:@"1"];
                
                NSMutableDictionary *fliterdic = [[NSMutableDictionary alloc] init];
                [fliterdic setObject:[[DistanceArr valueForKey:@"filter_value_id"] objectAtIndex:indexPath.row]  forKey:@"filter_value_id"];
                [fliterdic setObject:[[DistanceArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row]  forKey:@"filter_value_name"];
                [fliterdic setObject:[[DistanceArr valueForKey:@"filter_value"] objectAtIndex:indexPath.row]  forKey:@"filter_value"];
                [DistanceParsingArr addObject:fliterdic];
            }
            else
            {
                [DistanceSelectArr replaceObjectAtIndex:indexPath.row withObject:@"0"];
                for (int i=0; i<DistanceParsingArr.count; i++)
                {
                    if ([[[DistanceParsingArr objectAtIndex:i] valueForKey:@"filter_value_name"] isEqualToString:[[DistanceArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row]])
                    {
                        [DistanceParsingArr removeObjectAtIndex:i];
                    }
                }
            }

        }
        else if (SelectedShort==4)
        {
            if ([[FreeDelSelectArr objectAtIndex:indexPath.row] isEqualToString:@"0"])
            {
                [FreeDelSelectArr replaceObjectAtIndex:indexPath.row withObject:@"1"];
                
                NSMutableDictionary *fliterdic = [[NSMutableDictionary alloc] init];
                [fliterdic setObject:[[FreeDelArr valueForKey:@"filter_value_id"] objectAtIndex:indexPath.row]  forKey:@"filter_value_id"];
                [fliterdic setObject:[[FreeDelArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row]  forKey:@"filter_value_name"];
                [fliterdic setObject:[[FreeDelArr valueForKey:@"filter_value"] objectAtIndex:indexPath.row]  forKey:@"filter_value"];
                [FreDelParsingArr addObject:fliterdic];
            }
            else
            {
                [FreeDelSelectArr replaceObjectAtIndex:indexPath.row withObject:@"0"];
                
                for (int i=0; i<FreDelParsingArr.count; i++)
                {
                    if ([[[FreDelParsingArr objectAtIndex:i] valueForKey:@"filter_value_name"] isEqualToString:[[FreeDelArr valueForKey:@"filter_value_name"] objectAtIndex:indexPath.row]])
                    {
                        [FreDelParsingArr removeObjectAtIndex:i];
                    }
                }
            }
            
        }
        
        [CatTBL reloadData];
    }
    else if (tableView==SearchPlaceTBL)
    {
        [PlaceSearch setShowsCancelButton:NO animated:YES];
        [PlaceSearch resignFirstResponder];
        indexAuto=indexPath.row;
         [KVNProgress show];
        [self performSelector:@selector(SelectAutoCompleData) withObject:nil afterDelay:3.0];
        ;
        [SearchPlaceTBL deselectRowAtIndexPath:indexPath animated:NO];
    }
    else
    {
        RestaurantDetailView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RestaurantDetailView"];
        vcr.R_ID=[[SearchDictnory valueForKey:@"id"]objectAtIndex:indexPath.row];
        vcr.Pin=[[SearchDictnory valueForKey:@"pin"]objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vcr animated:YES];
    }
}
-(void)SelectAutoCompleData
{
    HNKGooglePlacesAutocompletePlace *selectedPlace = self.searchResults[indexAuto];
    
    [CLPlacemark hnk_placemarkFromGooglePlace: selectedPlace apiKey: self.searchQuery.apiKey  completion:^(CLPlacemark *placemarks, NSString *addressString, NSError *error)
     {
         if (placemarks)
         {
             [SearchPlaceTBL setHidden: YES];
             [self addPlacemarkAnnotationToMap:placemarks addressString:addressString];
           
         }
     }];
}
#pragma mark - Helpers

- (void)addPlacemarkAnnotationToMap:(CLPlacemark *)placemarks addressString:(NSString *)address
{
   
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = placemarks.location.coordinate;
    annotation.title = address;
    PlaceSearch.text=address;
    
    Latitude= annotation.coordinate.latitude;
    Logitude= annotation.coordinate.longitude;
    self.Title_LBL.text =address;
    AddressView.hidden=YES;
    [KVNProgress dismiss];
    limit_only=0;
    MapLocationcall=1;
    [self CallForSearchByShop];
    
    NSLog(@"LAT==%f LOG==%f",annotation.coordinate.latitude,annotation.coordinate.longitude);
    NSLog(@"Address=%@",address);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView==Table)
    {
        NSLog(@"drag Call");
        NSInteger currentOffset = scrollView.contentOffset.y;
        NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - currentOffset <= -2)
        {
            BOOL internet=[AppDelegate connectedToNetwork];
            if (internet)
            {
                if (NoResponseInt==1) {
                    [self CallForSearchByShop];
                }
            }
            else
                [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
            
        }
    }
    
}

- (IBAction)Search_Click:(id)sender
{
    if (Searc_BTN.selected==YES)
    {
        Searc_BTN.selected=NO;
        [Search_IMG setImage:[UIImage imageNamed:@"SearchIcon.png"] forState:UIControlStateNormal];
        SearchBar.hidden=YES;
        Filter_BTN.hidden=NO;
        [SearchBar resignFirstResponder];
        
        SearchDictnory=[NewArr mutableCopy];
        [Table reloadData];
    }
    else
    {
        Searc_BTN.selected=YES;
        [Search_IMG setImage:[UIImage imageNamed:@"Cross"] forState:UIControlStateNormal];
        SearchBar.hidden=NO;
        Filter_BTN.hidden=YES;
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    
    NSLog(@"%@",error.userInfo);
    if([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"Location Services Enabled");
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            UIAlertView    *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                               message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [alert show];
        }
    }
    
    
   // [AppDelegate showErrorMessageWithTitle:@"Warning." message:@"To re-enable, please go to Settings and turn on Location Service for this app." delegate:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
   
    if (currentLocation != nil)
    {
        
        Latitude= currentLocation.coordinate.latitude;
        Logitude= currentLocation.coordinate.longitude;
        
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
        {
            
           // dispatch_once(&predicate, ^{
                //your code here
                [self CallForSearchByShop];
                 [locationManager stopUpdatingLocation];
                locationManager=nil;
           // });
        }
        else
        {
          //  dispatch_once(&predicate, ^{
                //your code here
                [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
                [locationManager stopUpdatingLocation];
                locationManager=nil;
           // });
        }
        // Reverse Geocoding
        NSLog(@"Resolving the Address");
        [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
            if (error == nil && [placemarks count] > 0) {
                placemark = [placemarks lastObject];
                self.Title_LBL.text = [NSString stringWithFormat:@"%@ %@ %@ %@",
                                     placemark.subThoroughfare,
                                    placemark.administrativeArea,
                                     placemark.locality,
                                     placemark.country];
                 NSLog(@" placemarks: %@",  self.Title_LBL.text);
            } else {
                NSLog(@"%@", error.debugDescription);
            }
        } ];
        
    }
    
}

- (IBAction)Menu_Click:(id)sender
{
    [self.rootNav drawerToggle];
}

//#pragma mark - SerachBarDelegate
//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
//{
//    SearchDictnory=[[NSMutableArray alloc]initWithArray:NewArr];
//    [SearchBar resignFirstResponder];
//    [Table reloadData];
//}
//
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//    //SearchBar.showsCancelButton = YES;
//    //MainScroll.hidden=YES;
//}
//
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
//{
//    // SearchBar.showsCancelButton = NO;
//    //MainScroll.hidden=YES;
//    //SearchDictnory=[MainDic mutableCopy];
//    [Table reloadData];
//}
//
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    
//    if([searchText isEqualToString:@""] || searchText==nil)
//    {
//        SearchDictnory=[NewArr mutableCopy];
//        [Table reloadData];
//        return;
//    }
//    
//    resultObjectsArray = [NSMutableArray array];
//    for(NSDictionary *wine in SearchDictnory)
//    {
//        NSString *wineName = [wine objectForKey:@"name"];
//        NSRange range = [wineName rangeOfString:searchText options:NSCaseInsensitiveSearch];
//        if(range.location != NSNotFound)
//            [resultObjectsArray addObject:wine];
//    }
//    
//    SearchDictnory=[resultObjectsArray mutableCopy];
//    NSLog(@"resultObjectsArray=%lu",(unsigned long)resultObjectsArray.count);
//    NSLog(@"tempdict=%@",SearchDictnory);
//    [Table reloadData];
//}
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    
//    if([searchBar.text isEqualToString:@""] || searchBar.text==nil)
//    {
//        SearchDictnory=[NewArr mutableCopy];
//        [Table reloadData];
//        return;
//    }
//    resultObjectsArray = [NSMutableArray array];
//    for(NSDictionary *wine in SearchDictnory)
//    {
//        NSString *wineName = [wine objectForKey:@"name"];
//        NSRange range = [wineName rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
//        if(range.location != NSNotFound)
//            [resultObjectsArray addObject:wine];
//    }
//    
//    SearchDictnory=[resultObjectsArray mutableCopy];
//    NSLog(@"resultObjectsArray=%lu",(unsigned long)resultObjectsArray.count);
//    NSLog(@"tempdict=%@",SearchDictnory);
//    [Table reloadData];
//    [SearchBar resignFirstResponder];
//}


- (IBAction)Filter_click:(id)sender
{
    
    //FilterDict
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        if (!FilterDict)
        {
            [self getFilterData];
        }
        PriceView.hidden=YES;
        FilterView.hidden=NO;
        self.rangeSliderCurrency.hidden=YES;
        
        CatTBL.hidden=NO;
        SelectedShort=0;
        [SearchByCatBTN setBackgroundColor:SelectedButtonColor];
        [SearchByCatBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        [SearchByPriceBTN setTitleColor:UnSelectedButtonColor forState:UIControlStateNormal];
        [SearchByRatBTN setTitleColor:UnSelectedButtonColor forState:UIControlStateNormal];
        [SearchByDistBTN setTitleColor:UnSelectedButtonColor forState:UIControlStateNormal];
        [FreeDelevBTN setTitleColor:UnSelectedButtonColor forState:UIControlStateNormal];
        
        [SearchByPriceBTN setBackgroundColor:[UIColor clearColor]];
        [SearchByRatBTN setBackgroundColor:[UIColor clearColor]];
        [SearchByDistBTN setBackgroundColor:[UIColor clearColor]];
        [FreeDelevBTN setBackgroundColor:[UIColor clearColor]];
        
        [CatTBL reloadData];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    }
    
}

- (IBAction)Pancil_Click:(id)sender
{
    AddressView.hidden=NO;
}

- (IBAction)FilterBack_Ckick:(id)sender
{
    FilterView.hidden=YES;
}

- (IBAction)AllCatBTN_Click:(id)sender
{
    PriceView.hidden=YES;
    CatTBL.hidden=NO;
    self.rangeSliderCurrency.hidden=YES;
    if (sender==SearchByCatBTN)
    {
        SelectedShort=0;
        [SearchByCatBTN setBackgroundColor:SelectedButtonColor];
        [SearchByCatBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [SearchByPriceBTN setTitleColor:UnSelectedButtonColor forState:UIControlStateNormal];
        [SearchByRatBTN setTitleColor:UnSelectedButtonColor forState:UIControlStateNormal];
        [SearchByDistBTN setTitleColor:UnSelectedButtonColor forState:UIControlStateNormal]; 
        [FreeDelevBTN setTitleColor:UnSelectedButtonColor forState:UIControlStateNormal]; 
        
        [SearchByPriceBTN setBackgroundColor:[UIColor clearColor]];
        [SearchByRatBTN setBackgroundColor:[UIColor clearColor]];
        [SearchByDistBTN setBackgroundColor:[UIColor clearColor]];
        [FreeDelevBTN setBackgroundColor:[UIColor clearColor]];
        
    }
    else if (sender==SearchByPriceBTN)
    {
        SelectedShort=1;
        PriceView.hidden=NO;
        CatTBL.hidden=YES;
        self.rangeSliderCurrency.hidden=NO;
        
        [SearchByPriceBTN setBackgroundColor:SelectedButtonColor];
        [SearchByPriceBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [SearchByCatBTN setTitleColor:UnSelectedButtonColor forState:UIControlStateNormal];
        [SearchByRatBTN setTitleColor:UnSelectedButtonColor forState:UIControlStateNormal];
        [SearchByDistBTN setTitleColor:UnSelectedButtonColor forState:UIControlStateNormal];
        [FreeDelevBTN setTitleColor:UnSelectedButtonColor forState:UIControlStateNormal];
        
        [SearchByCatBTN setBackgroundColor:[UIColor clearColor]];
        [SearchByRatBTN setBackgroundColor:[UIColor clearColor]];
        [SearchByDistBTN setBackgroundColor:[UIColor clearColor]];
        [FreeDelevBTN setBackgroundColor:[UIColor clearColor]];
        
    }
    else if (sender==SearchByRatBTN)
    {
        SelectedShort=2;
        
        [SearchByRatBTN setBackgroundColor:SelectedButtonColor];
        [SearchByRatBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [SearchByCatBTN setTitleColor:UnSelectedButtonColor forState:UIControlStateNormal];
        [SearchByPriceBTN setTitleColor:UnSelectedButtonColor forState:UIControlStateNormal];
        [SearchByDistBTN setTitleColor:UnSelectedButtonColor forState:UIControlStateNormal]; 
        [FreeDelevBTN setTitleColor:UnSelectedButtonColor forState:UIControlStateNormal];
        
        [SearchByCatBTN setBackgroundColor:[UIColor clearColor]];
        [SearchByPriceBTN setBackgroundColor:[UIColor clearColor]];
        [SearchByDistBTN setBackgroundColor:[UIColor clearColor]];
        [FreeDelevBTN setBackgroundColor:[UIColor clearColor]];
    }
    else if (sender==SearchByDistBTN)
    {
        SelectedShort=3;
        
        [SearchByDistBTN setBackgroundColor:SelectedButtonColor];
        [SearchByDistBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [SearchByCatBTN setTitleColor:UnSelectedButtonColor forState:UIControlStateNormal]; 
        [SearchByPriceBTN setTitleColor:UnSelectedButtonColor forState:UIControlStateNormal]; 
        [SearchByRatBTN setTitleColor:UnSelectedButtonColor forState:UIControlStateNormal]; 
        [FreeDelevBTN setTitleColor:UnSelectedButtonColor forState:UIControlStateNormal]; 
        
        [SearchByCatBTN setBackgroundColor:[UIColor clearColor]];
        [SearchByPriceBTN setBackgroundColor:[UIColor clearColor]];
        [SearchByRatBTN setBackgroundColor:[UIColor clearColor]];
        [FreeDelevBTN setBackgroundColor:[UIColor clearColor]];
    }
    else if (sender==FreeDelevBTN)
    {
        SelectedShort=4;
        
        [FreeDelevBTN setBackgroundColor:SelectedButtonColor];
        [FreeDelevBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [SearchByCatBTN setTitleColor:UnSelectedButtonColor forState:UIControlStateNormal]; 
        [SearchByPriceBTN setTitleColor:UnSelectedButtonColor forState:UIControlStateNormal]; 
        [SearchByRatBTN setTitleColor:UnSelectedButtonColor forState:UIControlStateNormal]; 
        [SearchByDistBTN setTitleColor:UnSelectedButtonColor forState:UIControlStateNormal]; 
        
        [SearchByCatBTN setBackgroundColor:[UIColor clearColor]];
        [SearchByPriceBTN setBackgroundColor:[UIColor clearColor]];
        [SearchByRatBTN setBackgroundColor:[UIColor clearColor]];
        [SearchByDistBTN setBackgroundColor:[UIColor clearColor]];
    }
    [CatTBL reloadData];
}

#pragma mark TTRangeSliderViewDelegate
-(void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum
{
    if (sender == self.rangeSliderCurrency)
    {
        NSLog(@"Currency slider updated. Min Value: %.0f Max Value: %.0f", selectedMinimum, selectedMaximum);
        MaxPriceSTR=[NSString stringWithFormat:@"%.0f",selectedMaximum];
        
        /*
        NSString *maxval=[NSString stringWithFormat:@"%.0f",selectedMaximum];
        NSMutableDictionary *fliterdic = [[NSMutableDictionary alloc] init];
        [fliterdic setObject:[SortByPriceArr valueForKey:@"filter_value_id"]   forKey:@"filter_value_id"];
        [fliterdic setObject:maxval   forKey:@"filter_value_name"];
        [fliterdic setObject:[SortByPriceArr valueForKey:@"filter_value"]  forKey:@"filter_value"];
        [fliterdic setObject:[filter_idArry objectAtIndex:1]  forKey:@"filter_id"];
        [PriceParsingArr addObject:fliterdic];*/
        
    }
}

- (IBAction)ConfrimFliterBtn_action:(id)sender
{
    if (MaxPriceSTR)
    {
        PriceParsingArr=[[NSMutableArray alloc]init];
        NSMutableDictionary *fliterdic = [[NSMutableDictionary alloc] init];
        [fliterdic setObject:[[SortByPriceArr objectAtIndex:0] valueForKey:@"filter_value_id"]  forKey:@"filter_value_id"];
        [fliterdic setObject:MaxPriceSTR  forKey:@"filter_value_name"];
        [fliterdic setObject:[[SortByPriceArr objectAtIndex:0] valueForKey:@"filter_value"]  forKey:@"filter_value"];
        [PriceParsingArr addObject:fliterdic];
    }
    
    
    
    
    NSMutableArray *Arr=[[NSMutableArray alloc]init];
    for (int i=0; i<filter_idArry.count; i++)
    {
        
        NSMutableDictionary *Catdic=[[NSMutableDictionary alloc]init];
        if (i==0)
        {
            [Catdic setValue:catParsingArr forKey:@"data"];
        }
        if (i==1)
        {
            [Catdic setValue:PriceParsingArr forKey:@"data"];
        }
        if (i==2)
        {
            [Catdic setValue:RatingParsingArr forKey:@"data"];
        }
        if (i==3)
        {
            [Catdic setValue:DistanceParsingArr forKey:@"data"];
        }
        if (i==4)
        {
            [Catdic setValue:FreDelParsingArr forKey:@"data"];
        }
        
        [Catdic setValue:[filter_idArry objectAtIndex:i] forKey:@"filter_id"];
        [Arr addObject:Catdic];
    }
    
    NSError* error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Arr options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *json = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *trimmedString = [json stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    trimmedString = [trimmedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    trimmedString = [trimmedString stringByReplacingOccurrencesOfString:@" " withString:@""];
   
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:getFilterRestorantServiceName  forKey:@"service"];
    [dictParams setObject:trimmedString  forKey:@"filter"];
    
    NSLog(@"filter dictParams===%@",dictParams);
    
    FilterView.hidden=YES;
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,Filter_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleFilterResponse:response];
     }];
}

- (void)handleFilterResponse:(NSDictionary*)response
{
    NSLog(@"filter data response ===%@",response);
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        SearchDictnory=[[NSMutableArray alloc]init];
        NSMutableDictionary *filterData=[response valueForKey:@"result"];
        for (NSDictionary *dic in filterData)
        {
            //NSLog(@"===%@",dic);
            [SearchDictnory addObject:dic];
            
        }
        NewArr=[[NSMutableArray alloc]initWithArray:SearchDictnory];
        [Table reloadData];
        NoResponseInt=0;
    }
    else
    {
        SearchDictnory=[[NSMutableArray alloc]init];
        NewArr=[[NSMutableArray alloc]init];
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:@"No Shops Found." delegate:nil];
        [Table reloadData];
        NoResponseInt=0;
        
       // [self ClearFliterBtn_action:self];
    }
}


- (IBAction)ClearFliterBtn_action:(id)sender
{
    for (NSArray *filtername in FilterDict)
    {
        if ([[filtername valueForKey:@"filter_name"] isEqualToString:@"Search By Category"])
        {
            // Search By Category.
            NSMutableArray *tempCatArr=[[NSMutableArray alloc]init];
            tempCatArr=[filtername valueForKey:@"data"];
            CatselectedArr=[[NSMutableArray alloc]init];
            for (int i= 0; i<tempCatArr.count; i++)
            {
                [CatselectedArr addObject:@"0"];
            }
        }
        else if ([[filtername valueForKey:@"filter_name"] isEqualToString:@"Sort By Distance"])
        {
            // Search By Distance.
            NSMutableArray *tempDistanceArr=[[NSMutableArray alloc]init];
            tempDistanceArr=[filtername valueForKey:@"data"];
            DistanceSelectArr=[[NSMutableArray alloc]init];
            for (int i= 0; i<tempDistanceArr.count; i++)
            {
                [DistanceSelectArr addObject:@"0"];
            }
        }
        else if ([[filtername valueForKey:@"filter_name"] isEqualToString:@"Free Delivery"])
        {
            // Search By FreeDelivery.
            NSMutableArray *tempFreeDelArr=[[NSMutableArray alloc]init];
            tempFreeDelArr=[filtername valueForKey:@"data"];
            FreeDelSelectArr=[[NSMutableArray alloc]init];
            for (int i= 0; i<tempFreeDelArr.count; i++)
            {
                [FreeDelSelectArr addObject:@"0"];
            }
        }
        else if ([[filtername valueForKey:@"filter_name"] isEqualToString:@"Sort By Rating"])
        {
            // Search By FreeDelivery.
            NSMutableArray *tempReviewStarArr=[[NSMutableArray alloc]init];
            tempReviewStarArr=[filtername valueForKey:@"data"];
            ReviewStarSelectArr=[[NSMutableArray alloc]init];
            for (int i= 0; i<tempReviewStarArr.count; i++)
            {
                [ReviewStarSelectArr addObject:@"0"];
            }
        }
        else if ([[filtername valueForKey:@"filter_name"] isEqualToString:@"Sort By Price"])
        {
            // Search By Range Bar.
           // SortByPriceArr=[[NSMutableArray alloc]init];
           // SortByPriceArr=[filtername valueForKey:@"data"];
        }
    }
    catParsingArr=[[NSMutableArray alloc]init];
    PriceParsingArr=[[NSMutableArray alloc]init];
    RatingParsingArr=[[NSMutableArray alloc]init];
    DistanceParsingArr=[[NSMutableArray alloc]init];
    FreDelParsingArr=[[NSMutableArray alloc]init];
    
    [CatTBL reloadData];
    limit_only=0;
    SearchDictnory=[[NSMutableArray alloc]init];
    NewArr=[[NSMutableArray alloc]init];
    [self CallForSearchByShop];
    FilterView.hidden=YES;
}


- (IBAction)AddressBack_Click:(id)sender
{
    AddressView.hidden=YES;
}


@end
