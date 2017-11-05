//
//  CreateNewAddressView.m
//  HalalMeatDelivery
//
//  Created by kaushik on 03/05/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "CreateNewAddressView.h"
#import "HalalMeatDelivery.pch"

@interface CreateNewAddressView ()

@end

@implementation CreateNewAddressView
@synthesize Submit_BTN,AddressDic,CheckAddresscount;
@synthesize UserName_TXT,Email_TXT,Mobile_TXT,Post_TXT,Address_TXT,City_TXT,State_TXT,Address2_TXT;

- (void)viewDidLoad
{
    [super viewDidLoad];
   // [KmyappDelegate SetimageinAndPrefixTextfield:Mobile_TXT:@"IconPhone"];
    
    Submit_BTN.layer.cornerRadius=20;
    
    if (AddressDic.count>0)
    {
        [self SetaddressData];
    }
    
}

-(void)SetaddressData
{
    UserName_TXT.text=[AddressDic valueForKey:@"name"];
    Email_TXT.text=[AddressDic valueForKey:@"email"];
    Mobile_TXT.text=[AddressDic valueForKey:@"contact_number"];
    Post_TXT.text=[AddressDic valueForKey:@"pincode"];
    Address_TXT.text=[AddressDic valueForKey:@"address"];
    Address2_TXT.text=[AddressDic valueForKey:@"address2"];
    City_TXT.text=[AddressDic valueForKey:@"city"];
    State_TXT.text=[AddressDic valueForKey:@"state"];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)Back_Click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)Submit_Click:(id)sender
{
     if ([Email_TXT.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter emailaddress" delegate:nil];
    }
    else if ([Mobile_TXT.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter mobile number" delegate:nil];
    }
    else if ([Post_TXT.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter post code" delegate:nil];
    }
    else if ([Address_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter address" delegate:nil];
    }
    else if ([City_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter city" delegate:nil];
    }
    else if ([State_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter State" delegate:nil];
    }
    else
    {
        if (![AppDelegate IsValidEmail:Email_TXT.text])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter valid email" delegate:nil];
        }
        else if (![AppDelegate myMobileNumberValidate:Mobile_TXT.text])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please Enter a Valid Mobile number" delegate:nil];
        }
        else
        {
            BOOL internet=[AppDelegate connectedToNetwork];
            if (internet)
            {
                if (AddressDic.count>0)
                {
                    [self UpdateAddressData];
                }
                else
                {
                    [self AddAddressData];
                }
            }
            else
                [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
        }
    }
}

// Add new address.
-(void)AddAddressData
{
    //http://bulkbox.in/feedmemeat/service/service_general.php?r_p=1224&service=delivery_address_service&uid=1&name=Jai&address=402ajsdlksj&email=ajk@gmail.com&contact_number=9978078494&city=Vervala&state=punjab&country=India&pincode=336005&isDefault=1&mode=add
    //if isDefault =1 then it will set new address as default

    NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
    NSString *User_UID=[UserData valueForKey:@"u_id"];
    NSString *User_Name=[UserData valueForKey:@"u_name"];
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:AddDeleveryAddress  forKey:@"service"];
    [dictParams setObject:User_UID  forKey:@"uid"];
    
    [dictParams setObject:User_Name  forKey:@"name"];
    [dictParams setObject:Address_TXT.text  forKey:@"address"];
    [dictParams setObject:Address2_TXT.text  forKey:@"address2"];
    [dictParams setObject:Email_TXT.text  forKey:@"email"];
    [dictParams setObject:Mobile_TXT.text  forKey:@"contact_number"];
    [dictParams setObject:City_TXT.text  forKey:@"city"];
    [dictParams setObject:State_TXT.text  forKey:@"state"];
    [dictParams setObject:Post_TXT.text  forKey:@"pincode"];
    
    [dictParams setObject:User_UID  forKey:@"uid"];
    [dictParams setObject:@"add"  forKey:@"mode"];

    if (CheckAddresscount==NO)
    {
        [dictParams setObject:User_UID  forKey:@"isDefault"];

    }
    
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,Filter_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleGetFilterResponse:response];
     }];
}

- (void)handleGetFilterResponse:(NSDictionary*)response
{
    NSLog(@"GetFilterResponse ===%@",response);
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        [AppDelegate showErrorMessageWithTitle:nil message:[response objectForKey:@"ack_msg"] delegate:nil];
        [self performSelector:@selector(Back_Click:) withObject:nil afterDelay:0.2];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:nil message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
}

// Add new address.
-(void)UpdateAddressData
{
   // http://bulkbox.in/door2door/service/service_general.php?r_p=1224&service=delivery_address_service&uid=21&name=Jai&address=402ajsdlksj&email=ajk@gmail.com&contact_number=9978078494&city=Vervala&state=punjab&country=India&pincode=336005&isDefault=1&mode=edit&delivery_address_id=4
    
    //if isDefault =1 then it will set new address as default
    
    NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
    NSString *User_UID=[UserData valueForKey:@"u_id"];
    NSString *User_Name=[UserData valueForKey:@"u_name"];
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:AddDeleveryAddress  forKey:@"service"];
    [dictParams setObject:User_UID  forKey:@"uid"];

    [dictParams setObject:User_Name  forKey:@"name"];
    [dictParams setObject:Address_TXT.text  forKey:@"address"];
    [dictParams setObject:Address2_TXT.text  forKey:@"address2"];
    [dictParams setObject:Email_TXT.text  forKey:@"email"];
    [dictParams setObject:Mobile_TXT.text  forKey:@"contact_number"];
    [dictParams setObject:City_TXT.text  forKey:@"city"];
    [dictParams setObject:State_TXT.text  forKey:@"state"];
    [dictParams setObject:Post_TXT.text  forKey:@"pincode"];
    [dictParams setObject:User_UID  forKey:@"uid"];
    [dictParams setObject:@"edit"  forKey:@"mode"];
    [dictParams setObject:[AddressDic valueForKey:@"isDefault"]  forKey:@"isDefault"];
    [dictParams setObject:[AddressDic valueForKey:@"id"]  forKey:@"delivery_address_id"];
    
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,Filter_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleUpdateAddressResponse:response];
     }];
}

- (void)handleUpdateAddressResponse:(NSDictionary*)response
{
    NSLog(@"GetFilterResponse ===%@",response);
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        [AppDelegate showErrorMessageWithTitle:nil message:[response objectForKey:@"ack_msg"] delegate:nil];
        [self performSelector:@selector(Back_Click:) withObject:nil afterDelay:0.2];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:nil message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
}

@end
