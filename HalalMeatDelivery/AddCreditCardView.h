//
//  AddCreditCardView.h
//  MirchMasala
//
//  Created by Mango SW on 23/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExampleViewControllerDelegate;

@interface AddCreditCardView : UIViewController
{
    NSString *previousTextFieldContent;
    UITextRange *previousSelection;
    NSString *cyear;
    NSMutableArray *years;
    NSMutableArray *months;
    NSString *year;
    NSString *monthNo;
    NSMutableArray *CardTypeRegx;
    NSMutableArray *AddressArr;
    NSMutableArray *SelectedAddress;
}
@property (weak, nonatomic) IBOutlet UITextView *Billing_TXTVW;

@property (nonatomic, weak) id<ExampleViewControllerDelegate> delegate;
@property (nonatomic) NSDecimalNumber *amount;
@property (weak, nonatomic) IBOutlet UIButton *PayButton;
@property (weak, nonatomic) IBOutlet UITextField *CardNumber_TXT;
@property (weak, nonatomic) IBOutlet UITextField *ExpiryDate_TXT;
@property (weak, nonatomic) IBOutlet UITextField *CVC_TXT;
@property (weak, nonatomic) IBOutlet UILabel *lblCardType;
@property (weak, nonatomic) IBOutlet UIButton *cancel_Button;

@end
