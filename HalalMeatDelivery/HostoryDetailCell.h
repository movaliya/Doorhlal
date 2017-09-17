//
//  HostoryDetailCell.h
//  HalalMeatDelivery
//
//  Created by kaushik on 28/08/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HostoryDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Quantity_LBL;
@property (weak, nonatomic) IBOutlet UILabel *Total_LBL;
@property (weak, nonatomic) IBOutlet UILabel *Cell_Product_Name_LBL;
@property (weak, nonatomic) IBOutlet UILabel *productName;

@end
