//
//  PaymentAddressCell.h
//  DoorToDoor
//
//  Created by Mango SW on 20/09/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentAddressCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *Name_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Address_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Email_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Contact_LBL;

@property (strong, nonatomic) IBOutlet UIButton *Delete_BTN;
@property (strong, nonatomic) IBOutlet UIButton *Edit_BTN;
@property (strong, nonatomic) IBOutlet UIButton *DefailtBTN;

@end
