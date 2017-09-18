//
//  NewNearbyCell.h
//  HalalMeatDelivery
//
//  Created by kaushik on 17/09/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewNearbyCell : UITableViewCell
{
    
}
@property (strong, nonatomic) IBOutlet UIImageView *RestIMG;
@property (strong, nonatomic) IBOutlet UILabel *RestName_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Address_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Distance_LBL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BottonViewHeightAddr;

@end
