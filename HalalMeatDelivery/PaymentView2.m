//
//  PaymentView2.m
//  HalalMeatDelivery
//
//  Created by kaushik on 02/05/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "PaymentView2.h"
#import "HalalMeatDelivery.pch"
#import "ThankYouView.h"
#import "ShoppingCartView.h"
#import "HomeView.h"
#import "AddCreditCardView.h"

@import Stripe;



@interface PaymentView2 ()<STPAddCardViewControllerDelegate,STPPaymentContextDelegate,ExampleViewControllerDelegate>
{
    STPPaymentContext *paymentContext;
    ThankYouView *ThankPOPUp;
}
-(void)submitTokenToBackend:(STPToken *)token;

@property (nonatomic) STPAPIClient *apiClient;
@property (strong, nonatomic) STPPaymentContext *paymentContext;

@property (strong, nonatomic) UIButton *ThanksOK;
@property (strong, nonatomic) UILabel *NamePop;
@property (strong, nonatomic) UILabel *MobilePop;
@property (strong, nonatomic) UILabel *CityPop;
@property (strong, nonatomic) UILabel *AddressPop;

@end

@implementation PaymentView2
@synthesize ThanksOK;
@synthesize NamePop,MobilePop,CityPop,AddressPop;
@synthesize Comment_TXT;

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        //[self Set_up_payPalConfig];
        [self checkStripKey];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
    _SubTotal_LBL.text=[NSString stringWithFormat:@"$ %@",[self.ChargesDIC valueForKey:@"sub_total"]];
    _ShippingCharge_LBL.text= [NSString stringWithFormat:@"+ $ %@",[self.ChargesDIC valueForKey:@"shipping_charge"]];
    _ShippingDiscount_LBL.text=[NSString stringWithFormat:@"- $ %@",[self.ChargesDIC valueForKey:@"shipping_discount"]];
    _Grand_Total_LBL.text=[NSString stringWithFormat:@"$ %@",[self.ChargesDIC valueForKey:@"final_total"]];
    _TakeAwayDateTime.text=self.DateNTime;
    final_total=[self.ChargesDIC valueForKey:@"final_total"];
    
    ThankPOPUp =[[[NSBundle mainBundle]loadNibNamed:@"TakeawayThaxView" owner:nil options:nil]firstObject];
    ThankPOPUp.frame =self.view.frame;
    [self.view addSubview:ThankPOPUp];
    ThankPOPUp.hidden=YES;
    
}
-(void)checkStripKey
{
    
    if (![Stripe defaultPublishableKey])
    {
        NSString *PublishableKey = [[NSUserDefaults standardUserDefaults]
                                    stringForKey:@"PublishableKey"];
        if (!PublishableKey) {
            [self storeDataWithCompletion:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString * PublishableKey = [[NSUserDefaults standardUserDefaults]
                                                 stringForKey:@"PublishableKey"];
                    [[STPPaymentConfiguration sharedConfiguration] setPublishableKey:PublishableKey];
                });
            }];
        }
        else
        {
            [[STPPaymentConfiguration sharedConfiguration] setPublishableKey:PublishableKey];
        }
    }
}
- (void)storeDataWithCompletion:(void (^)(void))completion
{
    // Store Data Processing...
    if (completion) {
        [KmyappDelegate GetPublishableKey];
    }
}
- (IBAction)PlaceOrderBtn_action:(id)sender
{
    
    
    if ([self.PaymentString isEqualToString:@"3"])
    {
        // Stripe Payment
        AddCreditCardView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddCreditCardView"];
        vcr.delegate = self;
        vcr.amount=[NSDecimalNumber decimalNumberWithString:final_total];
        [self.navigationController pushViewController:vcr animated:YES];
        
    }
    else
    {
        
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
        {
            NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
            NSString *User_UID=[UserData valueForKey:@"u_id"] ;
            
            NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
            [dictParams setObject:r_p  forKey:@"r_p"];
            [dictParams setObject:place_order_part_3_take_away_collectionServiceName  forKey:@"service"];
            [dictParams setObject:User_UID  forKey:@"uid"];
            [dictParams setObject:self.Cart_ID  forKey:@"cid"];
            [dictParams setObject:Comment_TXT.text  forKey:@"remarks"];
            
            
            NSLog(@"placeorder change Dic=%@",dictParams);
            
            [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,CardService_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
             {
                 [self handlePlaceOrderResponse:response];
             }];
        }
        else
            [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    }
    
}
- (void)handlePlaceOrderResponse:(NSDictionary*)response
{
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        take_away_address=[[response objectForKey:@"result"] objectForKey:@"take_away_address"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"QUANTITYCOUNT"];
        [self ShowPOPUP];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
}

-(void)proof_of_payment
{
    
    NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
    NSString *User_UID=[UserData valueForKey:@"u_id"];
    
    NSString *status_code;
    NSString *failure_message;
    NSString *order_status;
    if ([[[PaymentProofDic objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        status_code=@"1";
        failure_message=@"";
        order_status=@"approved";
    }
    else
    {
        status_code=@"0";
        failure_message=@"unsuccessful";
        order_status=@"failed";
    }
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:place_order_part_3_take_away_onlinePayServiceName  forKey:@"service"];
    [dictParams setObject:User_UID  forKey:@"uid"];
    [dictParams setObject:self.Cart_ID  forKey:@"cid"];
    
    // Payment Detail
    [dictParams setObject:status_code  forKey:@"status_code"];
    [dictParams setObject:[PaymentProofDic valueForKey:@"transaction_id"]  forKey:@"tracking_id"];
    [dictParams setObject:@"Stripe"  forKey:@"payment_method"];
    [dictParams setObject:order_status  forKey:@"order_status"];
    [dictParams setObject:failure_message  forKey:@"failure_message"];
    [dictParams setObject:@"USD"  forKey:@"currency"];
    [dictParams setObject:final_total  forKey:@"amount"];
    [dictParams setObject:Comment_TXT.text  forKey:@"remarks"];
    
    NSLog(@"StripeDetalDic=%@",dictParams);
    
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,CardService_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handlePlacePayPalOrderResponse:response];
     }];
}

- (void)handlePlacePayPalOrderResponse:(NSDictionary*)response
{
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        take_away_address=[[response objectForKey:@"result"] objectForKey:@"take_away_address"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"QUANTITYCOUNT"];
        [self ShowPOPUP];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
}

#pragma mark STPAddCardViewControllerDelegate

#pragma mark - STPBackendCharging

- (void)createBackendChargeWithSource:(NSString *)sourceID completion:(STPSourceSubmissionHandler)completion {
    
    NSLog(@"Token==%@",sourceID);
    if (sourceID)
    {
        completion(STPBackendChargeResultSuccess, nil);
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
        {
            [self ChargeCards:sourceID paidAmount:final_total];
        }
        else
        {
            NSError *error;
            [self exampleViewController:self didFinishWithError:error];
            //[AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
        }
    }
    return;
    
}
-(void)ChargeCards:(NSString *)token paidAmount:(NSString *)Amoumnt
{
    
    NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
    NSString *User_EMAIL=[UserData valueForKey:@"u_email"];
    
    Amoumnt = [Amoumnt stringByReplacingOccurrencesOfString:@".00" withString:@""];
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:token  forKey:@"stripeToken"];
    [dictParams setObject:User_EMAIL  forKey:@"customer_email"];
    [dictParams setObject:Amoumnt  forKey:@"amount"];
    [dictParams setObject:@"GBP"  forKey:@"currency"];
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",StripeBaseUrl,ChargeCard_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleChargeResponse:response];
     }];
    
}

- (void)handleChargeResponse:(NSDictionary*)response
{
    
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        [self exampleViewController:self didFinishWithMessage:@"Payment successfully created"];
        PaymentProofDic=[response mutableCopy];
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
        {
            [self proof_of_payment];
            
        }
        else
            [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    }
    else
    {
       // NSError *error;
         [self.navigationController popViewControllerAnimated:YES];
       // [self exampleViewController:self didFinishWithError:error];
        [AppDelegate showErrorMessageWithTitle:@"" message:[response objectForKey:@"ack_msg"] delegate:nil];
        
    }
    
}
#pragma mark - ExampleViewControllerDelegate

- (void)exampleViewController:(UIViewController *)controller didFinishWithMessage:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES ];
    });
}

- (void)exampleViewController:(UIViewController *)controller didFinishWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
            [controller dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:action];
        [controller presentViewController:alertController animated:YES completion:nil];
    });
}


#pragma mark - pop AlertView;

-(void)ShowPOPUP
{
    [ThankPOPUp bringSubviewToFront:self.view];
    ThankPOPUp.hidden=NO;
    
    ThanksOK= (UIButton *)[ThankPOPUp viewWithTag:23];
    ThanksOK.layer.cornerRadius=3.5;
    [ThanksOK addTarget:self action:@selector(ThanksOK_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    NamePop= (UILabel *)[ThankPOPUp viewWithTag:100];
    MobilePop= (UILabel *)[ThankPOPUp viewWithTag:101];
    CityPop= (UILabel *)[ThankPOPUp viewWithTag:102];
    AddressPop= (UILabel *)[ThankPOPUp viewWithTag:103];
    
    
    AddressPop.numberOfLines = 0;
    [AddressPop sizeToFit];
    
    NamePop.text=[take_away_address valueForKey:@"name"];
    MobilePop.text=[take_away_address valueForKey:@"phone"];
    CityPop.text=[take_away_address valueForKey:@"city"];
    AddressPop.text=[take_away_address valueForKey:@"address"];
    
}

-(void)ThanksOK_Click:(id)sender
{
    ThankPOPUp.hidden=YES;
    
    HomeView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeView"];
    [self.navigationController pushViewController:vcr animated:NO];
}
- (IBAction)backBtn_action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)PreviousBtn_action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
