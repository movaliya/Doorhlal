//
//  AppDelegate.h
//  HalalMeatDelivery
//
//  Created by kaushik on 23/08/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "Constant.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    
}

@property (strong, nonatomic) UIWindow *window;


-(void)openActiveSessionWithPermissions:(NSArray *)permissions allowLoginUI:(BOOL)allowLoginUI;
+(BOOL)connectedToNetwork;
+ (AppDelegate *)sharedInstance;
+(BOOL)IsValidEmail:(NSString *)checkString;

+ (void)showErrorMessageWithTitle:(NSString *)title
                          message:(NSString*)message
                         delegate:(id)delegate;

+(void)showInternetErrorMessageWithTitle:(NSString *)title delegate:(id)delegate;
- (BOOL)isUserLoggedIn;
-(void)GetPublishableKey;
-(void)SetbuttonCorner :(UIButton *)BTN;
-(void)SetimageinTextfield: (UITextField *)TXT :(NSString *)ImageName;

@end

