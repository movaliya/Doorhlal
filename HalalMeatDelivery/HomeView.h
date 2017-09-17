//
//  HomeView.h
//  HalalMeatDelivery
//
//  Created by kaushik on 24/08/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HalalMeatDelivery.pch"

@interface HomeView : UIViewController<CCKFNavDrawerDelegate>
{
    NSDictionary *Maindic;
}
@property (weak, nonatomic) IBOutlet UITextField *pincodeTxt;

@property (strong, nonatomic) CCKFNavDrawer *rootNav;

@property (strong, nonatomic) IBOutlet UIButton *SearchByStore_BTN;
- (IBAction)SearchBySore_click:(id)sender;


@property (strong, nonatomic) IBOutlet UIButton *Search_BTN;
- (IBAction)SearchBtn_Action:(id)sender;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *LogoHight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *LogoWidht;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *LogoLBL_Gap;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *Search_Gap;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *TopLogoGap;



@end
