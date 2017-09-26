//
//  AddCreditCardView.m
//  MirchMasala
//
//  Created by Mango SW on 23/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <Stripe/Stripe.h>
#import "AddCreditCardView.h"
#import "DeliveryView3.h"

/**
 This example demonstrates creating a payment with a credit/debit card. It creates a token
 using card information collected with STPPaymentCardTextField, and then sends the token
 to our example backend to create the charge request.
 */
@interface AddCreditCardView () <STPPaymentCardTextFieldDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    STPCardParams *CardParam;
}
@property (weak, nonatomic) STPPaymentCardTextField *paymentTextField;
@property (weak, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation AddCreditCardView
@synthesize PayButton;
@synthesize CardNumber_TXT,ExpiryDate_TXT,CVC_TXT,lblCardType;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    PayButton.enabled=YES;
    NSString *titleamount = [NSString stringWithFormat:@"Pay $%@", self.amount];
    [PayButton setTitle:titleamount forState:UIControlStateNormal];
    
   // PayButton.backgroundColor=[UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0];
    [PayButton.layer setCornerRadius:20.0f];
    [PayButton.layer setMasksToBounds:YES];
    
    [self.cancel_Button.layer setCornerRadius:20.0f];
    [self.cancel_Button.layer setMasksToBounds:YES];
    
    // TextField Set
    CardTypeRegx = [[NSMutableArray alloc]initWithObjects:@"^4[0-9]$" , @"^5[1-5]" , @"^3[47]" , nil];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    
    cyear = [formatter stringFromDate:[NSDate date]];
    
    years = [[NSMutableArray alloc] init];
    int toyear = [cyear intValue] + 20;
    for (int i=[cyear intValue]; i<=toyear; i++)
    {
        [years addObject:[NSString stringWithFormat:@"%d",i]];
    }
    months=[[NSMutableArray alloc]initWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",nil];
    AddressArr=[[NSMutableArray alloc]init];
    SelectedAddress=[[NSMutableArray alloc]init];
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        //[self getAddressData];
        [self performSelector:@selector(getAddressData) withObject:self afterDelay:1.0 ];
        
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
    
    
}
-(void)getAddressData
{
    NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
    NSString *User_UID=[UserData valueForKey:@"u_id"];
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:GetDeleveryHistory  forKey:@"service"];
    [dictParams setObject:User_UID  forKey:@"uid"];
    
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,Filter_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleGetAddressResponse:response];
     }];
}

- (void)handleGetAddressResponse:(NSDictionary*)response
{
    
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        AddressArr=[[response valueForKey:@"result"] mutableCopy];
        for (int tt=0; tt<AddressArr.count; tt++)
        {
            if ([[[AddressArr objectAtIndex:tt]valueForKey:@"isDefault"] isEqualToString:@"1"])
            {
                SelectedAddress=[AddressArr objectAtIndex:tt];
                break;
            }
        }
        if (SelectedAddress.count==0)
        {
            for (int tt=0; tt<AddressArr.count; tt++)
            {
                SelectedAddress=[AddressArr objectAtIndex:tt];
            }
            
            self.Billing_TXTVW.text=[NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@",[SelectedAddress valueForKey:@"name"],[SelectedAddress valueForKey:@"address"],[SelectedAddress valueForKey:@"pincode"], [SelectedAddress valueForKey:@"contact_number"], [SelectedAddress valueForKey:@"email"]];
        }
        else
        {
            
            self.Billing_TXTVW.text=[NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@",[SelectedAddress valueForKey:@"name"],[SelectedAddress valueForKey:@"address"],[SelectedAddress valueForKey:@"pincode"], [SelectedAddress valueForKey:@"contact_number"], [SelectedAddress valueForKey:@"email"]];
            
        }
    }
    else
    {
        NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
        
        if ([UserData count] != 0)
        {
            self.Billing_TXTVW.text=[NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@",[UserData valueForKey:@"u_name"],[UserData valueForKey:@"u_address"],[UserData valueForKey:@"u_pincode"], [UserData valueForKey:@"u_phone"], [UserData valueForKey:@"u_address"]];
        }
    }
    
}
- (IBAction)PayBtn_action:(id)sender
{
    
    
    if ([CardNumber_TXT.text isEqualToString:@""])
    {
        //[self ShowPOPUP];
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Card Number" delegate:nil];
    }
    else  if ([ExpiryDate_TXT.text isEqualToString:@""])
    {
        //[self ShowPOPUP];
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Expire Date" delegate:nil];
    }
    else  if ([ExpiryDate_TXT.text isEqualToString:@""])
    {
        //[self ShowPOPUP];
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter CVC number" delegate:nil];
    }
    else
    {
        NSString *cardNumber=[CardNumber_TXT.text stringByReplacingOccurrencesOfString:@"-"
                                                                            withString:@""];
        CardParam = [[STPCardParams alloc]init];
        CardParam.number = cardNumber;
        CardParam.cvc = CVC_TXT.text;
        CardParam.expMonth =[monthNo integerValue];
        CardParam.expYear = [year integerValue];
        
        
        if ([self validateCustomerInfo]) {
            PayButton.enabled=NO;
            PayButton.backgroundColor=[UIColor grayColor];
            [self performStripeOperation];
        }
    }
    
    
    /*
    
    if (![self.paymentTextField isValid]) {
        return;
    }*/
    
}
- (BOOL)validateCustomerInfo {
    
    [KVNProgress show] ;
    //2. Validate card number, CVC, expMonth, expYear
    [STPCardValidator validationStateForExpirationMonth:monthNo];
    [STPCardValidator validationStateForExpirationYear:year inMonth:monthNo];
    if ([lblCardType.text isEqualToString:@"VISA"]) {
        [STPCardValidator validationStateForCVC:CVC_TXT.text cardBrand:STPCardBrandVisa];
        [STPCardValidator validationStateForNumber:CardNumber_TXT.text validatingCardBrand:STPCardBrandVisa];
    }
    else if ([lblCardType.text isEqualToString:@"MasterCard"]){
        [STPCardValidator validationStateForCVC:CVC_TXT.text cardBrand:STPCardBrandMasterCard];
        [STPCardValidator validationStateForNumber:CardNumber_TXT.text validatingCardBrand:STPCardBrandMasterCard];
    }
    else if ([lblCardType.text isEqualToString:@"American Express"]){
        
        [STPCardValidator validationStateForCVC:CVC_TXT.text cardBrand:STPCardBrandAmex];
        [STPCardValidator validationStateForNumber:CardNumber_TXT.text validatingCardBrand:STPCardBrandAmex];
    }
    else if ([lblCardType.text isEqualToString:@"Maestro"]){
        [STPCardValidator validationStateForCVC:CVC_TXT.text cardBrand:STPCardBrandDiscover];
        [STPCardValidator validationStateForNumber:CardNumber_TXT.text validatingCardBrand:STPCardBrandDiscover];
    }
    else if ([lblCardType.text isEqualToString:@"Diners Club"]){
        [STPCardValidator validationStateForCVC:CVC_TXT.text cardBrand:STPCardBrandDinersClub];
        [STPCardValidator validationStateForNumber:CardNumber_TXT.text validatingCardBrand:STPCardBrandDinersClub];
    }
    else if ([lblCardType.text isEqualToString:@"JCB"]){
        [STPCardValidator validationStateForCVC:CVC_TXT.text cardBrand:STPCardBrandJCB];
        [STPCardValidator validationStateForNumber:CardNumber_TXT.text validatingCardBrand:STPCardBrandJCB];
    }
    else if ([lblCardType.text isEqualToString:@"Unknown"]){
        [STPCardValidator validationStateForCVC:CVC_TXT.text cardBrand:STPCardBrandUnknown];
        [STPCardValidator validationStateForNumber:CardNumber_TXT.text validatingCardBrand:STPCardBrandUnknown];
    }
    [KVNProgress dismiss];
    return YES;
}
- (void)storeDataWithCompletion:(void (^)(void))completion
{
    // Store Data Processing...
    if (completion) {
        [KmyappDelegate GetPublishableKey];
    }
}
- (void)performStripeOperation
{
    
    NSLog(@"defaultPublishableKey=%@",[Stripe defaultPublishableKey]);
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
    
    [KVNProgress show];
    
    [[STPAPIClient sharedClient] createTokenWithCard:CardParam
                                          completion:^(STPToken *token, NSError *error) {
                                              if (error) {
                                                    [KVNProgress dismiss];
                                                  [self.delegate exampleViewController:self didFinishWithError:error];
                                              }
                                              NSLog(@"token===%@",token.tokenId);
                                              [self.delegate createBackendChargeWithSource:token.tokenId completion:^(STPBackendChargeResult result, NSError *error) {
                                                  if (error) {
                                                       [KVNProgress dismiss];
                                                      [self.delegate exampleViewController:self didFinishWithError:error];
                                                      return;
                                                  }
                                                   [KVNProgress dismiss];
                                                  //[self.delegate exampleViewController:self didFinishWithMessage:@"Payment successfully created"];
                                              }];
                                          }];
     [KVNProgress dismiss];
    
    
    
}
#pragma mark - TextfildDelegate
- (NSArray *) toCharArray : (NSString *)string
{
    
    NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:string.length];
    for (int i=0; i < string.length; i++) {
        NSString *ichar  = [NSString stringWithFormat:@"%C", [string characterAtIndex:i]];
        [characters addObject:ichar];
    }
    
    return characters;
}

- (BOOL) luhnCheck:(NSString *)stringToTest
{
    
    NSArray *stringAsChars = [self toCharArray:stringToTest];
    
    BOOL isOdd = YES;
    int oddSum = 0;
    int evenSum = 0;
    
    //49927398716
    
    for (int i = stringToTest.length - 1; i >= 0; i--) {
        
        int digit = [(NSString *)stringAsChars[i] intValue];
        
        if (isOdd)
            oddSum += digit;
        else
            evenSum += digit/5 + (2*digit) % 10;
        
        isOdd = !isOdd;
    }
    
    return ((oddSum + evenSum) % 10 == 0);
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == ExpiryDate_TXT)
    {
        //UIPickerView *yourpicker = [[UIPickerView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 100, 150)];
        UIPickerView *yourpicker = [[UIPickerView alloc]initWithFrame:CGRectMake(ExpiryDate_TXT.frame.origin.x - 10, ExpiryDate_TXT.frame.size.height + 20, 100, 200)];
        [yourpicker setDataSource: self];
        [yourpicker setDelegate: self];
        yourpicker.showsSelectionIndicator = YES;
        
        ExpiryDate_TXT.inputView = yourpicker;
    }
}

-(NSString *)RemoveChar:(NSString *)string
{
    NSMutableCharacterSet *characterSet =
    [NSMutableCharacterSet characterSetWithCharactersInString:@"-"];
    
    // Build array of components using specified characters as separtors
    NSArray *arrayOfComponents = [string componentsSeparatedByCharactersInSet:characterSet];
    
    // Create string from the array components
    NSString *strOutput = [arrayOfComponents componentsJoinedByString:@""];
    
    return strOutput;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL test0;
   // NSString *cardString;
    if(textField == CardNumber_TXT)
    {
        if (range.length == 0 &&
            (range.location == 4 || range.location == 9 || range.location == 14))
        {
            textField.text = [NSString stringWithFormat:@"%@-%@", textField.text, string];
            return NO;
        }
        if (range.length == 1 &&
            (range.location == 5 || range.location == 10 || range.location == 15))
        {
            range.location--;
            textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
        }
        
        //NSLog(@"%@",[NSString stringWithFormat:@"%@%@",textField.text,string]);
        
        if(range.location > 18)
        {
            [ExpiryDate_TXT becomeFirstResponder];
            return NO;
        }
        //NSLog(@"%@",[NSString stringWithFormat:@"%@%@",textField.text,string]);
        if(range.location > 12)
        {
            const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding];
            int isBackSpace = strcmp(_char, "\b");
            
            if (isBackSpace == -8)
            {
                NSLog(@"Backspace was pressed");
                NSString *str = textField.text;
                NSString *truncatedString = [self RemoveChar:[str substringToIndex:[str length]-1]];
                test0 = [self luhnCheck:truncatedString];
            }
            else
            {
                NSString *truncatedString = [self RemoveChar:[NSString stringWithFormat:@"%@%@",textField.text,string]];
                test0 = [self luhnCheck:truncatedString];
            }
            
            
            if(test0)
            {
                CardNumber_TXT.textColor = [UIColor blackColor];
            }
            else
            {
                CardNumber_TXT.textColor = [UIColor redColor];
            }
        }
        else
        {
            CardNumber_TXT.textColor = [UIColor blackColor];
        }
        
        for(int i = 0; i < CardTypeRegx.count; i++)
        {
            if(range.location < 1)
            {
                lblCardType.text = @"";
            }
            
            NSPredicate *CardVISA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CardTypeRegx[i]];
            NSString *cardString = [self RemoveChar:[NSString stringWithFormat:@"%@%@",textField.text,string]];
            if ([CardVISA evaluateWithObject:cardString] == YES )
            {
                if(i == 0)
                {
                    lblCardType.text = @"VISA";
                }
                else if (i == 1)
                {
                    lblCardType.text = @"MasterCard";
                }
                else if (i == 2)
                {
                    lblCardType.text = @"American Express";
                }
                else if (i == 3)
                {
                    lblCardType.text = @"Maestro";
                }
                else
                {
                    lblCardType.text = @"";
                }
            }
        }
    }
    else if(textField == CVC_TXT)
    {
        if(range.location > 2)
        {
            return NO;
        }
    }
    else if (textField == ExpiryDate_TXT)
    {
        return NO;
    }
    return YES;
}

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView*)thePickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
    {
        return [months count];
    }
    else
    {
        return [years count];
    }
}
- (NSString *)pickerView:(UIPickerView *)thePickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0)
    {
        return [months objectAtIndex:row];
    }
    else
    {
        return [years objectAtIndex:row];
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component == 0)
    {
        monthNo = [months objectAtIndex:row];
    }
    else
    {
        year = [years objectAtIndex:row];
    }
    
    if(year == nil || monthNo == nil)
    {
        ExpiryDate_TXT.text = [NSString stringWithFormat:@"12/%@",cyear];
    }
    else
    {
        ExpiryDate_TXT.text = [NSString stringWithFormat:@"%@/%@",monthNo,year];
    }
    
}
- (IBAction)Cancel_Click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)BackBtn_Action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
