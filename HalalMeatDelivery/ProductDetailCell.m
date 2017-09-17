//
//  ProductDetailCell.m
//  HalalMeatDelivery
//
//  Created by kaushik on 27/08/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import "ProductDetailCell.h"

@implementation ProductDetailCell
@synthesize AddCart_BTN;

- (void)awakeFromNib
{
    [super awakeFromNib];
    AddCart_BTN.layer.cornerRadius=11;
    AddCart_BTN.layer.masksToBounds=YES;
    AddCart_BTN.layer.borderColor=[[UIColor colorWithRed:25.0f/255.0f green:123.0f/255.0f blue:48.0f/255.0f alpha:1.0] CGColor];
    AddCart_BTN.layer.borderWidth=1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
