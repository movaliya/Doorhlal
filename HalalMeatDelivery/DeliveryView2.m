//
//  DeliveryView2.m
//  HalalMeatDelivery
//
//  Created by kaushik on 02/05/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "DeliveryView2.h"
#import "HalalMeatDelivery.pch"
#import "DeliveryView3.h"
@interface DeliveryView2 ()

@end

@implementation DeliveryView2
@synthesize paymentView,paypalImageVW,stripeImageVW;

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
   // self.PaymentRadio_btn.hidden=YES;
    //self.PaymentRadio_btn.enabled=NO;
    
    
    
    //********************* set Payment Method ***********************************
    
    paymentView.hidden=YES;
    _mainViewHeight.constant=160;
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"PAYMENTMETHOD"];
    if (savedValue)
    {
        if ([savedValue isEqualToString:@"CashOnDelivery"])
        {
           // [self.CashOnDeleveryRadio_Btn setBackgroundImage:[UIImage imageNamed:@"RadioEnable"] forState:UIControlStateNormal];
           // [self.PaymentRadio_btn setBackgroundImage:[UIImage imageNamed:@"RadioDisable"] forState:UIControlStateNormal];
            
            self.COD_ImageView.image=[UIImage imageNamed:@"RadioEnable"];
            self.OnlinePay_ImageView.image=[UIImage imageNamed:@"RadioDisable"];
            Paymethod_Str=@"1";
            paymentView.hidden=YES;
            _mainViewHeight.constant=160;
            
        }
        else
        {
            //[self.CashOnDeleveryRadio_Btn setBackgroundImage:[UIImage imageNamed:@"RadioDisable"] forState:UIControlStateNormal];
           // [self.PaymentRadio_btn setBackgroundImage:[UIImage imageNamed:@"RadioEnable"] forState:UIControlStateNormal];
            
            self.COD_ImageView.image=[UIImage imageNamed:@"RadioDisable"];
            self.OnlinePay_ImageView.image=[UIImage imageNamed:@"RadioEnable"];
            Paymethod_Str=@"2";
            paymentView.hidden=NO;
            _mainViewHeight.constant=200;
        }
    }
    //********************* END *************************************************
}
- (IBAction)COD_Btn_action:(id)sender
{
    //[self.CashOnDeleveryRadio_Btn setBackgroundImage:[UIImage imageNamed:@"RadioEnable"] forState:UIControlStateNormal];
   // [self.PaymentRadio_btn setBackgroundImage:[UIImage imageNamed:@"RadioDisable"] forState:UIControlStateNormal];
    self.COD_ImageView.image=[UIImage imageNamed:@"RadioEnable"];
    self.OnlinePay_ImageView.image=[UIImage imageNamed:@"RadioDisable"];
    
    Paymethod_Str=@"1";
    paymentView.hidden=YES;
    _mainViewHeight.constant=160;
}
- (IBAction)OnlinePaymentBtn_action:(id)sender
{
   // [self.CashOnDeleveryRadio_Btn setBackgroundImage:[UIImage imageNamed:@"RadioDisable"] forState:UIControlStateNormal];
   // [self.PaymentRadio_btn setBackgroundImage:[UIImage imageNamed:@"RadioEnable"] forState:UIControlStateNormal];
    
    self.COD_ImageView.image=[UIImage imageNamed:@"RadioDisable"];
    self.OnlinePay_ImageView.image=[UIImage imageNamed:@"RadioEnable"];
    
    Paymethod_Str=@"2";
    paymentView.hidden=NO;
    _mainViewHeight.constant=200;
}
- (IBAction)stripBtn_Action:(id)sender
{
    stripeImageVW.image=[UIImage imageNamed:@"RadioEnable"];
    paypalImageVW.image=[UIImage imageNamed:@"RadioDisable"];
    paymentString=@"Stripe";
}
- (IBAction)paypalBtn_Action:(id)sender
{
    stripeImageVW.image=[UIImage imageNamed:@"RadioDisable"];
    paypalImageVW.image=[UIImage imageNamed:@"RadioEnable"];
    paymentString=@"Paypal";

}
- (IBAction)NextBtn_action:(id)sender
{
    self.NextBTN.enabled=NO;
    if(Paymethod_Str.length==0)
    {
        self.NextBTN.enabled=YES;
         [AppDelegate showErrorMessageWithTitle:@"ERROR..!" message:@"Please Select Payment Method." delegate:nil];
    }
    else
    {
        if ([Paymethod_Str isEqualToString:@"2"])
        {
            if (paymentString.length==0)
            {
                self.NextBTN.enabled=YES;
                [AppDelegate showErrorMessageWithTitle:@"ERROR..!" message:@"Please Select Sub Payment Method." delegate:nil];
            }
            else
            {
                BOOL internet=[AppDelegate connectedToNetwork];
                if (internet)
                {
                    [self performSelector:@selector(SendPayMethod) withObject:self afterDelay:0.0 ];
                    // [self SendPayMethod];
                }
                else
                {
                    self.NextBTN.enabled=YES;
                    [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
                }
            }
        }
        else
        {
            BOOL internet=[AppDelegate connectedToNetwork];
            if (internet)
            {
                [self performSelector:@selector(SendPayMethod) withObject:self afterDelay:0.0 ];
                // [self SendPayMethod];
            }
            else
            {
                self.NextBTN.enabled=YES;
                [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
            }
        }
    }
}

-(void)SendPayMethod
{
    
    NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
    NSString *User_UID=[UserData valueForKey:@"u_id"];
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:place_order_part_2_deliveryServiceName  forKey:@"service"];
    [dictParams setObject:User_UID  forKey:@"uid"];
    [dictParams setObject:self.CartID_DEL2  forKey:@"cid"];
    [dictParams setObject:Paymethod_Str  forKey:@"payment_mode"];
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,CardService_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handlePayMethodResponse:response];
     }];
}

- (void)handlePayMethodResponse:(NSDictionary*)response
{
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        
        DeliveryView3 *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DeliveryView3"];
        vcr.PAYMENT_STR=Paymethod_Str;
        vcr.ChargesDICNORY3=[response mutableCopy];
        vcr.DateNTimeSTR=self.dateNtime2;
        vcr.CartID_DEL3=self.self.CartID_DEL2;
         vcr.PaymentType=paymentString;
        
        [self.navigationController pushViewController:vcr animated:NO];
        [AppDelegate showErrorMessageWithTitle:@"" message:[response objectForKey:@"ack_msg"] delegate:nil];
        self.NextBTN.enabled=YES;

    }
    else
    {
        self.NextBTN.enabled=YES;

        [AppDelegate showErrorMessageWithTitle:@"" message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
}



- (IBAction)BackBtn_action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)PreviousBtn_action:(id)sender
{
    //self.PreviousBTN.enabled=NO;
     [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
