//
//  SavePaymentMethod.m
//  HalalMeatDelivery
//
//  Created by Mango SW on 29/04/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "SavePaymentMethod.h"
#import "HalalMeatDelivery.pch"
@interface SavePaymentMethod ()

@end

@implementation SavePaymentMethod
@synthesize SaveBtn,MainVIEW,CashOndlvryIMAGE,OnlinePaymtIMAGE;
@synthesize stripeimgeVW,paypalimageVW;


- (void)viewDidLoad
{
    [super viewDidLoad];
    MainVIEW.layer.masksToBounds = NO;
    MainVIEW.layer.shadowOffset = CGSizeMake(-4,4);
    MainVIEW.layer.shadowRadius = 5;
    MainVIEW.layer.shadowOpacity = 0.5;
    
    SaveBtn.layer.cornerRadius=11;
    SaveBtn.layer.masksToBounds=YES;
    SaveBtn.layer.borderColor=[[UIColor colorWithRed:161.0f/255.0f green:32.0f/255.0f blue:40.0f/255.0f alpha:1.0] CGColor];
    SaveBtn.layer.borderWidth=1;
    
    // OnlinePaymtIMAGE.hidden=YES;
    //self.onlinePay_Btn.hidden=YES;
   // self.onlinePay_Btn.enabled=NO;
    _paymentView.hidden=YES;
    self.mainViewHeight.constant=250;
    
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"PAYMENTMETHOD"];
    if (savedValue)
    {
        if ([savedValue isEqualToString:@"CashOnDelivery"])
        {
            CashOndlvryIMAGE.image=[UIImage imageNamed:@"RadioEnable"];
            OnlinePaymtIMAGE.image=[UIImage imageNamed:@"RadioDisable"];
            
            Paymethod_Str=@"CashOnDelivery";
            _paymentView.hidden=YES;
            self.mainViewHeight.constant=250;
        }
        else
        {
            CashOndlvryIMAGE.image=[UIImage imageNamed:@"RadioDisable"];
            OnlinePaymtIMAGE.image=[UIImage imageNamed:@"RadioEnable"];
            
            Paymethod_Str=@"OnlinePayment";
            _paymentView.hidden=NO;
            self.mainViewHeight.constant=325;
        }
    }
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)CashOnDelivery_Action:(id)sender
{
    CashOndlvryIMAGE.image=[UIImage imageNamed:@"RadioEnable"];
    OnlinePaymtIMAGE.image=[UIImage imageNamed:@"RadioDisable"];
    
    Paymethod_Str=@"CashOnDelivery";
    _paymentView.hidden=YES;
    self.mainViewHeight.constant=250;
   
}

- (IBAction)OnlinePayment_action:(id)sender
{
    CashOndlvryIMAGE.image=[UIImage imageNamed:@"RadioDisable"];
    OnlinePaymtIMAGE.image=[UIImage imageNamed:@"RadioEnable"];
    
    Paymethod_Str=@"OnlinePayment";
    _paymentView.hidden=NO;
    self.mainViewHeight.constant=325;
    
}

- (IBAction)stripeBtn_Action:(id)sender
{
    stripeimgeVW.image=[UIImage imageNamed:@"RadioEnable"];
    paypalimageVW.image=[UIImage imageNamed:@"RadioDisable"];
}
- (IBAction)paypalBtn_Action:(id)sender
{
    stripeimgeVW.image=[UIImage imageNamed:@"RadioDisable"];
    paypalimageVW.image=[UIImage imageNamed:@"RadioEnable"];
}

- (IBAction)SaveBtn_action:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:Paymethod_Str forKey:@"PAYMENTMETHOD"];
    [[NSUserDefaults standardUserDefaults] synchronize];
     [AppDelegate showErrorMessageWithTitle:@"Success" message:@"Payment Method Save Successfully." delegate:nil];

}

- (IBAction)BackBtn_action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
