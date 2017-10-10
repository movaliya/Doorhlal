//
//  OrderHistoryView.h
//  HalalMeatDelivery
//
//  Created by kaushik on 28/08/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HalalMeatDelivery.pch"
@interface OrderHistoryView : UIViewController<CCKFNavDrawerDelegate>
{
    NSMutableArray *OderHistryDic;
    //NSDate *startDate,*endDate;
    NSString *ViewChkStr;
    NSMutableArray *filterArray,*ExchangeArray;
}
@property (strong, nonatomic) NSString *ViewChkStr;

@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@property (strong, nonatomic) IBOutlet UITableView *Table;
@property (strong, nonatomic) IBOutlet UILabel *Empty_LBL;
@property (strong, nonatomic) IBOutlet UIButton *Menu_BTN;

- (IBAction)Menu_Click:(id)sender;

- (IBAction)Filter_Click:(id)sender;
@end
