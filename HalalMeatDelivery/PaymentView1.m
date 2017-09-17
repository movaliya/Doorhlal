//
//  PaymentView1.m
//  HalalMeatDelivery
//
//  Created by kaushik on 02/05/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "PaymentView1.h"
#import "PaymentView2.h"
#import "SelectPayment.h"
@interface PaymentView1 ()

@end

@implementation PaymentView1
@synthesize UserCity_txt,UserName_txt,UserEmail_txt,UserAddress_txt,UserPhoneNo_txt,UserPincode_txt;
@synthesize C_ID;

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        //[self getAddressData];
        [self performSelector:@selector(getAddressData) withObject:self afterDelay:1.0 ];

    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
    
}

-(void)getAddressData
{
    NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
    NSString *User_UID=[UserData valueForKey:@"u_id"];
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:GetDeleveryHistory  forKey:@"service"];
    [dictParams setObject:User_UID  forKey:@"uid"];
    
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,Filter_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleGetAddressResponse:response];
     }];
}

- (void)handleGetAddressResponse:(NSDictionary*)response
{
    
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        AddressArr=[[response valueForKey:@"result"] mutableCopy];
        for (NSString *Defaultname in AddressArr)
        {
            if ([[Defaultname valueForKey:@"isDefault"] isEqualToString:@"1"])
            {
                if ([Defaultname valueForKey:@"name"] != (id)[NSNull null])
                {
                    self.UserName_txt.text=[Defaultname valueForKey:@"name"];
                }
                if ([Defaultname valueForKey:@"email"] != (id)[NSNull null])
                {
                    self.UserEmail_txt.text=[Defaultname valueForKey:@"email"];
                }
                if ([Defaultname valueForKey:@"contact_number"] != (id)[NSNull null])
                {
                    self.UserPhoneNo_txt.text=[Defaultname valueForKey:@"contact_number"];
                }
                if ([Defaultname valueForKey:@"pincode"] != (id)[NSNull null])
                {
                    self.UserPincode_txt.text=[Defaultname valueForKey:@"pincode"] ;
                }
                if ([Defaultname valueForKey:@"address"] != (id)[NSNull null])
                {
                    self.UserAddress_txt.text=[Defaultname valueForKey:@"address"] ;
                }
                if ([Defaultname valueForKey:@"city"] != (id)[NSNull null])
                {
                    self.UserCity_txt.text=[Defaultname valueForKey:@"city"] ;
                }
                self.UserEmail_txt.enabled=NO;
                self.UserEmail_txt.textColor=[UIColor grayColor];
            }
        }
    }
    else
    {
        NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
        
        if ([UserData count] != 0)
        {
            
            if ([UserData valueForKey:@"u_name"] != (id)[NSNull null])
            {
                self.UserName_txt.text=[UserData valueForKey:@"u_name"];
            }
            if ([UserData valueForKey:@"u_email"] != (id)[NSNull null])
            {
                self.UserEmail_txt.text=[UserData valueForKey:@"u_email"];
            }
            if ([UserData valueForKey:@"u_phone"] != (id)[NSNull null])
            {
                self.UserPhoneNo_txt.text=[UserData valueForKey:@"u_phone"];
            }
            if ([UserData valueForKey:@"u_pincode"] != (id)[NSNull null])
            {
                self.UserPincode_txt.text=[UserData valueForKey:@"u_pincode"] ;
            }
            if ([UserData valueForKey:@"u_address"] != (id)[NSNull null])
            {
                self.UserAddress_txt.text=[UserData valueForKey:@"u_address"] ;
            }
            if ([UserData valueForKey:@"u_city"] != (id)[NSNull null])
            {
                self.UserCity_txt.text=[UserData valueForKey:@"u_city"] ;
            }
            self.UserEmail_txt.enabled=NO;
            self.UserEmail_txt.textColor=[UIColor grayColor];
            
        }
    }
    
}


- (IBAction)NextBtn_action:(id)sender
{
     self.NextBTN.enabled=NO;
    if ([UserName_txt.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter username" delegate:nil];
        self.NextBTN.enabled=YES;
    }
    else if ([UserAddress_txt.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Address" delegate:nil];
        self.NextBTN.enabled=YES;
    }
    else if ([UserPincode_txt.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Pincode" delegate:nil];
        self.NextBTN.enabled=YES;
    }
    else if ([UserEmail_txt.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Email" delegate:nil];
        self.NextBTN.enabled=YES;
    }
    else if ([UserPhoneNo_txt.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Phone Number" delegate:nil];
        self.NextBTN.enabled=YES;
    }
    else
    {
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
        {
            //[self SendBillDetail];
            [self performSelector:@selector(SendBillDetail) withObject:self afterDelay:0.0 ];
        }
        else
        {
            [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
            self.NextBTN.enabled=YES;
        }
        
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
    [dictParams setObject:UserPincode_txt.text  forKey:@"u_pin"];
    
    [dictParams setObject:UserName_txt.text  forKey:@"u_name"];
    [dictParams setObject:UserEmail_txt.text  forKey:@"u_email"];
    [dictParams setObject:UserPhoneNo_txt.text  forKey:@"u_phone"];
    [dictParams setObject:UserAddress_txt.text  forKey:@"u_address"];
    
    [dictParams setObject:UserCity_txt.text  forKey:@"u_city"];
    [dictParams setObject:@""  forKey:@"u_state"];
    [dictParams setObject:@""  forKey:@"u_country"];
    
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,CardService_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleBillProcessResponse:response];
     }];
}

- (void)handleBillProcessResponse:(NSDictionary*)response
{
   
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
       
        SelectPayment *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SelectPayment"];
        vcr.PayCart_ID=C_ID;
        vcr.PassDatefrom1=self.PassDateNTime;
        [self.navigationController pushViewController:vcr animated:NO];
        [AppDelegate showErrorMessageWithTitle:@"" message:[response objectForKey:@"ack_msg"] delegate:nil];
        self.NextBTN.enabled=YES;
        
    }
    else
    {
        self.NextBTN.enabled=YES;
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
}
- (IBAction)BackBtn_action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
