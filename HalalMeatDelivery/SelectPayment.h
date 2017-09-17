//
//  SelectPayment.h
//  HalalMeatDelivery
//
//  Created by Mango SW on 27/05/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectPayment : UIViewController
{
    NSString *Paymethod_Str;
    NSString *final_total;
}
@property (strong, nonatomic) NSString *PayCart_ID;
@property (strong, nonatomic) NSString *PassDatefrom1;
@property (weak, nonatomic) IBOutlet UIImageView *COD_Imageview;
@property (weak, nonatomic) IBOutlet UIImageView *OnlinePay_ImageView;

@property (weak, nonatomic) IBOutlet UIButton *CashOnDeleveryRadio_Btn;
@property (weak, nonatomic) IBOutlet UIButton *PaymentRadio_btn;
@property (weak, nonatomic) IBOutlet UIButton *NextBTN;
@property (weak, nonatomic) IBOutlet UIButton *PreviousBTN;
@end
