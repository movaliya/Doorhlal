//
//  DeliveryView3.h
//  HalalMeatDelivery
//
//  Created by kaushik on 02/05/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HalalMeatDelivery.pch"
#import <Stripe/Stripe.h>

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

@interface DeliveryView3 : UIViewController
{
    NSString *final_total;
    NSMutableDictionary *PaymentProofDic;
}
@property (weak, nonatomic) IBOutlet UILabel *DileveryDateTimeLBL;
@property (weak, nonatomic) IBOutlet UILabel *SubTotal_LBL;
@property (weak, nonatomic) IBOutlet UILabel *ShippingCharge_LBL;
@property (weak, nonatomic) IBOutlet UILabel *ShippingDiscount_LBL;
@property (weak, nonatomic) IBOutlet UILabel *Grand_Total_LBL;

@property (strong, nonatomic) NSDictionary *ChargesDICNORY3;
@property (strong, nonatomic) NSString *DateNTimeSTR;
@property (strong, nonatomic) NSString *CartID_DEL3;
@property (strong, nonatomic) NSString *PAYMENT_STR;

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, strong, readwrite) NSString *resultText;
@property (weak, nonatomic) IBOutlet UITextField *Comment_TXT;
@end
