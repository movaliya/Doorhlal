//
//  OrderHistoryDetailView.m
//  HalalMeatDelivery
//
//  Created by kaushik on 28/08/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import "OrderHistoryDetailView.h"
#import "HostoryDetailCell.h"
#import "UIImageView+WebCache.h"
#import <CoreLocation/CoreLocation.h>

@interface OrderHistoryDetailView ()<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}
@property AppDelegate *appDelegate;
@end

@implementation OrderHistoryDetailView
@synthesize Table,TopView,BottomView,card_id;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = [AppDelegate sharedInstance];
   
    UINib *nib = [UINib nibWithNibName:@"HostoryDetailCell" bundle:nil];
    HostoryDetailCell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    Table.rowHeight = cell.frame.size.height;
    [Table registerNib:nib forCellReuseIdentifier:@"HostoryDetailCell"];
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        [self performSelector:@selector(GetItem_from_cardId) withObject:nil afterDelay:0.0];

    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];


}
-(void)GetItem_from_cardId
{
    NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
    NSString *User_UID=[UserData valueForKey:@"u_id"];
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:get_cart_item_from_cart_idServiceName  forKey:@"service"];
    [dictParams setObject:User_UID  forKey:@"uid"];
    [dictParams setObject:card_id  forKey:@"cid"];
    
    NSLog(@"get card Item Dic=%@",dictParams);
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,get_cart_item_from_cart_id_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleCardItemResponse:response];
     }];
}
- (void)handleCardItemResponse:(NSDictionary*)response
{
    NSLog(@"response histry detail==%@",response);
    
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        MainCardDictnory=[response objectForKey:@"result"];
        
        _DownOrderIDLBL.text=[NSString stringWithFormat:@"Order ID : %@",[MainCardDictnory valueForKey:@"cart_id"]];
        
        if ([[MainCardDictnory valueForKey:@"payment_mode"]isEqualToString:@"Online Payment"])
        {
            _paymentMethodStatus_LBL.text=@"Order Date";
            _date_LBL.text=[MainCardDictnory valueForKey:@"orderdate"];
        }
        else if ([[MainCardDictnory valueForKey:@"payment_mode"]isEqualToString:@"Cash On Delivery"])
        {
            _paymentMethodStatus_LBL.text=[NSString stringWithFormat:@"%@ Date",[MainCardDictnory valueForKey:@"payment_mode"]];
            
            NSString *dateTimeTakeway=[NSString stringWithFormat:@"%@",[MainCardDictnory valueForKey:@"orderdate"]];
            
            _date_LBL.text=dateTimeTakeway;
        }
        else if ([[MainCardDictnory valueForKey:@"payment_mode"]isEqualToString:@"Delivery (Cash On Delivery)"])
        {
            _paymentMethodStatus_LBL.text=[NSString stringWithFormat:@"%@ Date",[MainCardDictnory valueForKey:@"payment_mode"]];
            
            NSString *dateTimeTakeway=[NSString stringWithFormat:@"%@",[MainCardDictnory valueForKey:@"orderdate"]];
            
            _date_LBL.text=dateTimeTakeway;
        }
        else if ([[MainCardDictnory valueForKey:@"payment_mode"]isEqualToString:@"Delivery (Online Payment)"])
        {
            _paymentMethodStatus_LBL.text=[NSString stringWithFormat:@"%@ Date",[MainCardDictnory valueForKey:@"payment_mode"]];
            
            NSString *dateTimeTakeway=[NSString stringWithFormat:@"%@",[MainCardDictnory valueForKey:@"orderdate"]];
            
            _date_LBL.text=dateTimeTakeway;
        }
        else
        {
            _paymentMethodStatus_LBL.text=[NSString stringWithFormat:@"%@ Date",[MainCardDictnory valueForKey:@"payment_mode"]];
            
            NSString *dateTimeTakeway=[NSString stringWithFormat:@"%@ %@",[MainCardDictnory valueForKey:@"take_away_date"],[MainCardDictnory valueForKey:@"take_away_time"]];
            
            _date_LBL.text=dateTimeTakeway;
        }
       
        
        NSString *Urlstr=[MainCardDictnory valueForKey:@"r_image"];
        Urlstr = [Urlstr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [_Restorent_Image sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
        [_Restorent_Image setShowActivityIndicatorView:YES];
         _Total_Quntity_LBl.text=[NSString stringWithFormat:@"%@",[MainCardDictnory valueForKey:@"total_qty"]];
        _SubTotal_LBL.text=[NSString stringWithFormat:@"£ %@",[MainCardDictnory valueForKey:@"sub_total"]];
        _upper_subtotal_LBL.text=[NSString stringWithFormat:@"£ %@",[MainCardDictnory valueForKey:@"sub_total"]];
        _res_phoneLBL.text=[NSString stringWithFormat:@"%@",[[MainCardDictnory valueForKey:@"restorant_details"]valueForKey:@"phone"]];
        _RestAddress.text=[NSString stringWithFormat:@"%@",[[MainCardDictnory valueForKey:@"restorant_details"]valueForKey:@"address"]];
        
        _Payment_MethodLBL.text=[NSString stringWithFormat:@"%@",[MainCardDictnory valueForKey:@"payment_mode"]];
        
        _OrderStatusLBL.text=[NSString stringWithFormat:@"%@",[MainCardDictnory valueForKey:@"orderstatus"]];
        
        NSString *openhr=[NSString stringWithFormat:@"%@",[[MainCardDictnory valueForKey:@"restorant_details"]valueForKey:@"opening_hours"]];
        
        NSString *Closinghr=[NSString stringWithFormat:@"%@",[[MainCardDictnory valueForKey:@"restorant_details"]valueForKey:@"closing_hours"]];
        _openNClosingHourLBL.text=[NSString stringWithFormat:@"%@ To %@",openhr,Closinghr];
        ResLat=[NSString stringWithFormat:@"%@",[[MainCardDictnory valueForKey:@"restorant_details"]valueForKey:@"latitude"]];
        ResLog=[NSString stringWithFormat:@"%@",[[MainCardDictnory valueForKey:@"restorant_details"]valueForKey:@"longitude"]];
        _RestName_LBL.text=[NSString stringWithFormat:@"%@",[[MainCardDictnory valueForKey:@"restorant_details"]valueForKey:@"name"]];
        
        product_detail=[[MainCardDictnory valueForKey:@"items"] valueForKey:@"product_detail"];
        
        NSMutableArray *tempArray=[[NSMutableArray alloc] initWithArray:[product_detail valueForKey:@"name"]];
        NSString *tempProductName=[tempArray componentsJoinedByString: @","];
        _Product_Name.text=tempProductName;
       
        
        [Table reloadData];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
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
    return product_detail.count;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 7.; // you can have your own choice, of course
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] init];
//    headerView.backgroundColor = [UIColor clearColor];
//    return headerView;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HostoryDetailCell";
    HostoryDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    }
    cell.productName.text=[[product_detail valueForKey:@"name"] objectAtIndex:indexPath.row];
    cell.Quantity_LBL.text=[[[MainCardDictnory valueForKey:@"items"]valueForKey:@"qty"] objectAtIndex:indexPath.row];
    cell.Total_LBL.text=[NSString stringWithFormat:@"£ %@",[[product_detail valueForKey:@"sell_price"] objectAtIndex:indexPath.row]];
    
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)Menu_Click:(id)sender
{
    //[self.rootNav drawerToggle];
}


- (IBAction)MapIcon_Click:(id)sender
{
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        [locationManager requestWhenInUseAuthorization];
        [locationManager startUpdatingLocation];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    [AppDelegate showErrorMessageWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    if (currentLocation != nil) {
        
        NSString *coordinateString1 = [NSString stringWithFormat:@"%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude];
        
        NSString *coordinateString2 = [NSString stringWithFormat:@"%@,%@",ResLat,ResLog];
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]])
        {
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?saddr=%@&daddr=%@",coordinateString1,coordinateString2]]];
        }
        else
        {
            NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%@&daddr=%@",coordinateString1,coordinateString2]];
            if ([[UIApplication sharedApplication] canOpenURL:URL])
            {
                [[UIApplication sharedApplication] openURL: URL];
            }
            NSLog(@"Can't use comgooglemaps://");
        }
        
        NSLog(@"coordinateString1=%@",coordinateString1);
        NSLog(@"coordinateString2=%@",coordinateString2);
    }
    [locationManager stopUpdatingLocation];
    locationManager=nil;
}
- (IBAction)BackBtn_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
