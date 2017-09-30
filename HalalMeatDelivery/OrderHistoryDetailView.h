//
//  OrderHistoryDetailView.h
//  HalalMeatDelivery
//
//  Created by kaushik on 28/08/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HalalMeatDelivery.pch"
@interface OrderHistoryDetailView : UIViewController<CCKFNavDrawerDelegate>
{
    NSString *card_id;
    NSMutableDictionary *MainCardDictnory;
    NSMutableDictionary *product_detail;
    NSString *ResLat,*ResLog;


}
@property (strong, nonatomic) NSString *card_id;
@property (strong, nonatomic) IBOutlet UITableView *Table;
@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@property (strong, nonatomic) IBOutlet UIView *TopView;
@property (strong, nonatomic) IBOutlet UIView *BottomView;
@property (weak, nonatomic) IBOutlet UILabel *RestName_LBL;
@property (weak, nonatomic) IBOutlet UIImageView *Restorent_Image;
@property (weak, nonatomic) IBOutlet UILabel *date_LBL;
@property (weak, nonatomic) IBOutlet UILabel *Product_Name;
@property (weak, nonatomic) IBOutlet UILabel *Total_Quntity_LBl;
@property (weak, nonatomic) IBOutlet UILabel *SubTotal_LBL;
@property (weak, nonatomic) IBOutlet UILabel *upper_subtotal_LBL;
- (IBAction)MapIcon_Click:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *res_phoneLBL;
@property (weak, nonatomic) IBOutlet UILabel *Rest_timingLBL;
@property (weak, nonatomic) IBOutlet UILabel *Payment_MethodLBL;
@property (weak, nonatomic) IBOutlet UILabel *paymentMethodStatus_LBL;
@property (weak, nonatomic) IBOutlet UILabel *OrderStatusLBL;
@property (weak, nonatomic) IBOutlet UILabel *RestAddress;
@property (weak, nonatomic) IBOutlet UILabel *openNClosingHourLBL;
@property (weak, nonatomic) IBOutlet UILabel *DownOrderIDLBL;
@property (strong, nonatomic) IBOutlet UILabel *Comment_LBL;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *CommentViewHight;
@property (strong, nonatomic) IBOutlet UILabel *Line_LBL;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ScrollHight;
@end
