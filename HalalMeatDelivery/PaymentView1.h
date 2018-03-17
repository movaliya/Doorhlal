//
//  PaymentView1.h
//  HalalMeatDelivery
//
//  Created by kaushik on 02/05/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HalalMeatDelivery.pch"

@interface PaymentView1 : UIViewController
{
    NSMutableArray *AddressArr;
    NSMutableArray *SelectedAddress;
}
@property (strong, nonatomic) NSString *C_ID;
@property (strong, nonatomic) NSString *PassDateNTime;
@property (weak, nonatomic) IBOutlet UIView *AddressTBLView;
@property (weak, nonatomic) IBOutlet UITableView *TBL;

@property (weak, nonatomic) IBOutlet UITextField *UserName_txt;
@property (weak, nonatomic) IBOutlet UITextField *UserEmail_txt;
@property (weak, nonatomic) IBOutlet UITextField *UserPhoneNo_txt;
@property (weak, nonatomic) IBOutlet UITextField *UserPincode_txt;
@property (weak, nonatomic) IBOutlet UITextField *UserAddress_txt;
@property (weak, nonatomic) IBOutlet UITextField *UserCity_txt;
@property (weak, nonatomic) IBOutlet UITextField *country_TXT;
@property (weak, nonatomic) IBOutlet UITextField *street_TXT;
@property (weak, nonatomic) IBOutlet UIButton *NextBTN;
@property (weak, nonatomic) IBOutlet UITextField *state_TXT;
@property (weak, nonatomic) IBOutlet UITextField *houseno_TXT;

@end
