//
//  RegisterView.h
//  HalalMeatDelivery
//
//  Created by kaushik on 23/08/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HalalMeatDelivery.pch"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Google/SignIn.h>
#import <TwitterKit/TwitterKit.h>

@interface RegisterView : UIViewController<CCKFNavDrawerDelegate,GIDSignInUIDelegate,GIDSignInDelegate>
{
    NSMutableDictionary *FBSignupdictParams;
}

@property (strong,nonatomic) FBSDKLoginManager *loginMgr;
@property (strong, nonatomic) CCKFNavDrawer *rootNav;

@property (strong, nonatomic) IBOutlet UIScrollView *ScrollView;
- (IBAction)Login_Click:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *SignUp_BTN;
@property (strong, nonatomic) IBOutlet UIButton *FaceBook_BTN;

@property (weak, nonatomic) IBOutlet UITextField *email_Txt;
@property (weak, nonatomic) IBOutlet UITextField *Username_Txt;
@property (weak, nonatomic) IBOutlet UITextField *address_Txt;
@property (strong, nonatomic) IBOutlet UITextField *address2_TXT;
@property (strong, nonatomic) IBOutlet UITextField *PhoneNo_TXT;

@property (weak, nonatomic) IBOutlet UITextField *pincode_Txt;
@property (weak, nonatomic) IBOutlet UITextField *password_Txt;
-(void)openActiveSessionWithPermissions:(NSArray *)permissions allowLoginUI:(BOOL)allowLoginUI;

- (IBAction)Signup_action:(id)sender;
- (IBAction)FB_signup:(id)sender;

@end
