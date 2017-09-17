//
//  SelectPayment.m
//  HalalMeatDelivery
//
//  Created by Mango SW on 27/05/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "SelectPayment.h"
#import "HalalMeatDelivery.pch"
#import "PaymentView2.h"
@interface SelectPayment ()

@end

@implementation SelectPayment

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //********************* set Payment Method ***********************************
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"PAYMENTMETHOD"];
    if (savedValue)
    {
        if ([savedValue isEqualToString:@"CashOnDelivery"])
        {
            //[self.CashOnDeleveryRadio_Btn setBackgroundImage:[UIImage imageNamed:@"RadioEnable"] forState:UIControlStateNormal];
           // [self.PaymentRadio_btn setBackgroundImage:[UIImage imageNamed:@"RadioDisable"] forState:UIControlStateNormal];
            self.COD_Imageview.image=[UIImage imageNamed:@"RadioEnable"];
            self.OnlinePay_ImageView.image=[UIImage imageNamed:@"RadioDisable"];
            Paymethod_Str=@"0";
            
        }
        else
        {
           // [self.CashOnDeleveryRadio_Btn setBackgroundImage:[UIImage imageNamed:@"RadioDisable"] forState:UIControlStateNormal];
            //[self.PaymentRadio_btn setBackgroundImage:[UIImage imageNamed:@"RadioEnable"] forState:UIControlStateNormal];
            self.COD_Imageview.image=[UIImage imageNamed:@"RadioDisable"];
            self.OnlinePay_ImageView.image=[UIImage imageNamed:@"RadioEnable"];
            Paymethod_Str=@"3";
        }
    }
    //********************* END *************************************************
}

- (IBAction)COD_Btn_action:(id)sender
{
    //[self.CashOnDeleveryRadio_Btn setBackgroundImage:[UIImage imageNamed:@"RadioEnable"] forState:UIControlStateNormal];
    //[self.PaymentRadio_btn setBackgroundImage:[UIImage imageNamed:@"RadioDisable"] forState:UIControlStateNormal];
    self.COD_Imageview.image=[UIImage imageNamed:@"RadioEnable"];
    self.OnlinePay_ImageView.image=[UIImage imageNamed:@"RadioDisable"];
    Paymethod_Str=@"0";
}
- (IBAction)OnlinePaymentBtn_action:(id)sender
{
   // [self.CashOnDeleveryRadio_Btn setBackgroundImage:[UIImage imageNamed:@"RadioDisable"] forState:UIControlStateNormal];
   // [self.PaymentRadio_btn setBackgroundImage:[UIImage imageNamed:@"RadioEnable"] forState:UIControlStateNormal];
    self.COD_Imageview.image=[UIImage imageNamed:@"RadioDisable"];
    self.OnlinePay_ImageView.image=[UIImage imageNamed:@"RadioEnable"];
    Paymethod_Str=@"3";
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

-(void)SendPayMethod
{
    
    NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
    NSString *User_UID=[UserData valueForKey:@"u_id"];
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:place_order_part_2_take_awayServiceName  forKey:@"service"];
    [dictParams setObject:User_UID  forKey:@"uid"];
    [dictParams setObject:self.PayCart_ID  forKey:@"cid"];
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
        
        PaymentView2 *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaymentView2"];
        vcr.ChargesDIC=response;
        vcr.DateNTime=self.PassDatefrom1;
        vcr.Cart_ID=self.PayCart_ID;
        vcr.PaymentString=Paymethod_Str;
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
