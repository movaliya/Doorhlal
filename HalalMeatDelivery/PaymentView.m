//
//  PaymentView.m
//  HalalMeatDelivery
//
//  Created by kaushik on 04/09/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import "PaymentView.h"
#import "ShoppingCartView.h"
#import "ThankYouView.h"
#import "TakeawayThaxView.h"

@interface PaymentView ()
{
    ThankYouView *ThankPOPUp;
}
@property (strong, nonatomic) UIButton *ThanksOK;
@property (strong, nonatomic) UILabel *NamePop;
@property (strong, nonatomic) UILabel *MobilePop;
@property (strong, nonatomic) UILabel *CityPop;
@property (strong, nonatomic) UILabel *AddressPop;

@end

@implementation PaymentView
@synthesize Change_BTN,Scroll_hight,C_ID,ThanksOK;
@synthesize NamePop,MobilePop,CityPop,AddressPop;

- (void)viewDidLoad
{
    [super viewDidLoad];
    Scroll_hight.constant=467;
    _FirstView.layer.cornerRadius=3;
    _SecondView.layer.cornerRadius=3;
    
    NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
    
    if ([UserData count] != 0)
    {
        
        //NSString *User_UID=[[UserData valueForKey:@"u_id"] ;
        self.UserName_txt.text=[UserData valueForKey:@"u_name"] ;
        self.UserEmail_txt.text=[UserData valueForKey:@"u_email"] ;
        self.UserPhoneNo_txt.text=[UserData valueForKey:@"u_phone"];
        self.UserPincode_txt.text=[UserData valueForKey:@"u_pincode"] ;
        self.UserAddress_txt.text=[UserData valueForKey:@"u_address"] ;
        self.UserCity_txt.text=[UserData valueForKey:@"u_city"] ;
        _UserEmail_txt.enabled=NO;
        _UserEmail_txt.textColor=[UIColor grayColor];

         NSLog(@"UserData=%@",UserData);
    }
    NSLog(@"c_id=%@",C_ID);
    
    ThankPOPUp =[[[NSBundle mainBundle]loadNibNamed:@"TakeawayThaxView" owner:nil options:nil]firstObject];
    ThankPOPUp.frame =self.view.frame;
    [self.view addSubview:ThankPOPUp];
    ThankPOPUp.hidden=YES;
    _PlaceOrder_BTN.layer.cornerRadius=3;
    Change_BTN.layer.cornerRadius=3;
    _confrom_btn.layer.cornerRadius=3;
    
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:GregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:1];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [comps setYear:-100];
    [datePicker setMaximumDate:maxDate];
    datePicker.backgroundColor=[UIColor whiteColor];
    
    [datePicker setMinimumDate:[NSDate date]];
    
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.barStyle   = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *itemDone  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:_Time_TXT action:@selector(resignFirstResponder)];
    UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolbar.items = @[itemSpace,itemDone];
    
    _Time_TXT.inputAccessoryView = toolbar;
    [_Time_TXT setInputView:datePicker];
    
    if (IS_IPHONE_4)
    {
        _SecondViewGap.constant=485;
        _TherdViewGap.constant=25;
    }
    if (IS_IPHONE_5)
    {
        _SecondViewGap.constant=485;
        _TherdViewGap.constant=25;

    }
    if (IS_IPHONE_6)
    {
        _SecondViewGap.constant=590;
        _TherdViewGap.constant=120;

    }
    if (IS_IPHONE_6P)
    {
        _SecondViewGap.constant=630;
        _TherdViewGap.constant=160;
    }
}

-(void) dateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)_Time_TXT.inputView;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = picker.date;
    [dateFormat setDateFormat:@"dd-MM-yyyy hh:mm a"];
    
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];

    [dateFormat1 setDateFormat:@"dd-MM-yyyy"];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"hh:mm a"];
    
    //theDate = [dateFormat1 stringFromDate:eventDate];
    //theTime = [timeFormat stringFromDate:eventDate];
    NSLog(@"theDate=%@",theDate);
    NSLog(@"theDate=%@",theTime);
    
    
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    _Time_TXT.text = [NSString stringWithFormat:@"%@",dateString];
}

-(void)Scolltosecondpoint
{
    if (IS_IPHONE_4)
    {
        [self.myscrollview setContentOffset:CGPointMake(0,280) animated:YES];
    }
    if (IS_IPHONE_5)
    {
        [self.myscrollview setContentOffset:CGPointMake(0,200) animated:YES];
    }
    if (IS_IPHONE_6)
    {
        [self.myscrollview setContentOffset:CGPointMake(0,300) animated:YES];
    }
    if (IS_IPHONE_6P)
    {
        [self.myscrollview setContentOffset:CGPointMake(0,315) animated:YES];
    }
}

-(void)ScolltoTherdpoint
{
    if (IS_IPHONE_4)
    {
        [self.myscrollview setContentOffset:CGPointMake(0,666) animated:YES];
    }
    if (IS_IPHONE_5)
    {
        [self.myscrollview setContentOffset:CGPointMake(0,470) animated:YES];
    }
    if (IS_IPHONE_6)
    {
        [self.myscrollview setContentOffset:CGPointMake(0,620) animated:YES];
    }
    if (IS_IPHONE_6P)
    {
        [self.myscrollview setContentOffset:CGPointMake(0,610) animated:YES];
    }
}

-(void)SendBillDetail
{
    
    NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
    NSString *User_UID=[UserData valueForKey:@"u_id"];
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:PlaceOrderTakeAway1ServiceName  forKey:@"service"];
    [dictParams setObject:User_UID  forKey:@"uid"];
    [dictParams setObject:C_ID  forKey:@"cid"];
    [dictParams setObject:_UserPincode_txt.text  forKey:@"u_pin"];
    
    [dictParams setObject:_UserName_txt.text  forKey:@"u_name"];
    [dictParams setObject:_UserEmail_txt.text  forKey:@"u_email"];
    [dictParams setObject:_UserPhoneNo_txt.text  forKey:@"u_phone"];
    [dictParams setObject:_UserAddress_txt.text  forKey:@"u_address"];
    
    [dictParams setObject:_UserCity_txt.text  forKey:@"u_city"];
    [dictParams setObject:@""  forKey:@"u_state"];
    [dictParams setObject:@""  forKey:@"u_country"];
    
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,CardService_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleBillProcessResponse:response];
     }];
}

- (void)handleBillProcessResponse:(NSDictionary*)response
{
    NSLog(@"respose bill process=%@",response);
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        if (IS_IPHONE_4)
        {
            Scroll_hight.constant=666;
        }
        if (IS_IPHONE_5)
        {
            Scroll_hight.constant=666;
        }
        if (IS_IPHONE_6)
        {
            Scroll_hight.constant=880;
        }
        if (IS_IPHONE_6P)
        {
            Scroll_hight.constant=960;
        }
        
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
        _SubTotal_LBL.text=[NSString stringWithFormat:@"£ %@",[response valueForKey:@"sub_total"]];
        _ShippingCharge_LBL.text= [NSString stringWithFormat:@"+ £ %@",[response valueForKey:@"shipping_charge"]];
        _ShippingDiscount_LBL.text=[NSString stringWithFormat:@"- £ %@",[response valueForKey:@"shipping_discount"]];
        _Grand_Total_LBL.text=[NSString stringWithFormat:@"£ %@",[response valueForKey:@"final_total"]];
        _TakeAwayDateTime.text=[NSString stringWithFormat:@"%@ %@",self.theDate,self.theTime];
        [Change_BTN setTitle:@"CHANGE" forState:UIControlStateNormal];
        
        _UserName_txt.enabled=NO;
        _UserEmail_txt.enabled=NO;
        _UserCity_txt.enabled=NO;
        _UserPhoneNo_txt.enabled=NO;
        _UserPincode_txt.enabled=NO;
        _UserAddress_txt.enabled=NO;
        
        [self Scolltosecondpoint];
        
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
}


- (IBAction)Change_Click:(id)sender
{
    if ([Change_BTN.titleLabel.text isEqualToString:@"CHANGE"])
    {
        _UserName_txt.enabled=YES;
        _UserEmail_txt.enabled=YES;
        //_UserAddress_txt.enabled=YES;
        _UserPhoneNo_txt.enabled=YES;
        _UserPincode_txt.enabled=YES;
        _UserCity_txt.enabled=YES;
        [_UserName_txt becomeFirstResponder];
        [Change_BTN setTitle:@"SAVE & NEXT" forState:UIControlStateNormal];
    }
    else
    {
        if ([_UserName_txt.text isEqualToString:@""])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter username" delegate:nil];
        }
        else if ([_UserAddress_txt.text isEqualToString:@""])
        {
            
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Address" delegate:nil];
        }
        else if ([_UserPincode_txt.text isEqualToString:@""])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Pincode" delegate:nil];
        }
        else if ([_UserEmail_txt.text isEqualToString:@""])
        {
            
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Email" delegate:nil];
        }
        else if ([_UserPhoneNo_txt.text isEqualToString:@""])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Phone Number" delegate:nil];
        }
        else
        {
            BOOL internet=[AppDelegate connectedToNetwork];
            if (internet)
            {
                [self SendBillDetail];
            }
            else
                [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
        }
    }
}

- (IBAction)DateConfrim_Action:(id)sender
{
    
    //CONFORM
    if ([self.confrom_btn.titleLabel.text isEqualToString:@"CHANGE"])
    {
        _Time_TXT.enabled=YES;
        _UserEmail_txt.textColor=[UIColor blackColor];
        [Change_BTN setTitle:@"CONFORM" forState:UIControlStateNormal];
    }
    else
    {
        if (![_Time_TXT.text isEqualToString:@""])
        {
            BOOL internet=[AppDelegate connectedToNetwork];
            if (internet)
            {
                
                NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
                NSString *User_UID=[UserData valueForKey:@"u_id"] ;
                
                NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
                [dictParams setObject:r_p  forKey:@"r_p"];
                [dictParams setObject:PlaceOrderTakeAway1_1DateServiceName  forKey:@"service"];
                [dictParams setObject:User_UID  forKey:@"uid"];
                [dictParams setObject:C_ID  forKey:@"cid"];
                [dictParams setObject:self.theTime  forKey:@"take_away_time"];
                [dictParams setObject:self.theDate  forKey:@"take_away_date"];
                
                NSLog(@"Date confrim Dic=%@",dictParams);
                
                [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,CardService_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
                 {
                     [self handleDateConfrimResponse:response];
                 }];
            }
            else
                [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
           
        }
        else
        {
            [AppDelegate showErrorMessageWithTitle:@"Alert..!" message:@"Please select Date and Time." delegate:nil];
        }
    }
    
}

- (void)handleDateConfrimResponse:(NSDictionary*)response
{
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
        if (IS_IPHONE_4)
        {
            Scroll_hight.constant=950;
        }
        if (IS_IPHONE_5)
        {
            Scroll_hight.constant=950;
        }
        if (IS_IPHONE_6)
        {
            Scroll_hight.constant=1200;
        }
        if (IS_IPHONE_6P)
        {
            Scroll_hight.constant=1260;
        }
        
        _Time_TXT.enabled=NO;
        _UserEmail_txt.textColor=[UIColor grayColor];
        [self.confrom_btn setTitle:@"CHANGE" forState:UIControlStateNormal];
        
        [self ScolltoTherdpoint];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
}

- (IBAction)PlaceOrder_Action:(id)sender
{
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
        NSString *User_UID=[UserData valueForKey:@"u_id"] ;
        
        NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
        [dictParams setObject:r_p  forKey:@"r_p"];
        [dictParams setObject:PlaceOrderTakeAway2ServiceName  forKey:@"service"];
        [dictParams setObject:User_UID  forKey:@"uid"];
        [dictParams setObject:C_ID  forKey:@"cid"];
        
        
        NSLog(@"placeorder change Dic=%@",dictParams);
        
        [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,CardService_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
         {
             [self handlePlaceOrderResponse:response];
         }];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
    
}

- (void)handlePlaceOrderResponse:(NSDictionary*)response
{
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        take_away_address=[[response objectForKey:@"result"] objectForKey:@"take_away_address"];
        [self ShowPOPUP];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
}
#pragma mark - pop AlertView;

-(void)ShowPOPUP
{
    [ThankPOPUp bringSubviewToFront:self.view];
    ThankPOPUp.hidden=NO;
    
    ThanksOK= (UIButton *)[ThankPOPUp viewWithTag:23];
    ThanksOK.layer.cornerRadius=3.5;
    [ThanksOK addTarget:self action:@selector(ThanksOK_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    NamePop= (UILabel *)[ThankPOPUp viewWithTag:100];
    MobilePop= (UILabel *)[ThankPOPUp viewWithTag:101];
    CityPop= (UILabel *)[ThankPOPUp viewWithTag:102];
    AddressPop= (UILabel *)[ThankPOPUp viewWithTag:103];
    
    
    AddressPop.numberOfLines = 0;
    [AddressPop sizeToFit];
    
    NamePop.text=[take_away_address valueForKey:@"name"];
    MobilePop.text=[take_away_address valueForKey:@"phone"];
    CityPop.text=[take_away_address valueForKey:@"city"];
    AddressPop.text=[take_away_address valueForKey:@"address"];
    
}

-(void)ThanksOK_Click:(id)sender
{
    ThankPOPUp.hidden=YES;
    
    ShoppingCartView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ShoppingCartView"];
    [self.navigationController pushViewController:vcr animated:NO];
}

- (IBAction)Back_Click:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
    
}



-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
