//
//  DeliveryView2.h
//  HalalMeatDelivery
//
//  Created by kaushik on 02/05/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliveryView2 : UIViewController
{
    NSString *Paymethod_Str;
    NSString *final_total;
    NSMutableDictionary *paypalInfoDic;
}
@property (strong, nonatomic) NSDictionary *ChargesDICNORY;
@property (strong, nonatomic) NSString *CartID_DEL2;
@property (strong, nonatomic) NSString *dateNtime2;
@property (weak, nonatomic) IBOutlet UIButton *CashOnDeleveryRadio_Btn;
@property (weak, nonatomic) IBOutlet UIButton *PaymentRadio_btn;
@property (weak, nonatomic) IBOutlet UIImageView *COD_ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *OnlinePay_ImageView;
@property (weak, nonatomic) IBOutlet UIButton *NextBTN;
@property (weak, nonatomic) IBOutlet UIButton *PreviousBTN;

@end
