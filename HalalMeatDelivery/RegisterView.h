//
//  RegisterView.h
//  HalalMeatDelivery
//
//  Created by kaushik on 23/08/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HalalMeatDelivery.pch"

@interface RegisterView : UIViewController<CCKFNavDrawerDelegate>
{
    NSMutableDictionary *FBSignupdictParams;
}
@property (strong, nonatomic) CCKFNavDrawer *rootNav;

@property (strong, nonatomic) IBOutlet UIScrollView *ScrollView;
- (IBAction)Login_Click:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *SignUp_BTN;
@property (strong, nonatomic) IBOutlet UIButton *FaceBook_BTN;

@property (weak, nonatomic) IBOutlet UITextField *email_Txt;
@property (weak, nonatomic) IBOutlet UITextField *Username_Txt;
@property (weak, nonatomic) IBOutlet UITextField *address_Txt;
@property (weak, nonatomic) IBOutlet UITextField *pincode_Txt;
@property (weak, nonatomic) IBOutlet UITextField *password_Txt;
-(void)openActiveSessionWithPermissions:(NSArray *)permissions allowLoginUI:(BOOL)allowLoginUI;

- (IBAction)Signup_action:(id)sender;
- (IBAction)FB_signup:(id)sender;

@end
