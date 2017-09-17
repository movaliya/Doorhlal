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
    NSMutableArray *filterArray,*ExchangeArray;
}
@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@property (strong, nonatomic) IBOutlet UITableView *Table;

- (IBAction)Menu_Click:(id)sender;

- (IBAction)Filter_Click:(id)sender;
@end
