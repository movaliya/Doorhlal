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
#import "PaymentAddressCell.h"
#import "CreateNewAddressView.h"



#define ButtonColor [UIColor colorWithRed:242.0/255.0 green:18.0/255.0 blue:43.0/255.0 alpha:1.0]
#define DefaultBTNColor [UIColor colorWithRed:25.0/255.0 green:123.0/255.0 blue:48.0/255.0 alpha:1.0]
@interface PaymentView1 ()

@end

@implementation PaymentView1
@synthesize UserCity_txt,UserName_txt,UserEmail_txt,UserAddress_txt,UserPhoneNo_txt,UserPincode_txt;
@synthesize C_ID;
@synthesize TBL,AddressTBLView;

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [KmyappDelegate SetimageinAndPrefixTextfield:UserPhoneNo_txt:@"IconPhone"];
    AddressArr=[[NSMutableArray alloc]init];
    SelectedAddress=[[NSMutableArray alloc]init];
    
    
    UINib *nib = [UINib nibWithNibName:@"PaymentAddressCell" bundle:nil];
    PaymentAddressCell *cell2 = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    TBL.rowHeight = cell2.frame.size.height;
    [TBL registerNib:nib forCellReuseIdentifier:@"PaymentAddressCell"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
        [AddressTBLView setHidden:NO];
        [TBL reloadData];
    }
    else
    {
        [AddressTBLView setHidden:YES];
        NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
        
        if ([UserData count] != 0)
        {
            NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
            NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
            
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"country-calling-codes" ofType:@"json"];
            NSData *content = [[NSData alloc] initWithContentsOfFile:filePath];
            NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:content options:kNilOptions error:nil];
            
            NSArray *filtered = [json filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(code contains[c] %@)", countryCode]];
            
            NSString *callingCode=[NSString stringWithFormat:@"+%@",[[filtered valueForKey:@"callingCode"] objectAtIndex:0]];
            
            
            
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
                NSString *mobilenumber=[UserData valueForKey:@"u_phone"];
                mobilenumber = [mobilenumber stringByReplacingOccurrencesOfString:callingCode withString:@""];
                self.UserPhoneNo_txt.text=mobilenumber;
            }
            if ([UserData valueForKey:@"u_pincode"] != (id)[NSNull null])
            {
                self.UserPincode_txt.text=[UserData valueForKey:@"u_pincode"] ;
            }
            if ([UserData valueForKey:@"u_address"] != (id)[NSNull null])
            {
                self.houseno_TXT.text=[UserData valueForKey:@"u_address"] ;
            }
            if ([UserData valueForKey:@"u_address2"] != (id)[NSNull null])
            {
                self.street_TXT.text=[UserData valueForKey:@"u_address2"] ;
            }
            if ([UserData valueForKey:@"u_city"] != (id)[NSNull null])
            {
                self.UserCity_txt.text=[UserData valueForKey:@"u_city"] ;
            }
            if ([UserData valueForKey:@"u_state"] != (id)[NSNull null])
            {
                self.state_TXT.text=[UserData valueForKey:@"u_state"] ;
            }
            if ([UserData valueForKey:@"u_country"] != (id)[NSNull null])
            {
                self.country_TXT.text=[UserData valueForKey:@"u_country"] ;
            }
           // self.UserEmail_txt.enabled=NO;
            //self.UserEmail_txt.textColor=[UIColor grayColor];
            
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8.0f; // you can have your own choice, of course
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return AddressArr.count; // in your case, there are 3 cells
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PaymentAddressCell";
    PaymentAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    }
    
    if ([[[AddressArr objectAtIndex:indexPath.section]valueForKey:@"isDefault"] isEqualToString:@"1"])
    {
        cell.DefailtBTN.backgroundColor=DefaultBTNColor;
        [cell.DefailtBTN setTitle:@"SELECTED" forState:UIControlStateNormal];
        SelectedAddress=[AddressArr objectAtIndex:indexPath.section];
    }
    else
    {
        cell.DefailtBTN.backgroundColor=ButtonColor;
    }
    
    cell.Name_LBL.text=[NSString stringWithFormat:@"Name : %@",[[AddressArr objectAtIndex:indexPath.section]valueForKey:@"name"]];
    cell.Address_LBL.text=[NSString stringWithFormat:@"Address : %@",[[AddressArr objectAtIndex:indexPath.section]valueForKey:@"address"]];
    cell.Email_LBL.text=[NSString stringWithFormat:@"Email : %@",[[AddressArr objectAtIndex:indexPath.section]valueForKey:@"email"]];
    cell.Contact_LBL.text=[NSString stringWithFormat:@"Contact Number : %@",[[AddressArr objectAtIndex:indexPath.section]valueForKey:@"contact_number"]];
    
    
    cell.Delete_BTN.tag=indexPath.section;
    cell.Edit_BTN.tag=indexPath.section;
    cell.DefailtBTN.tag=indexPath.section;
    
   
    [cell.Edit_BTN addTarget:self action:@selector(EditBTN_Click:) forControlEvents:UIControlEventTouchUpInside];
    [cell.DefailtBTN addTarget:self action:@selector(SelectBTN_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
-(void)SelectBTN_Click:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    NSLog(@"TAG==%ld",(long)btn.tag);
    
    [self SetDefaultAddress:[[AddressArr objectAtIndex:btn.tag] valueForKey:@"id"]];
}
-(void)SetDefaultAddress :(NSString *)DeliveryAddress_idStr
{
    
    NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
    NSString *User_UID=[UserData valueForKey:@"u_id"];
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:SetDefautAddress  forKey:@"service"];
    [dictParams setObject:User_UID  forKey:@"uid"];
    [dictParams setObject:DeliveryAddress_idStr  forKey:@"delivery_address_id"];
    
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,Filter_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleSetDefaultAddress:response];
     }];
}

- (void)handleSetDefaultAddress:(NSDictionary*)response
{
    NSLog(@"GetFilterResponse ===%@",response);
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        [AppDelegate showErrorMessageWithTitle:nil message:[response objectForKey:@"result"] delegate:nil];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:nil message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
    [self getAddressData];
}
-(void)EditBTN_Click:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    
    CreateNewAddressView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CreateNewAddressView"];
    if (AddressArr.count>0)
    {
        vcr.CheckAddresscount=YES;
    }
    else
    {
        vcr.CheckAddresscount=NO;
    }
    vcr.AddressDic=[AddressArr objectAtIndex:btn.tag];
    [self.navigationController pushViewController:vcr animated:YES];
}

- (IBAction)NextBtn_action:(id)sender
{
     self.NextBTN.enabled=NO;
    if (AddressArr.count==0)
    {
        
        if ([_houseno_TXT.text isEqualToString:@""])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter House no" delegate:nil];
            self.NextBTN.enabled=YES;
        }
        if ([_street_TXT.text isEqualToString:@""])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Street" delegate:nil];
            self.NextBTN.enabled=YES;
        }
        
        else if ([UserPincode_txt.text isEqualToString:@""])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Zip code" delegate:nil];
            self.NextBTN.enabled=YES;
        }
        else if ([UserEmail_txt.text isEqualToString:@""])
        {
            
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Email" delegate:nil];
            self.NextBTN.enabled=YES;
        }
        else if ([UserCity_txt.text isEqualToString:@""])
        {
            
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter City" delegate:nil];
            self.NextBTN.enabled=YES;
        }
        else if ([_state_TXT.text isEqualToString:@""])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter State" delegate:nil];
            self.NextBTN.enabled=YES;
        }
        else if ([_country_TXT.text isEqualToString:@""])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Country" delegate:nil];
            self.NextBTN.enabled=YES;
        }
        else if ([UserPhoneNo_txt.text isEqualToString:@""])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Mobile Number" delegate:nil];
            self.NextBTN.enabled=YES;
        }
        else
        {
            
            if (![AppDelegate myMobileNumberValidate:UserPhoneNo_txt.text])
            {
                [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please Enter a Valid Mobile number" delegate:nil];
            }
            else
            {
                BOOL internet=[AppDelegate connectedToNetwork];
                if (internet)
                {
                    
                    [self performSelector:@selector(SendBillDetail) withObject:self afterDelay:0.0 ];
                }
                else
                {
                    self.NextBTN.enabled=YES;
                    [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
                }
            }
            
        }
    }
    else
    {
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
        {
            if (SelectedAddress.count==0)
            {
                [AppDelegate showErrorMessageWithTitle:@"" message:@"Please Select Address." delegate:nil];
                 self.NextBTN.enabled=YES;
            }
            else
            {
                [self performSelector:@selector(SendBillDetail) withObject:self afterDelay:0.0 ];
            }
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
      NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    if (AddressArr.count==0)
    {
        NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
        NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"country-calling-codes" ofType:@"json"];
        NSData *content = [[NSData alloc] initWithContentsOfFile:filePath];
        NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:content options:kNilOptions error:nil];
        
        NSArray *filtered = [json filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(code contains[c] %@)", countryCode]];
        
        NSString *callingCode=[NSString stringWithFormat:@"+%@",[[filtered valueForKey:@"callingCode"] objectAtIndex:0]];
        NSString *phoneStr=[NSString stringWithFormat:@"%@%@",callingCode,UserPhoneNo_txt.text];
        
        NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
        NSString *User_UID=[UserData valueForKey:@"u_id"];
        
        
        [dictParams setObject:r_p  forKey:@"r_p"];
        [dictParams setObject:PlaceOrderTakeAway1ServiceName  forKey:@"service"];
        [dictParams setObject:User_UID  forKey:@"uid"];
        [dictParams setObject:C_ID  forKey:@"cid"];
        [dictParams setObject:UserPincode_txt.text  forKey:@"u_pin"];
        
        [dictParams setObject:[UserData valueForKey:@"u_name"]  forKey:@"u_name"];
        [dictParams setObject:UserEmail_txt.text  forKey:@"u_email"];
        [dictParams setObject:phoneStr  forKey:@"u_phone"];
        [dictParams setObject:_houseno_TXT.text  forKey:@"u_address"];
        [dictParams setObject:_street_TXT.text  forKey:@"u_address2"];
        
        [dictParams setObject:UserCity_txt.text  forKey:@"u_city"];
        [dictParams setObject:_street_TXT.text  forKey:@"u_state"];
        [dictParams setObject:_country_TXT.text  forKey:@"u_country"];
    }
    else
    {
        NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
        NSString *User_UID=[UserData valueForKey:@"u_id"];
        
        
        [dictParams setObject:r_p  forKey:@"r_p"];
        [dictParams setObject:PlaceOrderTakeAway1ServiceName  forKey:@"service"];
        [dictParams setObject:User_UID  forKey:@"uid"];
        [dictParams setObject:C_ID  forKey:@"cid"];
        [dictParams setObject:[SelectedAddress valueForKey:@"pincode"]  forKey:@"u_pin"];
        
        [dictParams setObject:[SelectedAddress valueForKey:@"name"]  forKey:@"u_name"];
        [dictParams setObject:[SelectedAddress valueForKey:@"email"]  forKey:@"u_email"];
        [dictParams setObject:[SelectedAddress valueForKey:@"contact_number"]  forKey:@"u_phone"];
        [dictParams setObject:[SelectedAddress valueForKey:@"address"]  forKey:@"u_address"];
        [dictParams setObject:[SelectedAddress valueForKey:@"address2"]  forKey:@"u_address2"];
        
        [dictParams setObject:[SelectedAddress valueForKey:@"city"]  forKey:@"u_city"];
        [dictParams setObject:[SelectedAddress valueForKey:@"state"]  forKey:@"u_state"];
        [dictParams setObject:@""  forKey:@"u_country"];
    }
   
    
    
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

#define MAX_LENGTH 10

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==self.UserPhoneNo_txt)
    {
        if (UserPhoneNo_txt.text.length >= MAX_LENGTH && range.length == 0)
        {
            return NO; // return NO to not change text
        }
        else
        {
            return YES;
        }
    }
    return YES;
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
