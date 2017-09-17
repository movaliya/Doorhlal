//
//  OrderHistoryCell.h
//  HalalMeatDelivery
//
//  Created by kaushik on 28/08/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderHistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *RestorntImage;



@property (strong, nonatomic) IBOutlet UILabel *Title_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Order_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Price_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Date_LBL;
@property (strong, nonatomic) IBOutlet UILabel *PaymentMethod_LBL;
@property (weak, nonatomic) IBOutlet UIButton *cancelOrderBtn;

@end
