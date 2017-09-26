//
//  LoginView.h
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
#import "NSDictionary+NullReplacementDic.h"
@interface LoginView : UIViewController<CCKFNavDrawerDelegate,GIDSignInUIDelegate,GIDSignInDelegate>
{
    NSDictionary *Maindic;
    NSMutableDictionary *FBSignIndictParams;
}
@property (strong,nonatomic) FBSDKLoginManager *loginMgr;
@property (strong, nonatomic) IBOutlet UILabel *TimeStatus_LBL;


@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@property (weak, nonatomic) IBOutlet UITextField *User_TXT;
@property (weak, nonatomic) IBOutlet UITextField *Password_TXT;
@property (strong, nonatomic) IBOutlet UIButton *Login_BTN;
@property (strong, nonatomic) IBOutlet UIButton *FaceBook_BTN;
- (IBAction)Facebook_click:(UIButton *)sender;

- (IBAction)Login_click:(id)sender;
- (IBAction)Forgot_Click:(id)sender;
- (IBAction)SignUp_Click:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *GustBTN;
- (IBAction)Guest_Click:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *Logi_View;
@property (strong, nonatomic) IBOutlet UIView *Passwor_View;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *LogoWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *LogoHight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *WelcomToLogoGap;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *WelcomeGap;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *TopLogoHight;

- (IBAction)backbtn_action:(id)sender;

@end
