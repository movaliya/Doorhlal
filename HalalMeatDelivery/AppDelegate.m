//
//  AppDelegate.m
//  HalalMeatDelivery
//
//  Created by kaushik on 23/08/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import "AppDelegate.h"
#import "HalalMeatDelivery.pch"
#import "Constant.h"
@import Stripe;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //Google
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    //Facebook
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    //Twitter
    [[Twitter sharedInstance] startWithConsumerKey:@"M68MwH3dpgYz0MIeOrfXGKXy2" consumerSecret:@"bpweoifXH3c7oQ1f5bBu3nXim2RBBbYgV8ywRfK8GrXyn3buGm"];
    
    [self prefersStatusBarHidden];
    [[UIApplication sharedApplication] setStatusBarHidden:YES  withAnimation:UIStatusBarAnimationSlide];
    

    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        [self GetPublishableKey];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
    
    
//sandBoxKey: AQUjbRYq2t8ExCL0hxJ0Tyd20lOc_fS16qhEuweO8ojBdMNGfF2ZDRBtDV5yl2xyhz5dq59WLgv4X0-q
    
    // com.inertiasoftech6.halalMeat
    
    //com.jkinfoway.halalmeat
    //com.feedmemeat
    
    // PostCode LU1 1BT    uk pin

    /*
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
#endif
    */
    
//    
//    [FBLoginView class];
//    [FBProfilePictureView class];
   
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    if ([[FBSDKApplicationDelegate sharedInstance] application:app openURL:url options:options])
    {
        return YES;
    }
    else if ([[Twitter sharedInstance] application:app openURL:url options:options])
    {
        return YES;
    }
    else if([[url scheme] isEqualToString:GOOGLE_SCHEME])
    {
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                          annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }
    
    return NO;
}

-(void)SetimageinTextfield: (UITextField *)TXT :(NSString *)ImageName
{
    UIView *vw=[[UIView alloc]initWithFrame:CGRectMake(50, 0, 40, 50)];
    UIImageView *imgforLeft=[[UIImageView alloc] initWithFrame:CGRectMake(12, 13, 22, 22)];
    [imgforLeft setImage:[UIImage imageNamed:ImageName]];
    [imgforLeft setContentMode:UIViewContentModeCenter];
    [vw addSubview:imgforLeft];
    TXT.leftView=vw;
    TXT.leftViewMode=UITextFieldViewModeAlways;
    TXT.layer.cornerRadius=20.0f;
    
    [TXT setValue:[UIColor colorWithRed:116.0f/255.0f green:104.0f/255.0f blue:102.0f/255.0f alpha:1.0f] forKeyPath:@"_placeholderLabel.textColor"];
}

-(void)SetbuttonCorner :(UIButton *)BTN
{
    BTN.layer.cornerRadius=20.0f;
    BTN.layer.masksToBounds=YES;
}

-(void)GetPublishableKey
{
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:@"feedmemeathalal_publishable_key"  forKey:@"enc_string"];
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",StripeBaseUrl,StripePublishKey] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handlePublishKeyResponse:response];
     }];
}
- (void)handlePublishKeyResponse:(NSDictionary*)response
{
    
    //publisable_key: "pk_test_AdQkfvDPjhh5OBqmlJ5DGCub"
    
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        kstrStripePublishableKey=[[NSString alloc]init];
        kstrStripePublishableKey=[response objectForKey:@"publisable_key"];
        
        [[NSUserDefaults standardUserDefaults] setObject:kstrStripePublishableKey forKey:@"PublishableKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"kstrStripePublishableKey==%@",kstrStripePublishableKey);
        if (kstrStripePublishableKey != nil) {
            [[STPPaymentConfiguration sharedConfiguration] setPublishableKey:kstrStripePublishableKey];
        }
    }
    else
    {
        //[AppDelegate showErrorMessageWithTitle:@"Error" message:@"Nothing to Show" delegate:nil];
    }
    
}

+ (BOOL)connectedToNetwork{
    Reachability* reachability = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    BOOL isInternet;
    if(remoteHostStatus == NotReachable)
    {
        isInternet =NO;
    }
    else if (remoteHostStatus == ReachableViaWWAN)
    {
        isInternet = TRUE;
    }
    else if (remoteHostStatus == ReachableViaWiFi)
    { isInternet = TRUE;
        
    }
    return isInternet;
}
#pragma mark -
#pragma mark - UserDefault

- (BOOL)isUserLoggedIn
{
    //WSK_AUTH_TOKEN
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"LoginUserDic"])
    {
        return YES;
    }
    
    return NO;
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}
+ (AppDelegate *)sharedInstance
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

+(BOOL)IsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

+ (void)showErrorMessageWithTitle:(NSString *)title
                          message:(NSString*)message
                         delegate:(id)delegate {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    float duration = 3.0; // duration in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
}
+(void)showInternetErrorMessageWithTitle:(NSString *)title delegate:(id)delegate
{
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:title
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    
    float duration = 2.5; // duration in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBSDKAppEvents activateApp];

    
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GetLocation" object:nil];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}
@end
