//
//  PaymentAddressCell.m
//  DoorToDoor
//
//  Created by Mango SW on 20/09/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "PaymentAddressCell.h"

@implementation PaymentAddressCell
@synthesize Edit_BTN,Delete_BTN,DefailtBTN;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    Delete_BTN.layer.cornerRadius=5;
    Edit_BTN.layer.cornerRadius=5;
    DefailtBTN.layer.cornerRadius=5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
