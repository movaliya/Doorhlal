//
//  Forgotpasswordview.m
//  HalalMeatDelivery
//
//  Created by kaushik on 24/09/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import "Forgotpasswordview.h"
#import "AppDelegate.h"

@interface Forgotpasswordview ()
@property AppDelegate *appDelegate;

@end

@implementation Forgotpasswordview

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.secondView setHidden:YES];
    [self.ThirdView setHidden:YES];
    [self.FourthView setHidden:YES];
    
    // Give Button Corner and Shadow to View
    self.comtinueBtn.layer.cornerRadius=3;
    self.findAccBtn.layer.cornerRadius=3;
    self.chagePwdBtn.layer.cornerRadius=3;
    self.LoginBtn.layer.cornerRadius=3;
    
    [self.fisrtView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.fisrtView.layer setShadowOpacity:0.8];
    [self.fisrtView.layer setShadowRadius:3.0];
    [self.fisrtView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    [self.secondView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.secondView.layer setShadowOpacity:0.8];
    [self.secondView.layer setShadowRadius:3.0];
    [self.secondView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    [self.ThirdView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.ThirdView.layer setShadowOpacity:0.8];
    [self.ThirdView.layer setShadowRadius:3.0];
    [self.ThirdView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    [self.FourthView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.FourthView.layer setShadowOpacity:0.8];
    [self.FourthView.layer setShadowRadius:3.0];
    [self.FourthView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];

    
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav.pan_gr setEnabled:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)back_action:(id)sender {
    
    _EmailAddressTxt.text=@"";
    _SecurityCodeTXT.text=@"";
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)FindAccount_action:(id)sender {
    
    [self.EmailAddressTxt resignFirstResponder];
    
    if ([self.EmailAddressTxt.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Email Address" delegate:nil];
    }
    else
    {
        if (![AppDelegate IsValidEmail:self.EmailAddressTxt.text])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter valid email" delegate:nil];
        }
        else
        {
            
            BOOL internet=[AppDelegate connectedToNetwork];
            if (internet)
            {
                NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
                [dictParams setObject:r_p  forKey:@"r_p"];
                [dictParams setObject:forget_passwordServiceName  forKey:@"service"];
                [dictParams setObject:self.EmailAddressTxt.text  forKey:@"email"];
                NSLog(@"forgot pass=%@",dictParams);
                
                [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,UpdateProfile_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
                 {
                     [self handleSendEmailResponse:response];
                 }];
            }
            else
                [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
           
        }
    }
}
- (void)handleSendEmailResponse:(NSDictionary*)response
{
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        activation_code=[response valueForKey:@"activation_code"];
        self.DisplayEmailLBL.text=self.EmailAddressTxt.text;
        self.SecurityCodeTXT.text=@"Z-######";
        [self.secondView setHidden:NO];
        [self.fisrtView setHidden:YES];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
    
}

- (IBAction)Continue_action:(id)sender
{
    
    [self.SecurityCodeTXT resignFirstResponder];

    if ([self.SecurityCodeTXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Security Code" delegate:nil];
    }
    else
    {
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
        {
            NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
            [dictParams setObject:r_p  forKey:@"r_p"];
            [dictParams setObject:check_securityServiceName  forKey:@"service"];
            [dictParams setObject:self.EmailAddressTxt.text  forKey:@"email"];
            [dictParams setObject:self.SecurityCodeTXT.text  forKey:@"code"];
            
            
            [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,UpdateProfile_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
             {
                 [self handleSendSecurityCodeResponse:response];
             }];
        }
        else
            [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
        
    }
}
- (void)handleSendSecurityCodeResponse:(NSDictionary*)response
{
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        self.DisplayEmailLBL.text=self.EmailAddressTxt.text;
        [self.secondView setHidden:YES];
        [self.ThirdView setHidden:NO];
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
    
}

- (IBAction)ResendCodeBtn_action:(id)sender
{
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
        [dictParams setObject:r_p  forKey:@"r_p"];
        [dictParams setObject:forget_passwordServiceName  forKey:@"service"];
        [dictParams setObject:self.EmailAddressTxt.text  forKey:@"email"];
        
        [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,UpdateProfile_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
         {
             [self handleReSendCodeResponse:response];
         }];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
}
- (void)handleReSendCodeResponse:(NSDictionary*)response
{
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
         activation_code=[response valueForKey:@"activation_code"];
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:@"Security code resend to your email." delegate:nil];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
    
}
- (IBAction)ChangePwd_action:(id)sender
{
    [self.ChangeForgtTxt resignFirstResponder];
    [self.RetryPsswdTxt resignFirstResponder];
    if ([self.ChangeForgtTxt.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter new password." delegate:nil];
    }
    else if ([self.RetryPsswdTxt.text isEqualToString:@""])
    {
     [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Re-Type New Password." delegate:nil];
    }
    else if ([_ChangeForgtTxt.text isEqualToString:_RetryPsswdTxt.text]) {
        
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
        {
            NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
            [dictParams setObject:r_p  forKey:@"r_p"];
            [dictParams setObject:change_forget_passwordServiceName  forKey:@"service"];
            [dictParams setObject:self.EmailAddressTxt.text  forKey:@"email"];
            [dictParams setObject:self.ChangeForgtTxt.text  forKey:@"password"];
            
            
            [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,UpdateProfile_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
             {
                 [self handleChangePWDResponse:response];
             }];
        }
        else
            [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"New Password and Re-Type New Password are not the same!" delegate:nil];
    }
    
}
- (void)handleChangePWDResponse:(NSDictionary*)response
{
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        [self.FourthView setHidden:NO];
        [self.ThirdView setHidden:YES];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
    
}
- (IBAction)LoginBtn_action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (range.location == 0 && [string isEqualToString:@" "])
    {
        return NO;
    }
    if (textField==_ChangeForgtTxt || textField == _RetryPsswdTxt)
    {
        if (range.location == textField.text.length && [string isEqualToString:@" "])
        {
            // ignore replacement string and add your own
            textField.text = [textField.text stringByAppendingString:@""];
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return YES;
    
}
@end
