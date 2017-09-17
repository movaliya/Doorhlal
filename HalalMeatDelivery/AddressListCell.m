//
//  AddressListCell.m
//  HalalMeatDelivery
//
//  Created by kaushik on 03/05/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "AddressListCell.h"

@implementation AddressListCell
@synthesize Edit_BTN,Delete_BTN,DefailtBTN;

- (void)awakeFromNib
{
    [super awakeFromNib];
    Delete_BTN.layer.cornerRadius=5;
    Edit_BTN.layer.cornerRadius=5;
    DefailtBTN.layer.cornerRadius=5;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
