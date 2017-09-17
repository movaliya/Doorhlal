//
//  RestaurantDetailView.h
//  HalalMeatDelivery
//
//  Created by kaushik on 25/08/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HalalMeatDelivery.pch"

@interface RestaurantDetailView : UIViewController<CCKFNavDrawerDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    NSMutableDictionary *RestraorntDic;
    NSString *R_ID,*Pin;
    NSString *ResLat,*ResLog;
    NSInteger ButtonTag;
    NSUInteger chechPlusMinus;
    NSString *QUANTITYCOUNT;

    
}
@property (weak, nonatomic) IBOutlet UILabel *QTYICON_LBL;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ScrollHight;
@property (strong, nonatomic) NSString *R_ID,*Pin;

@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@property (strong, nonatomic) NSMutableDictionary *RestraorntDic;

@property (strong, nonatomic) IBOutlet UIButton *Cart_BTN;
@property (strong, nonatomic) IBOutlet UIButton *Map_BTN;
@property (strong, nonatomic) IBOutlet UIScrollView *ImgScroll;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ImgScrollWidth;

@property (strong, nonatomic) IBOutlet UIScrollView *TabScroll;


@property (strong, nonatomic) IBOutlet UIScrollView *TableScroll;
@property (strong, nonatomic) IBOutlet UIScrollView *MainScroll;



- (IBAction)Back_Click:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *Back_BTN;



@property (strong, nonatomic) IBOutlet UIImageView *MapPlaceIMG;
@property (strong, nonatomic) IBOutlet UIImageView *CartIMG;
@property (strong, nonatomic) UIButton *RateViewBtn;

- (IBAction)Cart_Click:(id)sender;
- (IBAction)Map_Click:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *RestorantName_Lbl;
@property (weak, nonatomic) IBOutlet UILabel *RestorantAddress_Lbl;

@property (weak, nonatomic) IBOutlet UILabel *RestroantProName_Lbl;
@property (weak, nonatomic) IBOutlet UILabel *ReviewCount_LBL;
@property (weak, nonatomic) IBOutlet UILabel *RestDistance_LBL;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;


@end
