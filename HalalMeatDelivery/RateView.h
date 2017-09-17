//
//  RateView.h
//  HalalMeatDelivery
//
//  Created by Mango Software Lab on 10/09/2016.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RetView.h"

@interface RateView : UIViewController
{
    NSString *Rest_ID;
    NSMutableDictionary *ReviewDic,*userReviewDic;
    RetView *PopAddReview;

   
}
@property (weak, nonatomic) IBOutlet UITableView *RateTableView;
@property (strong, nonatomic) NSString *Rest_ID;

@property (weak, nonatomic) IBOutlet UILabel *Review_LBL;

@property (weak, nonatomic) IBOutlet UIImageView *Star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *start5;
@property (strong, nonatomic) UIButton *POPReviewSubmit;
@property (strong, nonatomic) UIButton *POPReviewCancel;
@end
