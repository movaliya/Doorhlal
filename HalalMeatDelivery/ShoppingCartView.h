//
//  ShoppingCartView.h
//  HalalMeatDelivery
//
//  Created by kaushik on 28/08/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HalalMeatDelivery.pch"
#import "AlertView.h"

@interface ShoppingCartView : UIViewController<CCKFNavDrawerDelegate>
{
    NSMutableDictionary *CardDicnory,*deleteproductDic;
    NSMutableDictionary *itemDetailDic;
    NSInteger ButtonTag;
    NSUInteger chechPlusMinus;
    NSUInteger SubTotalValues;
    NSUInteger OldSubTotalValues;
    AlertView *POPView;
    
    NSString *theDate;
    NSString *theTime;
    
    NSString *Paymethod_Str;
    
    NSString *deleteQTY;
}
@property (weak, nonatomic) IBOutlet UIImageView *RestorantImage;
@property (weak, nonatomic) IBOutlet UILabel *RestNameLBL;
@property (weak, nonatomic) IBOutlet UILabel *RestAddressLBL;
@property (weak, nonatomic) IBOutlet UILabel *RestDeleveryLBL;
@property (weak, nonatomic) IBOutlet UILabel *JustDeleveyLBL;
@property (weak, nonatomic) IBOutlet UIImageView *justCellRestImge;

@property (strong, nonatomic) UIView *POPFristView;
@property (strong, nonatomic) UIView *POPSecondView;
@property (strong, nonatomic) UIView *POPThirdView;

@property (strong, nonatomic) UIButton *POPTakeAway;
@property (strong, nonatomic) UIButton *POPDelivery;

@property (strong, nonatomic) UIButton *POPTakeAway44;
@property (strong, nonatomic) UIButton *POPDelivery55;
@property (strong, nonatomic) UIButton *POPTakeAway66;

@property (strong, nonatomic) IBOutlet UIView *RestruntNameView;

@property (strong, nonatomic) UIButton *POPCancel;
@property (strong, nonatomic) UIButton *POPProceed;
@property (strong, nonatomic) UILabel *POPMinValue;
@property (weak, nonatomic) IBOutlet UILabel *Total_LBL;
@property (strong, nonatomic) CCKFNavDrawer *rootNav;
- (IBAction)CheckOut_btnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *upperView;
@property (weak, nonatomic) IBOutlet UILabel *upperOrderQTYLBL;
@property (weak, nonatomic) IBOutlet UILabel *upperTotalLBL;
@property (weak, nonatomic) IBOutlet UITextField *SelectDate_TXT;
@property (weak, nonatomic) IBOutlet UILabel *upperDateGBLBL;
@property (weak, nonatomic) IBOutlet UIImageView *UpperDeliveryRadioImage;
@property (weak, nonatomic) IBOutlet UIImageView *upperTakeAwayImage;
@property (weak, nonatomic) IBOutlet UIButton *CheckoutBTN;

@end
