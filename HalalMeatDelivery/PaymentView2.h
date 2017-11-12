//
//  PaymentView2.h
//  HalalMeatDelivery
//
//  Created by kaushik on 02/05/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Stripe/Stripe.h>
#import "PayPalMobile.h"

typedef NS_ENUM(NSInteger, STPBackendChargeResult) {
    STPBackendChargeResultSuccess,
    STPBackendChargeResultFailure,
};

typedef void (^STPSourceSubmissionHandler)(STPBackendChargeResult status, NSError *error);
@protocol ExampleViewControllerDelegate <NSObject>

- (void)exampleViewController:(UIViewController *)controller didFinishWithMessage:(NSString *)message;
- (void)exampleViewController:(UIViewController *)controller didFinishWithError:(NSError *)error;
- (void)createBackendChargeWithSource:(NSString *)sourceID completion:(STPSourceSubmissionHandler)completion;
@end

@interface PaymentView2 : UIViewController<PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate>
{
     NSMutableDictionary *take_away_address;
    NSString *final_total;
    NSMutableDictionary *PaymentProofDic;
    NSMutableDictionary *paypalInfoDic;
}


@property (strong, nonatomic) NSDictionary *ChargesDIC;
@property (strong, nonatomic) NSString *DateNTime;
@property (strong, nonatomic) NSString *Cart_ID;
@property (strong, nonatomic) NSString *PaymentString;
@property (strong, nonatomic) NSString *PaymentType;

@property (weak, nonatomic) IBOutlet UILabel *TakeAwayDateTime;
@property (weak, nonatomic) IBOutlet UILabel *SubTotal_LBL;
@property (weak, nonatomic) IBOutlet UILabel *ShippingCharge_LBL;
@property (weak, nonatomic) IBOutlet UILabel *ShippingDiscount_LBL;
@property (weak, nonatomic) IBOutlet UILabel *Grand_Total_LBL;
@property (weak, nonatomic) IBOutlet UITextField *Comment_TXT;

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, strong, readwrite) NSString *resultText;
@end
