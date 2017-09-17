//
//  Forgotpasswordview.h
//  HalalMeatDelivery
//
//  Created by kaushik on 24/09/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HalalMeatDelivery.pch"

@interface Forgotpasswordview : UIViewController<CCKFNavDrawerDelegate>
{
    NSString *activation_code;
}
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *fisrtView;
@property (weak, nonatomic) IBOutlet UIView *ThirdView;
@property (weak, nonatomic) IBOutlet UIView *FourthView;

@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@property (weak, nonatomic) IBOutlet UITextField *EmailAddressTxt;
- (IBAction)FindAccount_action:(id)sender;
- (IBAction)Continue_action:(id)sender;
- (IBAction)ResendCodeBtn_action:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *DisplayEmailLBL;
@property (weak, nonatomic) IBOutlet UITextField *SecurityCodeTXT;
@property (weak, nonatomic) IBOutlet UIButton *comtinueBtn;
@property (weak, nonatomic) IBOutlet UIButton *findAccBtn;
@property (weak, nonatomic) IBOutlet UITextField *ChangeForgtTxt;
@property (weak, nonatomic) IBOutlet UITextField *RetryPsswdTxt;
@property (weak, nonatomic) IBOutlet UIButton *chagePwdBtn;
- (IBAction)ChangePwd_action:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;
- (IBAction)LoginBtn_action:(id)sender;

@end
