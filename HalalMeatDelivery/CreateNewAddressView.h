//
//  CreateNewAddressView.h
//  HalalMeatDelivery
//
//  Created by kaushik on 03/05/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateNewAddressView : UIViewController
{
    NSMutableDictionary *AddressDic;
    BOOL *CheckAddresscount;
}

@property (strong, nonatomic) NSMutableDictionary *AddressDic;
@property (nonatomic, assign) BOOL *CheckAddresscount;


- (IBAction)Back_Click:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *UserName_TXT;
@property (strong, nonatomic) IBOutlet UITextField *Email_TXT;
@property (strong, nonatomic) IBOutlet UITextField *Mobile_TXT;
@property (strong, nonatomic) IBOutlet UITextField *Post_TXT;
@property (strong, nonatomic) IBOutlet UITextField *Address_TXT;
@property (strong, nonatomic) IBOutlet UITextField *City_TXT;
@property (weak, nonatomic) IBOutlet UITextField *State_TXT;
@property (strong, nonatomic) IBOutlet UIButton *Submit_BTN;
- (IBAction)Submit_Click:(id)sender;
@end
