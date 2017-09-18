//
//  MapCellView.m
//  HalalMeatDelivery
//
//  Created by kaushik on 28/08/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import "MapCellView.h"

@implementation MapCellView
@synthesize Distance_BTN;


- (void)awakeFromNib
{
    [super awakeFromNib];
    Distance_BTN.layer.cornerRadius=5;
    Distance_BTN.layer.masksToBounds=YES;
    Distance_BTN.layer.borderColor=[[UIColor colorWithRed:224.0f/255.0f green:66.0f/255.0f blue:66.0f/255.0f alpha:1.0] CGColor];
    Distance_BTN.layer.borderWidth=1;
    
    // Initialization code
}
-(void)ReviewCount:(NSString*)stars
{
    NSLog(@"stars=%@",stars);
    
    if ([stars integerValue]<=5)
    {
        if ([stars integerValue]==0) {
            self.Star1.image=[UIImage imageNamed:@"HalStar"];
            self.star2.image=[UIImage imageNamed:@"HalStar"];
            self.star3.image=[UIImage imageNamed:@"HalStar"];
            self.star4.image=[UIImage imageNamed:@"HalStar"];
            self.star5.image=[UIImage imageNamed:@"HalStar"];
        }
        if ([stars integerValue]==1) {
            self.Star1.image=[UIImage imageNamed:@"FullStar"];
            self.star2.image=[UIImage imageNamed:@"HalStar"];
            self.star3.image=[UIImage imageNamed:@"HalStar"];
            self.star4.image=[UIImage imageNamed:@"HalStar"];
            self.star5.image=[UIImage imageNamed:@"HalStar"];
        }
        if ([stars integerValue]==2) {
            self.Star1.image=[UIImage imageNamed:@"FullStar"];
            self.star2.image=[UIImage imageNamed:@"FullStar"];
            self.star3.image=[UIImage imageNamed:@"HalStar"];
            self.star4.image=[UIImage imageNamed:@"HalStar"];
            self.star5.image=[UIImage imageNamed:@"HalStar"];
        }
        if ([stars integerValue]==3) {
            self.Star1.image=[UIImage imageNamed:@"FullStar"];
            self.star2.image=[UIImage imageNamed:@"FullStar"];
            self.star3.image=[UIImage imageNamed:@"FullStar"];
            self.star4.image=[UIImage imageNamed:@"HalStar"];
            self.star5.image=[UIImage imageNamed:@"HalStar"];
        }
        if ([stars integerValue]==4) {
            self.Star1.image=[UIImage imageNamed:@"FullStar"];
            self.star2.image=[UIImage imageNamed:@"FullStar"];
            self.star3.image=[UIImage imageNamed:@"FullStar"];
            self.star4.image=[UIImage imageNamed:@"FullStar"];
            self.star5.image=[UIImage imageNamed:@"HalStar"];
        }
        if ([stars integerValue]==5) {
            self.Star1.image=[UIImage imageNamed:@"FullStar"];
            self.star2.image=[UIImage imageNamed:@"FullStar"];
            self.star3.image=[UIImage imageNamed:@"FullStar"];
            self.star4.image=[UIImage imageNamed:@"FullStar"];
            self.star5.image=[UIImage imageNamed:@"FullStar"];
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
