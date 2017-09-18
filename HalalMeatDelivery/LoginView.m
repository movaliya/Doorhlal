//
//  LoginView.m
//  HalalMeatDelivery
//
//  Created by kaushik on 23/08/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import "LoginView.h"
#import "RegisterView.h"
#import "NearByView.h"
#import "AppDelegate.h"
#import "HomeView.h"

#import "Forgotpasswordview.h"
#import "HalalMeatDelivery.pch"
#import <CoreLocation/CoreLocation.h>
#import "SearchByShop.h"

@interface LoginView ()
{
    
}
-(void)handleFBSessionStateChangeWithNotification:(NSNotification *)notification;
@property (strong, nonatomic) UIButton *POPOK;
@property (strong, nonatomic) UIButton *POPYES;
@property (strong, nonatomic) UIButton *POPNO;
@property (strong, nonatomic) UILabel *Title_LBL;
@property (strong, nonatomic) UILabel *Desc_LBL;
@property AppDelegate *appDelegate;
@end

@implementation LoginView
@synthesize Login_BTN,FaceBook_BTN;
@synthesize Logi_View,Passwor_View;
@synthesize User_TXT,Password_TXT;
@synthesize POPNO,POPOK,POPYES,Title_LBL,Desc_LBL,GustBTN;
@synthesize LogoHight,LogoWidth,WelcomToLogoGap,WelcomeGap,TopLogoHight;
@synthesize loginMgr;



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = [AppDelegate sharedInstance];
    
    [KmyappDelegate SetimageinTextfield:User_TXT :@"UserIcon"];
    [KmyappDelegate SetimageinTextfield:Password_TXT :@"PasswordIcon"];
    
    [KmyappDelegate SetbuttonCorner:Login_BTN];
    [KmyappDelegate SetbuttonCorner:GustBTN];
    
    //    if ([self.appDelegate isUserLoggedIn] == YES)
//    {
//        [self performSelector:@selector(checkLoginAndPresentContainer) withObject:nil afterDelay:0.0];
//    }
    
    [self SetupUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleFBSessionStateChangeWithNotification:)
                                                 name:@"SessionStateChangeNotification"
                                               object:nil];
    
    // Initialize the appDelegate property.
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *useremail = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"Email"];
    NSString *password = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"Password"];
    
    if (useremail.length>1 &&  password.length>1)
    {
        User_TXT.text=useremail;
        Password_TXT.text=password;
    }
    
    
    
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

-(void)checkLoginAndPresentContainer
{
    SearchByShop *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchByShop"];
    [self.navigationController pushViewController:vcr animated:YES];
}

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
    [self.rootNav.pan_gr setEnabled:NO];
}

#pragma mark - photoShotSavedDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection = %li", (long)selectionIndex);
    
}

-(void)SetupUI
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)Twitter_Click:(id)sender
{
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error)
     {
         if (session)
         {
             //[MBProgressHUD showHUDAddedTo:sharedAppDel.window animated:YES];
             NSLog(@"signed in as %@, \nauthToken = %@, \nauthSecretToken = %@, \nuserId = %@" , [session userName],[session authToken],[session authTokenSecret],[session userID]);
             
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

- (IBAction)Facebook_click:(UIButton *)sender
{
    
    
//    BOOL internet=[AppDelegate connectedToNetwork];
//    if (internet)
//    {
//        
//        if ([FBSession activeSession].state != FBSessionStateOpen &&
//            [FBSession activeSession].state != FBSessionStateOpenTokenExtended) {
//            [self.appDelegate openActiveSessionWithPermissions:@[@"public_profile", @"email"] allowLoginUI:YES];
//        }
//        else{
//            // Close an existing session.
//            [[FBSession activeSession] closeAndClearTokenInformation];
//            
//            // Update the UI.
//        }
//
//        
//    }
//    else
//        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
    
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        
        //        if ([FBSession activeSession].state != FBSessionStateOpen &&
        //            [FBSession activeSession].state != FBSessionStateOpenTokenExtended) {
        //            [self.appDelegate openActiveSessionWithPermissions:@[@"public_profile", @"email"] allowLoginUI:YES];
        //        }
        //        else{
        //            // Close an existing session.
        //            [[FBSession activeSession] closeAndClearTokenInformation];
        //            // Update the UI.
        //        }
        
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
                 
                 //                 NSDictionary *dictFb = [[NSDictionary alloc] initWithObjectsAndKeys:
                 //                                         [result valueForKey:@"email"],@"email",
                 //                                         @"",@"username",
                 //                                         [result valueForKey:@"name"],@"full_name",
                 //                                         @"facebook",@"provider",
                 //                                         [result valueForKey:@"id"],@"uid",
                 //                                         @"iPhone",@"device_type",
                 //                                         [sharedAppDel deviceTokenID],@"device_token",nil];
                 //
                 //                 [self SocialLoginAPICall:dictFb];
             }
             else
             {
                 NSLog(@"Error %@",error);
                 [AppDelegate showErrorMessageWithTitle:@"" message:@"Login Error!, Please try again" delegate:nil];
             }
         }];
    }
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

#pragma mark - Private method implementation

//-(void)handleFBSessionStateChangeWithNotification:(NSNotification *)notification
//{
//    NSLog(@"result");
//    // Get the session, state and error values from the notification's userInfo dictionary.
//    NSDictionary *userInfo = [notification userInfo];
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
//                                          FBSignIndictParams = [[NSMutableDictionary alloc] init];
//                                          [FBSignIndictParams setObject:r_p  forKey:@"r_p"];
//                                          [FBSignIndictParams setObject:RegisterServiceName  forKey:@"service"];
//                                          [FBSignIndictParams setObject:[result objectForKey:@"email"]  forKey:@"u_email"];
//                                          [FBSignIndictParams setObject:[result objectForKey:@"first_name"]  forKey:@"u_name"];
//                                          [FBSignIndictParams setObject:@""  forKey:@"u_password"];
//                                          [FBSignIndictParams setObject:@""  forKey:@"u_phone"];
//                                          [FBSignIndictParams setObject:@""  forKey:@"u_address"];
//                                          [FBSignIndictParams setObject:@""  forKey:@"u_zip"];
//                                          [FBSignIndictParams setObject:@""  forKey:@"u_city"];
//                                          [FBSignIndictParams setObject:@""  forKey:@"u_state"];
//                                          [FBSignIndictParams setObject:@""  forKey:@"u_country"];
//                                          [FBSignIndictParams setObject:@"facebook"  forKey:@"u_type"];
//                                          if ([[result objectForKey:@"u_email"]isEqualToString:@""])
//                                          {
//                                              [AppDelegate showErrorMessageWithTitle:@"Error..!" message:@"Privacy set in facebook account while getting user info." delegate:nil];
//                                          }
//                                          else
//                                          {
//                                              [self CallFBSignup];
//                                          }
//                                          
//                                          
//                                          
//                                          
//                                          // Get the user's profile picture.
//                                          NSURL *pictureURL = [NSURL URLWithString:[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
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
//}

-(void)CallFBSignup
{
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,RegisterUrl] withParam:FBSignIndictParams withCompletion:^(NSDictionary *response, BOOL success1)
         {
             [self handleFBResponse:response];
         }];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
}

- (void)handleFBResponse:(NSDictionary*)response
{
    //NSLog(@"Logindata==%@",response);
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        
        NSMutableDictionary *dic = [[NSMutableDictionary  alloc] init];
        dic=[[response valueForKey:@"result"] objectAtIndex:0];
        [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"LoginUserDic"];
        
        SearchByShop *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchByShop"];
        [self.navigationController pushViewController:vcr animated:YES];
         [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
    
}

- (IBAction)Login_click:(id)sender
{
    
//    [AppDelegate showErrorMessageWithTitle:@"" message:@"Please enter password" delegate:nil];
    
    if ([User_TXT.text isEqualToString:@""])
    {
        //[self ShowPOPUP];
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter username" delegate:nil];
    }
    else
    {
        if (![AppDelegate IsValidEmail:User_TXT.text])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter valid email" delegate:nil];
        }
        else
        {
            if ([Password_TXT.text isEqualToString:@""])
            {
                [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter password" delegate:nil];
            }
            else
            {
                BOOL internet=[AppDelegate connectedToNetwork];
                if (internet)
                    [self CallForloging];
                else
                    [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
                
            }
        }
    }
}

-(void)CallForloging
{
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:UserLoginServiceName  forKey:@"service"];
    [dictParams setObject:User_TXT.text  forKey:@"u_email"];
    [dictParams setObject:Password_TXT.text  forKey:@"u_password"];
    
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,UserLogin] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleResponse:response];
     }];
}
- (void)handleResponse:(NSDictionary*)response
{
    Maindic=response;
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        NSMutableDictionary *dic = [[NSMutableDictionary  alloc] init];
        dic=[[response valueForKey:@"result"] objectAtIndex:0];
        [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"LoginUserDic"];
        
        [[NSUserDefaults standardUserDefaults]setObject:User_TXT.text forKey:@"Email"];
        [[NSUserDefaults standardUserDefaults]setObject:Password_TXT.text forKey:@"Password"];
        [[NSUserDefaults standardUserDefaults]setObject:[response objectForKey:@"u_pincode"] forKey:@"Pincode"];
        [[NSUserDefaults standardUserDefaults]setObject:[response objectForKey:@"u_name"] forKey:@"UserName"];
        [[NSUserDefaults standardUserDefaults]setObject:[response objectForKey:@"u_phone"] forKey:@"PhoneNumber"];
        //[AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
       
       // HomeView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeView"];
        [self.navigationController popViewControllerAnimated:YES];
       
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
    
}
- (IBAction)Forgot_Click:(id)sender
{
    
    Forgotpasswordview *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Forgotpasswordview"];
    [self.navigationController pushViewController:vcr animated:YES];
}

- (IBAction)SignUp_Click:(id)sender
{
    [User_TXT resignFirstResponder];
    [Password_TXT resignFirstResponder];
    
    RegisterView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RegisterView"];
    [self.navigationController pushViewController:vcr animated:YES];
    
}
/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range     replacementString:(NSString *)string
{
    if(Password_TXT)
    {
        NSString *resultingString = [textField.text stringByReplacingCharactersInRange: range withString: string];
        NSCharacterSet *whitespaceSet = [NSCharacterSet whitespaceCharacterSet];
        if  ([resultingString rangeOfCharacterFromSet:whitespaceSet].location == NSNotFound)      {
            return YES;
        }  else  {
            return NO;
        }
    }
    return NO;
}
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (range.location == 0 && [string isEqualToString:@" "])
    {
        return NO;
    }
    if (textField==Password_TXT)
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

-(BOOL)textFieldShouldReturn:(UITextField * )textField
{
    [textField resignFirstResponder];
    return YES;
}

/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField== Password_TXT)
    {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 10;
    }
    return YES;
}
*/
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [User_TXT resignFirstResponder];
    [Password_TXT resignFirstResponder];
    UITouch *touch =[touches anyObject];
    if (touch.phase ==UITouchPhaseBegan)
    {
        [self.view endEditing:YES];
    }
}


- (IBAction)backbtn_action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)Guest_Click:(id)sender
{
    SearchByShop *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchByShop"];
    [self.navigationController pushViewController:vcr animated:YES];
}
@end
