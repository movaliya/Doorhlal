//
//  RestaurantHeaderView.h
//  HalalMeatDelivery
//
//  Created by kaushik on 28/08/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantHeaderView : UIView

@property (strong, nonatomic) IBOutlet UILabel *Dist_LBL;
@property (strong, nonatomic) IBOutlet UIScrollView *Tab_Scroll;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ScrollWidth;



@property (strong, nonatomic) IBOutlet UILabel *RestName_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Desc_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Review_LBL;
@property (strong, nonatomic) IBOutlet UIImageView *FirstStar;
@property (strong, nonatomic) IBOutlet UIImageView *SecStar;
@property (strong, nonatomic) IBOutlet UIImageView *ThardStar;
@property (strong, nonatomic) IBOutlet UIImageView *FortStar;
@property (strong, nonatomic) IBOutlet UIImageView *FifthStar;
@property (strong, nonatomic) IBOutlet UILabel *Cat_LBL;
@property (weak, nonatomic) IBOutlet UIButton *RateBtn;

-(void)ReviewCount:(NSString*)stars;

@end
