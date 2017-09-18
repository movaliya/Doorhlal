//
//  NewNearbyCell.m
//  HalalMeatDelivery
//
//  Created by kaushik on 17/09/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "NewNearbyCell.h"

@implementation NewNearbyCell
@synthesize Distance_LBL;
- (void)awakeFromNib {
    [super awakeFromNib];
    
    Distance_LBL.layer.cornerRadius=5;
    Distance_LBL.layer.masksToBounds=YES;
    Distance_LBL.layer.borderColor=[[UIColor whiteColor] CGColor];
    Distance_LBL.layer.borderWidth=1;

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
