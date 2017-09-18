//
//  RestaurantHeaderView.m
//  HalalMeatDelivery
//
//  Created by kaushik on 28/08/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import "RestaurantHeaderView.h"

@implementation RestaurantHeaderView
@synthesize FirstStar,SecStar,ThardStar,FortStar,FifthStar;


@synthesize Dist_LBL;

- (void)awakeFromNib
{
    [super awakeFromNib];
    Dist_LBL.layer.cornerRadius=5;
    Dist_LBL.layer.masksToBounds=YES;
    Dist_LBL.layer.borderColor=[[UIColor whiteColor] CGColor];
    Dist_LBL.layer.borderWidth=1;
    
    // Initialization code
}

-(void)ReviewCount:(NSString*)stars
{
    NSLog(@"stars=%@",stars);
    
    if ([stars integerValue]<=5)
    {
        if ([stars integerValue]==0) {
            FirstStar.image=[UIImage imageNamed:@"DisableWhiteStar"];
            SecStar.image=[UIImage imageNamed:@"DisableWhiteStar"];
            ThardStar.image=[UIImage imageNamed:@"DisableWhiteStar"];
            FortStar.image=[UIImage imageNamed:@"DisableWhiteStar"];
            FifthStar.image=[UIImage imageNamed:@"DisableWhiteStar"];
        }
        if ([stars integerValue]==1) {
            FirstStar.image=[UIImage imageNamed:@"WhiteStat"];
            SecStar.image=[UIImage imageNamed:@"DisableWhiteStar"];
            ThardStar.image=[UIImage imageNamed:@"DisableWhiteStar"];
            FortStar.image=[UIImage imageNamed:@"DisableWhiteStar"];
            FifthStar.image=[UIImage imageNamed:@"DisableWhiteStar"];
        }
        if ([stars integerValue]==2) {
            FirstStar.image=[UIImage imageNamed:@"WhiteStat"];
            SecStar.image=[UIImage imageNamed:@"WhiteStat"];
            ThardStar.image=[UIImage imageNamed:@"DisableWhiteStar"];
            FortStar.image=[UIImage imageNamed:@"DisableWhiteStar"];
            FifthStar.image=[UIImage imageNamed:@"DisableWhiteStar"];
        }
        if ([stars integerValue]==3) {
            FirstStar.image=[UIImage imageNamed:@"WhiteStat"];
            SecStar.image=[UIImage imageNamed:@"WhiteStat"];
            ThardStar.image=[UIImage imageNamed:@"WhiteStat"];
            FortStar.image=[UIImage imageNamed:@"DisableWhiteStar"];
            FifthStar.image=[UIImage imageNamed:@"DisableWhiteStar"];
        }
        if ([stars integerValue]==4) {
            FirstStar.image=[UIImage imageNamed:@"WhiteStat"];
            SecStar.image=[UIImage imageNamed:@"WhiteStat"];
            ThardStar.image=[UIImage imageNamed:@"WhiteStat"];
            FortStar.image=[UIImage imageNamed:@"WhiteStat"];
            FifthStar.image=[UIImage imageNamed:@"WhiteStat"];
        }
        if ([stars integerValue]==5) {
            FirstStar.image=[UIImage imageNamed:@"WhiteStat"];
            SecStar.image=[UIImage imageNamed:@"WhiteStat"];
            ThardStar.image=[UIImage imageNamed:@"WhiteStat"];
            FortStar.image=[UIImage imageNamed:@"WhiteStat"];
            FifthStar.image=[UIImage imageNamed:@"WhiteStat"];
        }
    }
}
@end
