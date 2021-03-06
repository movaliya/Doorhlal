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
    UIButton *imgforLeft;
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
    

    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:[NSDate date]];
    [components setTimeZone:[NSTimeZone localTimeZone]];
    NSInteger hour = [components hour];
    
    if(hour >= 5 && hour < 12)
    {
        self.TimeStatus_LBL.text=@"Good Morning";
        NSLog(@"Good Morning");
    }
    else if(hour >= 12 && hour < 17)
    {
        self.TimeStatus_LBL.text=@"Good Afternoon";
        NSLog(@"Good Afternoon");
    }
   // else if(hour >= 16 && hour < 21)
    //{
      //  self.TimeStatus_LBL.text=@"Good Evening";
       // NSLog(@"Good Evening");
   // }
    else if(hour >= 17  && hour < 24)
    {
        self.TimeStatus_LBL.text=@"Good Evening";
        NSLog(@"Good evening");
    }
    
    
    
    self.appDelegate = [AppDelegate sharedInstance];
    
    [KmyappDelegate SetimageinTextfield:User_TXT :@"UserIcon"];
    [KmyappDelegate SetimageinTextfield:Password_TXT :@"PasswordIcon"];
    
    [KmyappDelegate SetbuttonCorner:Login_BTN];
    [KmyappDelegate SetbuttonCorner:GustBTN];
    
    if ([self.appDelegate isUserLoggedIn] == YES)
    {
        SearchByShop *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchByShop"];
        [self.navigationController pushViewController:vcr animated:YES];
    }
    
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
    
    GIDSignIn *signin = [GIDSignIn sharedInstance];
    signin.shouldFetchBasicProfile = true;
    signin.delegate = self;
    signin.uiDelegate = self;
    
  //  [GIDSignIn sharedInstance].shouldFetchBasicProfile = true;
   // [GIDSignIn sharedInstance].delegate = self;
   // [GIDSignIn sharedInstance].uiDelegate = self;
    
    
    
    
    //Facebook SignIn
    loginMgr = [[FBSDKLoginManager alloc] init];
    [loginMgr logOut];
    


    UIView *vw=[[UIView alloc]initWithFrame:CGRectMake(70, 0, 40, 50)];
    imgforLeft=[[UIButton alloc] initWithFrame:CGRectMake(0, 5, 40, 40)];
    [imgforLeft addTarget:self action:@selector(ShowPassword:) forControlEvents:UIControlEventTouchUpInside];
    [imgforLeft setImage:[UIImage imageNamed:@"ShowPassword"] forState:UIControlStateNormal];
    [imgforLeft setContentMode:UIViewContentModeCenter];
    imgforLeft.hidden=YES;
    [vw addSubview:imgforLeft];
    Password_TXT.rightView=vw;
    Password_TXT.rightViewMode=UITextFieldViewModeAlways;
    
}

-(void)ShowPassword:(id)sedner
{
    if (Password_TXT.secureTextEntry==YES)
    {
        Password_TXT.secureTextEntry=NO;
    }
    else
    {
        Password_TXT.secureTextEntry=YES;
    }
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
             
             NSString *emailtw=[NSString stringWithFormat:@"%@@twitter.com",[session userName]];
             FBSignIndictParams = [[NSMutableDictionary alloc] init];
             [FBSignIndictParams setObject:r_p  forKey:@"r_p"];
             [FBSignIndictParams setObject:RegisterServiceName  forKey:@"service"];
             [FBSignIndictParams setObject:emailtw  forKey:@"u_email"];
             [FBSignIndictParams setObject:[session userName]  forKey:@"u_name"];
             [FBSignIndictParams setObject:@""  forKey:@"u_password"];
             [FBSignIndictParams setObject:@""  forKey:@"u_phone"];
             [FBSignIndictParams setObject:@""  forKey:@"u_address"];
             [FBSignIndictParams setObject:@""  forKey:@"u_zip"];
             [FBSignIndictParams setObject:@""  forKey:@"u_city"];
             [FBSignIndictParams setObject:@""  forKey:@"u_state"];
             [FBSignIndictParams setObject:@""  forKey:@"u_country"];
             [FBSignIndictParams setObject:@"twitter"  forKey:@"u_type"];
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
    GIDSignIn *signin = [GIDSignIn sharedInstance];
    signin.shouldFetchBasicProfile = true;
    signin.delegate = self;
    signin.uiDelegate = self;
    [signin signIn];
    
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
         logInWithReadPermissions: @[@"public_profile",@"email"]
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
                 [KVNProgress show];
                 [self performSelector:@selector(fetchUserInfo) withObject:nil afterDelay:3.0];
                // [self fetchUserInfo];
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
                 if ( ( ![[result objectForKey:@"email"] isEqual:[NSNull null]] ) && ( [[result objectForKey:@"email"] length] != 0 ) )
                 {
                     FBSignIndictParams = [[NSMutableDictionary alloc] init];
                     [FBSignIndictParams setObject:r_p  forKey:@"r_p"];
                     [FBSignIndictParams setObject:RegisterServiceName  forKey:@"service"];
                     [FBSignIndictParams setObject:[result objectForKey:@"email"]  forKey:@"u_email"];
                     [FBSignIndictParams setObject:[result objectForKey:@"first_name"]  forKey:@"u_name"];
                     [FBSignIndictParams setObject:@""  forKey:@"u_password"];
                     [FBSignIndictParams setObject:@""  forKey:@"u_phone"];
                     [FBSignIndictParams setObject:@""  forKey:@"u_address"];
                     [FBSignIndictParams setObject:@""  forKey:@"u_zip"];
                     [FBSignIndictParams setObject:@""  forKey:@"u_city"];
                     [FBSignIndictParams setObject:@""  forKey:@"u_state"];
                     [FBSignIndictParams setObject:@""  forKey:@"u_country"];
                     [FBSignIndictParams setObject:@"facebook"  forKey:@"u_type"];
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
                     [AppDelegate showErrorMessageWithTitle:@"" message:@"Privacy set in facebook account while getting user info." delegate:nil];
                 }
                 
                 
                 
                 
                 
                 
                 
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
        //NSString *userId = user.userID;
        //NSString *fullName = user.profile.name;
       // NSString *givenName = user.profile.givenName;
       // NSString *familyName = user.profile.familyName;
       // NSString *clientID = user.authentication.clientID;
       // NSString *accessToken = user.authentication.accessToken;
       // NSString *refreshToken = user.authentication.refreshToken;
        //NSString *idToken = user.authentication.idToken;
        
        NSString *email = user.profile.email;
        if ( ( ![email isEqual:[NSNull null]] ) && ( [email length] != 0 ) )
        {
            FBSignIndictParams = [[NSMutableDictionary alloc] init];
            [FBSignIndictParams setObject:r_p  forKey:@"r_p"];
            [FBSignIndictParams setObject:GmailServiceName  forKey:@"service"];
            [FBSignIndictParams setObject:email  forKey:@"email"];
             [self CallGmailSignup];
        }
        else
        {
             [AppDelegate showErrorMessageWithTitle:@"" message:@"Privacy set in google account while getting user info." delegate:nil];
        }
        
        //NSLog(@"userId == %@,\nfullName == %@,\ngivenName == %@,\nfamilyName == %@,\nemail == %@,\nclientID == %@,\naccessToken == %@,\nrefreshToken == %@,\nidToken == %@",userId,fullName,givenName,familyName,email,clientID,accessToken,refreshToken,idToken);
              //[FBSignIndictParams setObject:fullName  forKey:@"u_name"];
       // [FBSignIndictParams setObject:@""  forKey:@"u_password"];
       // [FBSignIndictParams setObject:@""  forKey:@"u_phone"];
      //  [FBSignIndictParams setObject:@""  forKey:@"u_address"];
       // [FBSignIndictParams setObject:@""  forKey:@"u_zip"];
      //  [FBSignIndictParams setObject:@""  forKey:@"u_city"];
       // [FBSignIndictParams setObject:@""  forKey:@"u_state"];
       // [FBSignIndictParams setObject:@""  forKey:@"u_country"];
       // [FBSignIndictParams setObject:@"google"  forKey:@"u_type"];
        
        
        //http://bulkbox.in/door2door/service/service_general.php?r_p=1224&service=get_user_detail&email=acharyajay007@gmail.com
        
        //gmil
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
-(void)CallGmailSignup
{
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,SocailMediaLogin_URL] withParam:FBSignIndictParams withCompletion:^(NSDictionary *response, BOOL success1)
         {
             [self handleGmailResponse:response];
         }];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
}
- (void)handleGmailResponse:(NSDictionary*)response
{
    //NSLog(@"Logindata==%@",response);
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        NSDictionary *olddic = [response mutableCopy];
        NSDictionary *newdict =[olddic dictionaryByReplacingNullsWithBlanks];
        NSMutableDictionary *dic = [[NSMutableDictionary  alloc] init];
        dic=[[newdict valueForKey:@"result"] objectAtIndex:0];
        [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"LoginUserDic"];
        [[NSUserDefaults standardUserDefaults] setObject:@"social" forKey:@"USERLOGINTYPE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        SearchByShop *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchByShop"];
        [self.navigationController pushViewController:vcr animated:YES];
        
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:@"Login Successfully." delegate:nil];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
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
         NSDictionary *olddic = [response mutableCopy];
        NSDictionary *newdict =[olddic dictionaryByReplacingNullsWithBlanks];
        NSMutableDictionary *dic = [[NSMutableDictionary  alloc] init];
        dic=[[newdict valueForKey:@"result"] objectAtIndex:0];
        [[NSUserDefaults standardUserDefaults]setObject:dic forKey:@"LoginUserDic"];
        [[NSUserDefaults standardUserDefaults] setObject:@"social" forKey:@"USERLOGINTYPE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
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
        [[NSUserDefaults standardUserDefaults] setObject:@"simple" forKey:@"USERLOGINTYPE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        SearchByShop *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchByShop"];
        [self.navigationController pushViewController:vcr animated:YES];
       
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==Password_TXT)
    {
        if ([textField.text isEqualToString:@""])
        {
            imgforLeft.hidden=YES;
        }
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *resultStr = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (range.location == 0 && [string isEqualToString:@" "])
    {
        imgforLeft.hidden=YES;
        return NO;
    }
    if (textField==Password_TXT)
    {
        if (range.location == textField.text.length && [string isEqualToString:@" "])
        {
            imgforLeft.hidden=YES;
            // ignore replacement string and add your own
            textField.text = [textField.text stringByAppendingString:@""];
            return NO;
        }
        else
        {
            if ([resultStr isEqualToString:@""])
            {
                imgforLeft.hidden=YES;
            }
            else
            {
                imgforLeft.hidden=NO;
            }
            
            return YES;
        }
    }
    return YES;

}

-(BOOL)textFieldShouldReturn:(UITextField * )textField
{
    imgforLeft.hidden=YES;
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
