//
//  RetView.h
//  HalalMeatDelivery
//
//  Created by kaushik on 10/09/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RetView : UIView
@property (weak, nonatomic) IBOutlet UILabel *Rate_LBL;
@property (weak, nonatomic) IBOutlet UITextField *Review_TxtField;
@property (weak, nonatomic) IBOutlet UIButton *Cancel_btn;
@property (weak, nonatomic) IBOutlet UIButton *submit_btn;

@end
