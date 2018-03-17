//
//  ProfileView.m
//  HalalMeatDelivery
//
//  Created by kaushik on 05/09/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import "ProfileView.h"
#import "PasswordView.h"
#import "AppDelegate.h"
#import "HalalMeatDelivery.pch"
#import <QuartzCore/QuartzCore.h>

@interface ProfileView ()<UITextFieldDelegate>
{
    PasswordView *POPView;

}
@property AppDelegate *appDelegate;

@property (strong, nonatomic) UIButton *POPCancel;
@property (strong, nonatomic) UIButton *POPSubmit;
@property (strong, nonatomic) UITextField *POPOldPAss;
@property (strong, nonatomic) UITextField *POPNewPAss;
@property (strong, nonatomic) UITextField *POPConPAss;

@end

@implementation ProfileView
@synthesize Name_TXT,Email_TXT,Phone_TXT,PinCode_TXT,Address_TXT,City_TXT,State_TXT,Address2_TXT,Country_TXT;
@synthesize Update_BTN,ChangePass_BTN;
@synthesize POPCancel,POPSubmit,POPOldPAss,POPNewPAss,POPConPAss;

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prefersStatusBarHidden];
    
    [KmyappDelegate SetimageinTextfield:Name_TXT :@"UserIcon"];
    [KmyappDelegate SetimageinTextfield:Email_TXT :@"Email_Icon"];
    [KmyappDelegate SetimageinTextfield:Address_TXT :@"AddressIcon"];
    [KmyappDelegate SetimageinTextfield:Address2_TXT :@"AddressIcon"];
    [KmyappDelegate SetimageinTextfield:PinCode_TXT :@"PinIcon"];
    [KmyappDelegate SetimageinTextfield:Country_TXT :@"IconGloble"];
    
    [KmyappDelegate SetimageinAndPrefixTextfield:Phone_TXT:@"MobileIcon"];

    
    [KmyappDelegate SetimageinTextfield:City_TXT :@"IconGloble"];
    [KmyappDelegate SetimageinTextfield:State_TXT :@"IconGloble"];
    
    [KmyappDelegate SetbuttonCorner:Update_BTN];
    [KmyappDelegate SetbuttonCorner:ChangePass_BTN];
    
    //[State_TXT addTarget:self action:@selector(StateTXTActive:) forControlEvents:UIControlEventEditingDidBegin];
    
    self.statedropdownTBL.hidden=YES;
    self.statedropdownTBL.layer.cornerRadius=10;

    self.stateDropdwnTblHeight.constant = 0;
   // [State_TXT setInputView:self.statedropdownTBL];
    
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
   
       NSString *filePath = [[NSBundle mainBundle] pathForResource:@"country-calling-codes" ofType:@"json"];
    NSData *content = [[NSData alloc] initWithContentsOfFile:filePath];
    dropDwonARR = [NSJSONSerialization JSONObjectWithData:content options:kNilOptions error:nil];
    
    NSArray *filtered = [dropDwonARR filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(code contains[c] %@)", countryCode]];
    
    NSString *callingCode=[NSString stringWithFormat:@"+%@",[[filtered valueForKey:@"callingCode"] objectAtIndex:0]];

    
    // Initialize the appDelegate property.
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    POPView =[[[NSBundle mainBundle]loadNibNamed:@"PasswordView" owner:nil options:nil]firstObject];
    POPView.frame =self.view.frame;
    [self.view addSubview:POPView];
    POPView.hidden=YES;
    
    //23.0225 lat
    //72.5714 log
    
    
    // Fill User Data From Dic
    
    NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
    NSString *mobilenumber=[UserData valueForKey:@"u_phone"];
    mobilenumber = [mobilenumber stringByReplacingOccurrencesOfString:callingCode withString:@""];
    
    self.Name_TXT.text=[UserData valueForKey:@"u_name"];
    self.Email_TXT.text=[UserData valueForKey:@"u_email"];
    self.Phone_TXT.text=mobilenumber;
    self.PinCode_TXT.text=[UserData valueForKey:@"u_pincode"];
    self.Address_TXT.text=[UserData valueForKey:@"u_address"];
    self.City_TXT.text=[UserData valueForKey:@"u_city"];
    self.State_TXT.text=[UserData valueForKey:@"u_state"];
    self.Country_TXT.text=[UserData valueForKey:@"u_country"];
    self.Address2_TXT.text=[UserData valueForKey:@"u_address2"];
    Email_TXT.enabled=NO;
    Email_TXT.textColor=[UIColor grayColor];
    
    NSString *LoginType = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"USERLOGINTYPE"];
    
    // Check User Login Type
    if (LoginType.length!=0)
    {
        if ([LoginType isEqualToString:@"social"])
        {
            ChangePass_BTN.hidden=YES;
        }
        else
        {
            ChangePass_BTN.hidden=NO;
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)Back_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)Update_Click:(id)sender
{
    if ([Name_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter username" delegate:nil];
    }
    else if ([Address_TXT.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Address" delegate:nil];
    }
    else if ([PinCode_TXT.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Zip Code" delegate:nil];
    }
    else if ([Email_TXT.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Email" delegate:nil];
    }
    else if ([Phone_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Mobile Number" delegate:nil];
    }
    else if ([State_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter State" delegate:nil];
    }
    else if ([City_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter City" delegate:nil];
    }
    else if ([Country_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Country" delegate:nil];
    }
    else
    {
       if (![AppDelegate myMobileNumberValidate:Phone_TXT.text])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please Enter a Valid Mobile number" delegate:nil];
        }
        else
        {
            BOOL internet=[AppDelegate connectedToNetwork];
            if (internet)
            {
                [self CallprofileService];
                
            }
            else
                [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
        }
        
    }
}


-(void)CallprofileService
{
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    NSArray *filtered = [dropDwonARR filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(code contains[c] %@)", countryCode]];
    
    NSString *callingCode=[NSString stringWithFormat:@"+%@",[[filtered valueForKey:@"callingCode"] objectAtIndex:0]];
    
    NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
    NSString *User_UID=[UserData valueForKey:@"u_id"];
    NSString *phoneStr=[NSString stringWithFormat:@"%@%@",callingCode,Phone_TXT.text];
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    
    [dictParams setObject:UpdateProfileServiceName  forKey:@"service"];
    [dictParams setObject:User_UID  forKey:@"uid"];
   // [dictParams setObject:Email_TXT.text  forKey:@"u_email"];
    [dictParams setObject:phoneStr  forKey:@"u_phone"];
    [dictParams setObject:Name_TXT.text  forKey:@"u_name"];
    [dictParams setObject:Address_TXT.text  forKey:@"u_address"];
    [dictParams setObject:PinCode_TXT.text  forKey:@"u_pin"];
    [dictParams setObject:City_TXT.text  forKey:@"u_city"];
    [dictParams setObject:State_TXT.text  forKey:@"u_state"];
    [dictParams setObject:Country_TXT.text  forKey:@"u_country"];
    [dictParams setObject:Address2_TXT.text  forKey:@"u_address2"];
    

   
    NSLog(@"updatePF Dic=%@",dictParams);
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,UpdateProfile_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleUpdateProfileResponse:response];
     }];
}

- (void)handleUpdateProfileResponse:(NSDictionary*)response
{
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        
          NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
        
        NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
        NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
        NSArray *filtered = [dropDwonARR filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(code contains[c] %@)", countryCode]];
        
        NSString *callingCode=[NSString stringWithFormat:@"+%@",[[filtered valueForKey:@"callingCode"] objectAtIndex:0]];
        NSString *phoneStr=[NSString stringWithFormat:@"%@%@",callingCode,Phone_TXT.text];
        
        [UserData setValue:Address_TXT.text forKey:@"u_address"];
        [UserData setValue:Address2_TXT.text forKey:@"u_address2"];
        [UserData setValue:City_TXT.text forKey:@"u_city"];
        [UserData setValue:Email_TXT.text forKey:@"u_email"];
        [UserData setValue:Name_TXT.text forKey:@"u_name"];
        [UserData setValue:phoneStr forKey:@"u_phone"];
        [UserData setValue:PinCode_TXT.text forKey:@"u_pincode"];
        [UserData setValue:State_TXT.text forKey:@"u_state"];
         [UserData setValue:Country_TXT.text forKey:@"u_country"];
         NSLog(@"LoginUserDic Dic=%@",UserData);

        
        [[NSUserDefaults standardUserDefaults] setObject:UserData forKey:@"LoginUserDic"];
        

        
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
        
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
}

- (IBAction)ChangePass_Click:(id)sender
{
    [self ShowPOPUP];
}

#pragma mark - pop AlertView;

-(void)ShowPOPUP
{
    [POPView bringSubviewToFront:self.view];
    POPView.hidden=NO;
    
    POPOldPAss= (UITextField *)[POPView viewWithTag:10];
    POPNewPAss =(UITextField *)[POPView viewWithTag:20];
    POPConPAss =(UITextField *)[POPView viewWithTag:30];
    
    POPOldPAss.delegate=self;
    POPNewPAss.delegate=self;
    POPConPAss.delegate=self;
    
    POPCancel =(UIButton *)[POPView viewWithTag:40];
    [POPCancel addTarget:self action:@selector(POPCancel_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    POPSubmit =(UIButton *)[POPView viewWithTag:50];
    [POPSubmit addTarget:self action:@selector(POPSubmit_Click:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)POPCancel_Click:(id)sender
{
    POPView.hidden=YES;
}

-(void)POPSubmit_Click:(id)sender
{
    //POPView.hidden=YES;
    
    if ([POPOldPAss.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Old Password" delegate:nil];
    }
    else if ([POPNewPAss.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter New Password" delegate:nil];
    }
    else if ([POPConPAss.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Confirm Password" delegate:nil];
    }
    else
    {
        if([POPNewPAss.text isEqualToString:POPConPAss.text])
        {
            [POPOldPAss resignFirstResponder];
            [POPNewPAss resignFirstResponder];
            [POPConPAss resignFirstResponder];
            BOOL internet=[AppDelegate connectedToNetwork];
            if (internet)
            {
                 [self updatePassword];
            }
            else
                [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
           
           
        }
        else
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"New Password and Re-Type New Password are not the same!" delegate:nil];
        }
        
    }
}

-(void)updatePassword
{
    NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
    NSString *User_UID=[UserData valueForKey:@"u_id"];
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:change_passwordServiceName  forKey:@"service"];
    [dictParams setObject:User_UID  forKey:@"uid"];
    [dictParams setObject:POPNewPAss.text  forKey:@"new_password"];
    [dictParams setObject:POPOldPAss.text  forKey:@"old_password"];
    
    NSLog(@"password change Dic=%@",dictParams);
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,UpdateProfile_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleUpdatePasswordResponse:response];
     }];
}

- (void)handleUpdatePasswordResponse:(NSDictionary*)response
{
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
         POPView.hidden=YES;
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
    else
    {
        POPView.hidden=YES;
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
}
/*
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
     self.statedropdownTBL.hidden=YES;
    
    if (textField==State_TXT)
    {
        checkTEXTFIELD=@"1";
        self.statedropdownTBL.hidden=NO;
        self.dropdownTBLTop.constant = 0;
        self.stateDropdwnTblHeight.constant = 128;
        return NO;
       
    }
    if (textField==Country_TXT)
    {
        checkTEXTFIELD=@"0";
        self.statedropdownTBL.hidden=NO;
        self.dropdownTBLTop.constant = 111;
        self.stateDropdwnTblHeight.constant = 128;
         return NO;
    }
     return YES;

}*/
#pragma mark - TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dropDwonARR.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier = @"CustomCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text=[[dropDwonARR valueForKey:@"name"] objectAtIndex:indexPath.row];
    cell.textLabel.textColor=[UIColor blackColor];
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.statedropdownTBL.hidden=YES;
    if ([checkTEXTFIELD isEqualToString:@"1"])
    {
        self.State_TXT.text=[[dropDwonARR valueForKey:@"name"] objectAtIndex:indexPath.row];
    }
    else
    {
         self.Country_TXT.text=[[dropDwonARR valueForKey:@"name"] objectAtIndex:indexPath.row];
    }
    
    
}
#define MAX_LENGTH 10
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
   // POPOldPAss
   // POPNewPAss
   // POPConPAss
    if (range.location == 0 && [string isEqualToString:@" "])
    {
        return NO;
    }
     if (textField == POPOldPAss || textField == POPNewPAss || textField == POPConPAss)
    {
        if (range.location == textField.text.length && [string isEqualToString:@" "])
        {
            // ignore replacement string and add your own
            textField.text = [textField.text stringByAppendingString:@""];
            return NO;
        }
        else
        {
            return YES;
        }
    }
    if (textField==Phone_TXT)
    {
        if (Phone_TXT.text.length >= MAX_LENGTH && range.length == 0)
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


@end
