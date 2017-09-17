//
//  AlertView.h
//  ParentBlockedParent
//
//  Created by DK on 21/03/16.
//  Copyright © 2016 Kaushik Movaliya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertView : UIView
{
    
}
@property (strong, nonatomic) IBOutlet UIView *FistView;
@property (strong, nonatomic) IBOutlet UILabel *Title_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Desc_LBL;

@property (strong, nonatomic) IBOutlet UIButton *TakeAway_BTN;
@property (strong, nonatomic) IBOutlet UIButton *Delivery_BTN;
@property (strong, nonatomic) IBOutlet UIButton *Cancel_BTN;
@property (strong, nonatomic) IBOutlet UIButton *Proceed_BTN;
@property (weak, nonatomic) IBOutlet UIView *ThirdView;
@property (weak, nonatomic) IBOutlet UIButton *thirdViewTakeAway;
@property (weak, nonatomic) IBOutlet UIButton *secondViewTakeAwaybtn;
@property (weak, nonatomic) IBOutlet UIButton *secondViewDeliveryBtn;

@property (weak, nonatomic) IBOutlet UIView *SecondView;
@end
