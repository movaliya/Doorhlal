//
//  NearByView.m
//  HalalMeatDelivery
//
//  Created by kaushik on 23/08/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import "NearByView.h"
#import "NearByCell.h"
#import "HalalMeatDelivery.pch"
#import "RestaurantDetailView.h"
#import "UIImageView+WebCache.h"


@interface NearByView ()
{
    NSMutableDictionary *MainDic;
    NSMutableArray *resultObjectsArray;
    NSMutableDictionary *SearchDictnory;
}

@property AppDelegate *appDelegate;

@end

@implementation NearByView
@synthesize TableView,PincodeSTR,Cat_IDSTR,R_disStr;
@synthesize SearchBar,Search_IMG,Searc_BTN;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = [AppDelegate sharedInstance];

    SearchBar.hidden=YES;
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    [SearchBar setImage:[UIImage imageNamed:@"SearchIcon.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];

    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        if (Cat_IDSTR.length>0)
        {
            [self performSelector:@selector(GetRestaruntbyCatID) withObject:nil afterDelay:0.0];
        }
        else if (R_disStr.length>0)
        {
            [self performSelector:@selector(GetRestaruntbyCatID) withObject:nil afterDelay:0.0];
        }
        else
        {
            [self performSelector:@selector(CallForSearchByPincodeResponse) withObject:nil afterDelay:0.0];
        }
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
    
    
    UINib *nib = [UINib nibWithNibName:@"NearByCell" bundle:nil];
    NearByCell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    TableView.rowHeight = cell.frame.size.height;
    [TableView registerNib:nib forCellReuseIdentifier:@"NearByCell"];
}

-(void)GetRestaruntbyCatID
{
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:GerRestByCatIDServiceName  forKey:@"service"];
    
    if (Cat_IDSTR.length>0)
    {
        [dictParams setObject:Cat_IDSTR  forKey:@"cid"];
    }
    else if (R_disStr.length>0)
    {
       [dictParams setObject:Cat_IDSTR  forKey:@"rid"];
    }
    
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,GerRestByCatID_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleResponse:response];
     }];
}

-(void)CallForSearchByPincodeResponse
{
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:SerachByPincodeServiceName  forKey:@"service"];
    [dictParams setObject:PincodeSTR  forKey:@"pin"];
    [dictParams setObject:@"22.2795332"  forKey:@"lat"];
    [dictParams setObject:@"70.7695987"  forKey:@"long"];
    
  

    
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,SerachByPincode_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleResponse:response];
     }];
}

- (void)handleResponse:(NSDictionary*)response
{
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        MainDic=[response valueForKey:@"result"];
        SearchDictnory=[response valueForKey:@"result"];
        [TableView reloadData];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:@"Error" message:@"Nothing to Show" delegate:nil];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)Menu_Click:(id)sender
{
    [self.rootNav drawerToggle];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1; // in your case, there are 3 cells
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return SearchDictnory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NearByCell";
    NearByCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    }
    NSString *Urlstr=[[SearchDictnory valueForKey:@"image_path"] objectAtIndex:indexPath.row];
    Urlstr = [Urlstr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [cell.Rest_IMG sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
    [cell.Rest_IMG setShowActivityIndicatorView:YES];
    
    cell.RestNAME_LBL.text=[[SearchDictnory valueForKey:@"name"] objectAtIndex:indexPath.row];
    cell.Item_LBL.text=[[SearchDictnory valueForKey:@"serving_category"] objectAtIndex:indexPath.row];
    cell.Desc_LBL.text=[[SearchDictnory valueForKey:@"address"] objectAtIndex:indexPath.row];
    cell.Review_LBL.text=[NSString stringWithFormat:@"(%@ Review)",[[SearchDictnory valueForKey:@"count_review"] objectAtIndex:indexPath.row]];
    cell.Dist_LBL.text=[NSString stringWithFormat:@" %@ ",[[SearchDictnory valueForKey:@"distance"] objectAtIndex:indexPath.row]] ;
    
    [cell ReviewCount:[[SearchDictnory valueForKey:@"count_review"] objectAtIndex:indexPath.row]];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        RestaurantDetailView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RestaurantDetailView"];
        
        if (Cat_IDSTR.length>0)
        {
            vcr.R_ID=[[SearchDictnory valueForKey:@"id"]objectAtIndex:indexPath.row];
            vcr.Pin=[[SearchDictnory valueForKey:@"pin"]objectAtIndex:indexPath.row];
        }
        else
        {
            NSArray *arr=[SearchDictnory mutableCopy];
            vcr.RestraorntDic=[arr objectAtIndex:indexPath.row];
        }
        
        [self.navigationController pushViewController:vcr animated:YES];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - photoShotSavedDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection = %li", (long)selectionIndex);
    
}

- (IBAction)Search_Click:(id)sender
{
    if (Searc_BTN.selected==YES)
    {
        Searc_BTN.selected=NO;
        [Search_IMG setImage:[UIImage imageNamed:@"SearchIcon.png"] forState:UIControlStateNormal];
        SearchBar.hidden=YES;
        [SearchBar resignFirstResponder];
        SearchDictnory=[MainDic mutableCopy];
        [TableView reloadData];
    }
    else
    {
        Searc_BTN.selected=YES;
        [Search_IMG setImage:[UIImage imageNamed:@"Cross"] forState:UIControlStateNormal];
        SearchBar.hidden=NO;
        
    }
}
#pragma mark - SerachBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [SearchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //SearchBar.showsCancelButton = YES;
    //MainScroll.hidden=YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
   // SearchBar.showsCancelButton = NO;
    //MainScroll.hidden=YES;
    //SearchDictnory=[MainDic mutableCopy];
    [TableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if([searchText isEqualToString:@""] || searchText==nil)
    {
        SearchDictnory=[MainDic mutableCopy];
        [TableView reloadData];
        return;
    }
    
    resultObjectsArray = [NSMutableArray array];
    for(NSDictionary *wine in MainDic)
    {
        NSString *wineName = [wine objectForKey:@"name"];
        NSRange range = [wineName rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if(range.location != NSNotFound)
            [resultObjectsArray addObject:wine];
    }
    
    SearchDictnory=[resultObjectsArray mutableCopy];
    NSLog(@"resultObjectsArray=%lu",(unsigned long)resultObjectsArray.count);
    NSLog(@"tempdict=%@",SearchDictnory);
    [TableView reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    if([searchBar.text isEqualToString:@""] || searchBar.text==nil)
    {
        SearchDictnory=[MainDic mutableCopy];
        [TableView reloadData];
        return;
    }
    resultObjectsArray = [NSMutableArray array];
    for(NSDictionary *wine in MainDic)
    {
        NSString *wineName = [wine objectForKey:@"name"];
        NSRange range = [wineName rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
        if(range.location != NSNotFound)
            [resultObjectsArray addObject:wine];
    }
    
    SearchDictnory=[resultObjectsArray mutableCopy];
    NSLog(@"resultObjectsArray=%lu",(unsigned long)resultObjectsArray.count);
    NSLog(@"tempdict=%@",SearchDictnory);
    [TableView reloadData];
    [SearchBar resignFirstResponder];
}




@end
