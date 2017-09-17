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

@end
