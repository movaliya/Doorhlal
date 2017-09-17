//
//  PaymentView.h
//  HalalMeatDelivery
//
//  Created by kaushik on 04/09/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HalalMeatDelivery.pch"

@interface PaymentView : UIViewController
{
    NSString *C_ID;
    NSString *theDate;
    NSString *theTime;
    NSMutableDictionary *take_away_address;
    
}
@property (strong, nonatomic) NSString *theDate;
@property (strong, nonatomic) NSString *theTime;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *SecondViewGap;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *TherdViewGap;
@property (weak, nonatomic) IBOutlet UIScrollView *myscrollview;
@property (weak, nonatomic) IBOutlet UIButton *confrom_btn;
@property (weak, nonatomic) IBOutlet UILabel *TakeAwayDateTime;

@property (strong, nonatomic) IBOutlet UIButton *PlaceOrder_BTN;
@property (strong, nonatomic) NSString *C_ID;
@property (strong, nonatomic) IBOutlet UIButton *Change_BTN;
- (IBAction)Change_Click:(id)sender;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *Scroll_hight;
@property (weak, nonatomic) IBOutlet UITextField *UserName_txt;
@property (weak, nonatomic) IBOutlet UITextField *UserEmail_txt;
@property (weak, nonatomic) IBOutlet UITextField *UserPhoneNo_txt;
@property (weak, nonatomic) IBOutlet UITextField *UserPincode_txt;
@property (weak, nonatomic) IBOutlet UITextField *UserAddress_txt;
@property (weak, nonatomic) IBOutlet UITextField *UserCity_txt;
@property (weak, nonatomic) IBOutlet UILabel *SubTotal_LBL;
@property (weak, nonatomic) IBOutlet UILabel *ShippingCharge_LBL;
@property (weak, nonatomic) IBOutlet UILabel *ShippingDiscount_LBL;
@property (weak, nonatomic) IBOutlet UILabel *Grand_Total_LBL;
- (IBAction)PlaceOrder_Action:(id)sender;

- (IBAction)Back_Click:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *FirstView;
@property (strong, nonatomic) IBOutlet UIView *SecondView;
@property (strong, nonatomic) IBOutlet UITextField *Time_TXT;
- (IBAction)DateConfrim_Action:(id)sender;
@end
