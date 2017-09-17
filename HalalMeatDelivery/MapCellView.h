//
//  MapCellView.h
//  HalalMeatDelivery
//
//  Created by kaushik on 28/08/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapCellView : UIView
{
    
}
@property (strong, nonatomic) IBOutlet UIImageView *Rest_IMG;
@property (strong, nonatomic) IBOutlet UILabel *RestNAME_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Desc_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Item_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Review_LBL;

@property (weak, nonatomic) IBOutlet UIImageView *Star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;

-(void)ReviewCount:(NSString*)stars;
@property (strong, nonatomic) IBOutlet UIButton *Distance_BTN;

@end
