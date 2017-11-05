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
#import "SearchByShop.h"
@interface RegisterView ()
@property AppDelegate *appDelegate;
@end

@implementation RegisterView
@synthesize SignUp_BTN,FaceBook_BTN,ScrollView;
@synthesize Username_Txt,email_Txt,pincode_Txt,password_Txt,address_Txt,address2_TXT,PhoneNo_TXT;
@synthesize loginMgr;

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
    
    address_Txt.autocapitalizationType = UITextAutocapitalizationTypeWords;
    
    [KmyappDelegate SetimageinTextfield:Username_Txt :@"UserIcon"];
    [KmyappDelegate SetimageinTextfield:email_Txt :@"Email_Icon"];
    [KmyappDelegate SetimageinTextfield:pincode_Txt :@"PinIcon"];
    [KmyappDelegate SetimageinTextfield:password_Txt :@"PasswordIcon"];
    [KmyappDelegate SetimageinTextfield:address_Txt :@"AddressIcon"];
    
    [KmyappDelegate SetimageinAndPrefixTextfield:PhoneNo_TXT:@"IconPhone"];
    [KmyappDelegate SetimageinTextfield:address2_TXT :@"AddressIcon"];
    
    [KmyappDelegate SetbuttonCorner:SignUp_BTN];
    
    // Initialize the appDelegate property.
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self didEnterZip:@"362265"];
    
    
    //Google SignIn
    NSString *userScope = @"https://www.googleapis.com/auth/plus.me";
    NSString *loginScope = @"https://www.googleapis.com/auth/plus.login";
    NSArray *arrScopes = [NSArray arrayWithObjects:loginScope,userScope, nil];
    NSArray *currentScopes = [GIDSignIn sharedInstance].scopes;
    [GIDSignIn sharedInstance].scopes   = [currentScopes arrayByAddingObjectsFromArray:arrScopes];
    [GIDSignIn sharedInstance].shouldFetchBasicProfile = true;
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    //Facebook SignIn
    loginMgr = [[FBSDKLoginManager alloc] init];
    [loginMgr logOut];
   
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
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Zip Code" delegate:nil];
    }
    else if ([PhoneNo_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Mobile Number" delegate:nil];
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
        else if (![AppDelegate myMobileNumberValidate:PhoneNo_TXT.text])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please Enter a Valid Mobile number" delegate:nil];
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
    NSString *phoneStr=[NSString stringWithFormat:@"+1%@",PhoneNo_TXT.text];
    [dictParams setObject:phoneStr  forKey:@"u_phone"];
    [dictParams setObject:address_Txt.text  forKey:@"u_address"];
    [dictParams setObject:address2_TXT.text  forKey:@"u_address2"];
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
        [[NSUserDefaults standardUserDefaults] setObject:@"simple" forKey:@"USERLOGINTYPE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""                                                        message:[response objectForKey:@"ack_msg"]delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil,nil];
        alert.tag=50;
        [alert show];

        
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // the user clicked
    if (alertView.tag==50)
    {
        if (buttonIndex == 0)
        {
            SearchByShop *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchByShop"];
            [self.navigationController pushViewController:vcr animated:YES];
        }
    }
}
- (IBAction)Twitter_Click:(id)sender
{
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error)
     {
         if (session)
         {
             //[MBProgressHUD showHUDAddedTo:sharedAppDel.window animated:YES];
             NSLog(@"signed in as %@, \nauthToken = %@, \nauthSecretToken = %@, \nuserId = %@" , [session userName],[session authToken],[session authTokenSecret],[session userID]);
             
             NSString *emailtw=[NSString stringWithFormat:@"%@/@gmil.com",[session userName]];
             FBSignupdictParams = [[NSMutableDictionary alloc] init];
             [FBSignupdictParams setObject:r_p  forKey:@"r_p"];
             [FBSignupdictParams setObject:RegisterServiceName  forKey:@"service"];
             [FBSignupdictParams setObject:emailtw  forKey:@"u_email"];
             [FBSignupdictParams setObject:[session userName]  forKey:@"u_name"];
             [FBSignupdictParams setObject:@""  forKey:@"u_password"];
             [FBSignupdictParams setObject:@""  forKey:@"u_phone"];
             [FBSignupdictParams setObject:@""  forKey:@"u_address"];
             [FBSignupdictParams setObject:@""  forKey:@"u_zip"];
             [FBSignupdictParams setObject:@""  forKey:@"u_city"];
             [FBSignupdictParams setObject:@""  forKey:@"u_state"];
             [FBSignupdictParams setObject:@""  forKey:@"u_country"];
             [FBSignupdictParams setObject:@"twitter"  forKey:@"u_type"];
             [self CallFBSignup];
             
             
             
             
             
             //             NSDictionary *dictTwitter = [[NSDictionary alloc] initWithObjectsAndKeys:
             //                                          [NSString stringWithFormat:@"%@@twitter.com",[session userName]],@"email",
             //                                          [session userName],@"username",
             //                                          @"",@"full_name",
             //                                          @"twitter",@"provider",
             //                                          [session userID],@"uid",
             //                                          @"iPhone",@"device_type",
             //                                          [sharedAppDel deviceTokenID],@"device_token",nil];
             //
             //             [self SocialLoginAPICall:dictTwitter];
         }
         else
         {
             // [sharedAppDel ShowAlertWithOneBtn:@"Login Error!, Please try again" andbtnTitle:@"Ok"];
             NSLog(@"error: %@", [error localizedDescription]);
         }
     }];
}
- (IBAction)Gmail_Click:(id)sender
{
     [[GIDSignIn sharedInstance] signIn];
}
#pragma mark - Google SignIn Delegate

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error
{
    // Perform any operations on signed in user here.
    if (error == nil)
    {
        // [MBProgressHUD showHUDAddedTo:sharedAppDel.window animated:YES];
        NSString *userId = user.userID;
        NSString *fullName = user.profile.name;
        NSString *givenName = user.profile.givenName;
        NSString *familyName = user.profile.familyName;
        NSString *email = user.profile.email;
        
        NSString *clientID = user.authentication.clientID;
        NSString *accessToken = user.authentication.accessToken;
        NSString *refreshToken = user.authentication.refreshToken;
        NSString *idToken = user.authentication.idToken;
        
        NSLog(@"userId == %@,\nfullName == %@,\ngivenName == %@,\nfamilyName == %@,\nemail == %@,\nclientID == %@,\naccessToken == %@,\nrefreshToken == %@,\nidToken == %@",userId,fullName,givenName,familyName,email,clientID,accessToken,refreshToken,idToken);
        
        FBSignupdictParams = [[NSMutableDictionary alloc] init];
        [FBSignupdictParams setObject:r_p  forKey:@"r_p"];
        [FBSignupdictParams setObject:RegisterServiceName  forKey:@"service"];
        [FBSignupdictParams setObject:email  forKey:@"u_email"];
        [FBSignupdictParams setObject:fullName  forKey:@"u_name"];
        [FBSignupdictParams setObject:@""  forKey:@"u_password"];
        [FBSignupdictParams setObject:@""  forKey:@"u_phone"];
        [FBSignupdictParams setObject:@""  forKey:@"u_address"];
        [FBSignupdictParams setObject:@""  forKey:@"u_zip"];
        [FBSignupdictParams setObject:@""  forKey:@"u_city"];
        [FBSignupdictParams setObject:@""  forKey:@"u_state"];
        [FBSignupdictParams setObject:@""  forKey:@"u_country"];
        [FBSignupdictParams setObject:@"gmail"  forKey:@"u_type"];
        
        //gmil
        [self CallFBSignup];
        
        
        
        
        
        
        
        //
        //        NSDictionary *dictGoogle = [[NSDictionary alloc] initWithObjectsAndKeys:
        //                                    email,@"email",
        //                                    @"",@"username",
        //                                    fullName,@"full_name",
        //                                    @"google",@"provider",
        //                                    userId,@"uid",
        //                                    @"iPhone",@"device_type",
        //                                    [sharedAppDel deviceTokenID],@"device_token",nil];
        
        //[self SocialLoginAPICall:dictGoogle];
    }
    else
    {
        //  [sharedAppDel ShowAlertWithOneBtn:@"Login Error!, Please try again" andbtnTitle:@"Ok"];
        NSLog(@"%@", error.localizedDescription);
    }
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error
{
    // Perform any operations when the user disconnects from app here.
}

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error
{
    NSLog(@"%@",error.description);
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController
{
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)FB_signup:(id)sender
{
    NSLog(@"FB Signup");
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        
        [loginMgr
         logInWithReadPermissions: @[@"public_profile",@"email",@"user_friends",@"user_birthday"]
         fromViewController:self
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
         {
             if (error)
             {
                 NSLog(@"Process error == %@",error);
                 [AppDelegate showErrorMessageWithTitle:@"" message:@"Login Error!, Please try again" delegate:nil];
             }
             else if (result.isCancelled)
             {
                 NSLog(@"Cancelled");
             }
             else
             {
                 [self fetchUserInfo];
                 NSLog(@"Logged in");
             }
         }];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
}

#pragma mark - FB UserInfo

-(void)fetchUserInfo
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken] tokenString]);
        
        //[MBProgressHUD showHUDAddedTo:sharedAppDel.window animated:YES];
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, friends ,friendlists"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 NSLog(@"result is : %@",result);
                 
                 FBSignupdictParams = [[NSMutableDictionary alloc] init];
                 [FBSignupdictParams setObject:r_p  forKey:@"r_p"];
                 [FBSignupdictParams setObject:RegisterServiceName  forKey:@"service"];
                 [FBSignupdictParams setObject:[result objectForKey:@"email"]  forKey:@"u_email"];
                 [FBSignupdictParams setObject:[result objectForKey:@"first_name"]  forKey:@"u_name"];
                 [FBSignupdictParams setObject:@""  forKey:@"u_password"];
                 [FBSignupdictParams setObject:@""  forKey:@"u_phone"];
                 [FBSignupdictParams setObject:@""  forKey:@"u_address"];
                 [FBSignupdictParams setObject:@""  forKey:@"u_zip"];
                 [FBSignupdictParams setObject:@""  forKey:@"u_city"];
                 [FBSignupdictParams setObject:@""  forKey:@"u_state"];
                 [FBSignupdictParams setObject:@""  forKey:@"u_country"];
                 [FBSignupdictParams setObject:@"facebook"  forKey:@"u_type"];
                 if ([[result objectForKey:@"u_email"]isEqualToString:@""])
                 {
                     [AppDelegate showErrorMessageWithTitle:@"Error..!" message:@"Privacy set in facebook account while getting user info." delegate:nil];
                 }
                 else
                 {
                     [self CallFBSignup];
                 }
             }
             else
             {
                 NSLog(@"Error %@",error);
                 [AppDelegate showErrorMessageWithTitle:@"" message:@"Login Error!, Please try again" delegate:nil];
             }
         }];
    }
}

-(void)CallFBSignup
{
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,RegisterUrl] withParam:FBSignupdictParams withCompletion:^(NSDictionary *response, BOOL success1)
         {
             [self SocailhandleResponse:response];
         }];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
}
- (void)SocailhandleResponse:(NSDictionary*)response
{
    //NSLog(@"Logindata==%@",response);
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:[[response valueForKey:@"result"] objectAtIndex:0] forKey:@"LoginUserDic"];
        [[NSUserDefaults standardUserDefaults] setObject:@"social" forKey:@"USERLOGINTYPE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        SearchByShop *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchByShop"];
        [self.navigationController pushViewController:vcr animated:YES];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
}

- (IBAction)Back_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
