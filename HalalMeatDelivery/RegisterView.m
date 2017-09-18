//
//  RegisterView.m
//  HalalMeatDelivery
//
//  Created by kaushik on 23/08/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import "RegisterView.h"
#import "HalalMeatDelivery.pch"
#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>

@interface RegisterView ()
@property AppDelegate *appDelegate;
@end

@implementation RegisterView
@synthesize SignUp_BTN,FaceBook_BTN,ScrollView;
@synthesize Username_Txt,email_Txt,pincode_Txt,password_Txt,address_Txt;


-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self prefersStatusBarHidden];
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:NO];
}

#pragma mark - photoShotSavedDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection = %li", (long)selectionIndex);
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [KmyappDelegate SetimageinTextfield:Username_Txt :@"UserIcon"];
    [KmyappDelegate SetimageinTextfield:email_Txt :@"Email_Icon"];
    [KmyappDelegate SetimageinTextfield:pincode_Txt :@"PinIcon"];
    [KmyappDelegate SetimageinTextfield:password_Txt :@"PasswordIcon"];
    [KmyappDelegate SetimageinTextfield:address_Txt :@"AddressIcon"];
    
    [KmyappDelegate SetbuttonCorner:SignUp_BTN];
    
    // Initialize the appDelegate property.
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self didEnterZip:@"362265"];
   
}
- (void)didEnterZip:(NSString*)zip
{
    CLGeocoder* geoCoder = [[CLGeocoder alloc] init];
    [geoCoder geocodeAddressDictionary:@{(NSString*)kABPersonAddressZIPKey : zip}
                     completionHandler:^(NSArray *placemarks, NSError *error) {
                         if ([placemarks count] > 0) {
                             CLPlacemark* placemark = [placemarks objectAtIndex:0];
                             
                             NSString* city = placemark.addressDictionary[(NSString*)kABPersonAddressCityKey];
                             NSString* state = placemark.addressDictionary[(NSString*)kABPersonAddressStateKey];
                             NSString* country = placemark.addressDictionary[(NSString*)kABPersonAddressCountryCodeKey];
                             NSLog(@"city=%@",city);
                              NSLog(@"state=%@",state);
                              NSLog(@"country=%@",country);
                             
                         } else {
                             // Lookup Failed
                         }
                     }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - TextField Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
   // [ScrollView setContentOffset:CGPointMake(0 , 0) animated:YES];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    /*
    CGFloat size1 = ScrollView.frame.origin.y + textField.frame.origin.y + textField.frame.size.height;
    CGFloat size2 = SCREEN_HEIGHT - 320;
    if (size1 >  size2)
    {
        [ScrollView setContentOffset:CGPointMake(0 , size1 - size2) animated:YES];
    }*/
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [email_Txt resignFirstResponder];
    [Username_Txt resignFirstResponder];
    [address_Txt resignFirstResponder];
    [pincode_Txt resignFirstResponder];
    [password_Txt resignFirstResponder];
    UITouch *touch =[touches anyObject];
    if (touch.phase ==UITouchPhaseBegan)
    {
        [self.view endEditing:YES];
        [ScrollView endEditing:YES];
    }
}

-(BOOL) isPasswordValid:(NSString *)pwd
{
    NSCharacterSet *upperCaseChars = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLKMNOPQRSTUVWXYZ"];
    NSCharacterSet *lowerCaseChars = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyz"];
    
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789!@#$%^&*()_-,.;:"];
    
    if ( [pwd length]<8 || [pwd length]>20 )
        return NO;  // too long or too short
    NSRange rang;
    rang = [pwd rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
    if ( !rang.length )
        return NO;  // no letter
    rang = [pwd rangeOfCharacterFromSet:numbers];
    if ( !rang.length )
        return NO;  // no number;
    rang = [pwd rangeOfCharacterFromSet:upperCaseChars];
    if ( !rang.length )
        return NO;  // no uppercase letter;
    rang = [pwd rangeOfCharacterFromSet:lowerCaseChars];
    if ( !rang.length )
        return NO;  // no lowerCase Chars;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location == 0 && [string isEqualToString:@" "])
    {
        return NO;
    }
    if (textField==password_Txt)
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
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (IBAction)Login_Click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)Signup_action:(id)sender
{
    if ([Username_Txt.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter username" delegate:nil];
    }
    else if ([address_Txt.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Address" delegate:nil];
    }
    else if ([pincode_Txt.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Post Code" delegate:nil];
    }
    else if ([email_Txt.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Email" delegate:nil];
    }
    else if ([password_Txt.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter password" delegate:nil];
    }
    else
    {
        if (![AppDelegate IsValidEmail:email_Txt.text])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter valid email" delegate:nil];
        }
        else if (![self isPasswordValid:password_Txt.text])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Password should be 8 characters, one Special character , One Number" delegate:nil];
        }
        else
        {
            
            BOOL internet=[AppDelegate connectedToNetwork];
            if (internet)
            {
                [self CallNormalSignup];
            }
            else
                [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
            
        }
    }
}
-(void)CallNormalSignup
{
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:RegisterServiceName  forKey:@"service"];
    [dictParams setObject:email_Txt.text  forKey:@"u_email"];
    [dictParams setObject:password_Txt.text  forKey:@"u_password"];
    [dictParams setObject:Username_Txt.text  forKey:@"u_name"];
    
    [dictParams setObject:@""  forKey:@"u_phone"];
    [dictParams setObject:address_Txt.text  forKey:@"u_address"];
    [dictParams setObject:pincode_Txt.text  forKey:@"u_zip"];
    //[dictParams setObject:@""  forKey:@"u_city"];
   // [dictParams setObject:@""  forKey:@"u_state"];
   // [dictParams setObject:@""  forKey:@"u_country"];
     [dictParams setObject:@"simple"  forKey:@"u_type"];
    
    
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,RegisterUrl] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleResponse:response];
     }];
}

- (void)handleResponse:(NSDictionary*)response
{
    //NSLog(@"Logindata==%@",response);
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:[[response valueForKey:@"result"] objectAtIndex:0] forKey:@"LoginUserDic"];
        HomeView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeView"];
        [self.navigationController pushViewController:vcr animated:YES];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
}
- (IBAction)Twitter_Click:(id)sender {
}
- (IBAction)Gmail_Click:(id)sender {
}

- (IBAction)FB_signup:(id)sender
{
    NSLog(@"FB Signup");
    
//    BOOL internet=[AppDelegate connectedToNetwork];
//    if (internet)
//    {
//        if ([FBSession activeSession].state != FBSessionStateOpen &&
//            [FBSession activeSession].state != FBSessionStateOpenTokenExtended) {
//            [self.appDelegate openActiveSessionWithPermissions:@[@"public_profile", @"email"] allowLoginUI:YES];
//        }
//        else{
//            // Close an existing session.
//            [[FBSession activeSession] closeAndClearTokenInformation];
//            // Update the UI.
//        }
//    }
//    else
//        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
}



//#pragma mark - Private method implementation
//-(void)openActiveSessionWithPermissions:(NSArray *)permissions allowLoginUI:(BOOL)allowLoginUI{
//    NSLog(@"result");
//    // Get the session, state and error values from the notification's userInfo dictionary.
//    NSDictionary *userInfo = [permissions mutableCopy];
//    
//    FBSessionState sessionState = [[userInfo objectForKey:@"state"] integerValue];
//    NSError *error = [userInfo objectForKey:@"error"];
//    
//    // Handle the session state.
//    // Usually, the only interesting states are the opened session, the closed session and the failed login.
//    if (!error) {
//        // In case that there's not any error, then check if the session opened or closed.
//        if (sessionState == FBSessionStateOpen)
//        {
//            [FBRequestConnection startWithGraphPath:@"me"
//                                         parameters:@{@"fields": @"first_name, last_name, picture.type(normal), email"}
//                                         HTTPMethod:@"GET"
//                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//                                      if (!error) {
//                                          NSLog(@"result=%@",result);
//                                          
//                                          FBSignupdictParams = [[NSMutableDictionary alloc] init];
//                                          [FBSignupdictParams setObject:r_p  forKey:@"r_p"];
//                                          [FBSignupdictParams setObject:RegisterServiceName  forKey:@"service"];
//                                          [FBSignupdictParams setObject:[result objectForKey:@"email"]  forKey:@"u_email"];
//                                          [FBSignupdictParams setObject:[result objectForKey:@"first_name"]  forKey:@"u_name"];
//                                          [FBSignupdictParams setObject:@""  forKey:@"u_password"];
//                                          [FBSignupdictParams setObject:@""  forKey:@"u_phone"];
//                                          [FBSignupdictParams setObject:@""  forKey:@"u_address"];
//                                          [FBSignupdictParams setObject:@""  forKey:@"u_zip"];
//                                          [FBSignupdictParams setObject:@""  forKey:@"u_city"];
//                                          [FBSignupdictParams setObject:@""  forKey:@"u_state"];
//                                          [FBSignupdictParams setObject:@""  forKey:@"u_country"];
//                                          [FBSignupdictParams setObject:@"facebook"  forKey:@"u_type"];
//                                          
//                                          
//                                          if ([[result objectForKey:@"u_email"]isEqualToString:@""])
//                                          {
//                                              [AppDelegate showErrorMessageWithTitle:@"Error..!" message:@"Privacy set in facebook account while getting user info." delegate:nil];
//                                          }
//                                          else
//                                          {
//                                              [self CallFBSignup];
//                                          }
//                                          // Get the user's profile picture.
//                                          // NSURL *pictureURL = [NSURL URLWithString:[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
//                                      }
//                                      else
//                                      {
//                                          NSLog(@"%@", [error localizedDescription]);
//                                      }
//                                  }];
//            
//        }
//        else if (sessionState == FBSessionStateClosed || sessionState == FBSessionStateClosedLoginFailed){
//            // A session was closed or the login was failed. Update the UI accordingly.
//        }
//    }
//    else{
//        // In case an error has occurred, then just log the error and update the UI accordingly.
//        NSLog(@"Error: %@", [error localizedDescription]);
//    }
//
//}
//

-(void)CallFBSignup
{
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,RegisterUrl] withParam:FBSignupdictParams withCompletion:^(NSDictionary *response, BOOL success1)
         {
             [self handleResponse:response];
         }];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
}


@end
