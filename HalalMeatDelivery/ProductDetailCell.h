//
//  ProductDetailCell.h
//  HalalMeatDelivery
//
//  Created by kaushik on 27/08/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailCell : UITableViewCell
{
    
}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *TitleTriling;
@property (strong, nonatomic) IBOutlet UILabel *Title_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Price_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Cat_LBL;
@property (strong, nonatomic) IBOutlet UIImageView *item_IMG;


@property (strong, nonatomic) IBOutlet UIButton *AddCart_BTN;
@property (strong, nonatomic) IBOutlet UIButton *Plush_BTN;
@property (strong, nonatomic) IBOutlet UIButton *Minush_BTN;
@property (strong, nonatomic) IBOutlet UILabel *Qunt_LBL;

@property (strong, nonatomic) IBOutlet UIImageView *Close_IMG;
@property (strong, nonatomic) IBOutlet UIButton *Close_BTN;
@property (strong, nonatomic) IBOutlet UIButton *AddtoCart_BTN;

@property (strong, nonatomic) IBOutlet UIView *Update_View;
@property (strong, nonatomic) IBOutlet UIButton *Update_BTN;
@property (strong, nonatomic) IBOutlet UIButton *Cancel_BTN;

@property (strong, nonatomic) IBOutlet UIView *PlushView;
@property (weak, nonatomic) IBOutlet UILabel *JustQuantityLBL;
@property (weak, nonatomic) IBOutlet UIView *RestDetailPlusView;
@property (weak, nonatomic) IBOutlet UIButton *RestPlusBtn;
@property (weak, nonatomic) IBOutlet UIButton *RestMinuBTN;
@property (weak, nonatomic) IBOutlet UILabel *RestQuatityLBL;

@end
