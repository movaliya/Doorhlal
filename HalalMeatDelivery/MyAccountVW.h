//
//  MyAccountVW.h
//  HalalMeatDelivery
//
//  Created by Mango SW on 29/04/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HalalMeatDelivery.pch"

@interface MyAccountVW : UIViewController<CCKFNavDrawerDelegate>

@property (strong, nonatomic) CCKFNavDrawer *rootNav;

@property (strong, nonatomic) IBOutlet UIView *KLogOutView;
@property (strong, nonatomic) IBOutlet UIView *KLoginView;
@end
