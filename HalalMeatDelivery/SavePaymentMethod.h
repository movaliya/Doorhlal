//
//  SavePaymentMethod.h
//  HalalMeatDelivery
//
//  Created by Mango SW on 29/04/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SavePaymentMethod : UIViewController
{
    NSString *Paymethod_Str;
}
@property (weak, nonatomic) IBOutlet UIImageView *CashOndlvryIMAGE;
@property (weak, nonatomic) IBOutlet UIImageView *OnlinePaymtIMAGE;
@property (weak, nonatomic) IBOutlet UIButton *SaveBtn;
@property (weak, nonatomic) IBOutlet UIView *MainVIEW;
@property (weak, nonatomic) IBOutlet UIButton *onlinePay_Btn;
@property (weak, nonatomic) IBOutlet UIView *paymentView;
@property (weak, nonatomic) IBOutlet UIImageView *stripeimgeVW;
@property (weak, nonatomic) IBOutlet UIImageView *paypalimageVW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewHeight;

@end
