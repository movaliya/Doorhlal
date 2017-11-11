//
//  ReedemPntCell.m
//  DoorToDoor
//
//  Created by Mango SW on 11/11/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "ReedemPntCell.h"

@implementation ReedemPntCell
@synthesize BackView;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    BackView.layer.borderColor= [UIColor colorWithRed:223.0f/255.0f green:223.0f/255.0f blue:223.0f/255.0f alpha:1.0f].CGColor;
    BackView.layer.borderWidth=0.5;
    BackView.layer.cornerRadius=3;
    BackView.layer.masksToBounds = NO;
    BackView.layer.shadowOffset = CGSizeMake(0, 1);
    BackView.layer.shadowRadius = 0.2;
    BackView.layer.shadowColor = [UIColor colorWithRed:115.0f/255.0f green:115.0f/255.0f blue:115.0f/255.0f alpha:1.0f].CGColor;
    BackView.layer.shadowOpacity = 0.2;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
