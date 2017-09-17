//
//  AddressListCell.h
//  HalalMeatDelivery
//
//  Created by kaushik on 03/05/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressListCell : UITableViewCell
{
    
}
@property (strong, nonatomic) IBOutlet UILabel *Name_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Address_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Email_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Contact_LBL;

@property (strong, nonatomic) IBOutlet UIButton *Delete_BTN;
@property (strong, nonatomic) IBOutlet UIButton *Edit_BTN;
@property (strong, nonatomic) IBOutlet UIButton *DefailtBTN;
@end
