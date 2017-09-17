//
//  CategoryCell.h
//  HalalMeatDelivery
//
//  Created by kaushik on 30/04/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CategoryCell : UITableViewCell
{
    
}
@property (strong, nonatomic) IBOutlet UIImageView *CatIMG;
@property (strong, nonatomic) IBOutlet UILabel *CatTitle_LBL;
@property (weak, nonatomic) IBOutlet UIView *StarView;
@property (weak, nonatomic) IBOutlet UIImageView *Start1;
@property (weak, nonatomic) IBOutlet UIImageView *Start2;
@property (weak, nonatomic) IBOutlet UIImageView *Start3;
@property (weak, nonatomic) IBOutlet UIImageView *Start4;
@property (weak, nonatomic) IBOutlet UIImageView *Start5;
@end
