//
//  ReedemPointVW.h
//  DoorToDoor
//
//  Created by Mango SW on 11/11/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HalalMeatDelivery.pch"
#import "MNMBottomPullToRefreshManager22.h"


@interface ReedemPointVW : UIViewController<CCKFNavDrawerDelegate,MNMBottomPullToRefreshManager22Client>
{
    MNMBottomPullToRefreshManager22 *pullToRefreshManager;

}
@property (weak, nonatomic) IBOutlet UILabel *TotalReedemPoint_LBL;
@property (weak, nonatomic) IBOutlet UITableView *ReedTableView;
@property (strong, nonatomic) CCKFNavDrawer *rootNav;

@end
