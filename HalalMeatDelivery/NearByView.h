//
//  NearByView.h
//  HalalMeatDelivery
//
//  Created by kaushik on 23/08/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HalalMeatDelivery.pch"

@interface NearByView : UIViewController<CCKFNavDrawerDelegate>
{
    NSString *PincodeSTR,*Cat_IDSTR,*R_disStr;
}
@property (strong, nonatomic) CCKFNavDrawer *rootNav;

@property (strong, nonatomic) NSString *PincodeSTR,*Cat_IDSTR,*R_disStr;

@property (strong, nonatomic) IBOutlet UITableView *TableView;

@property (strong, nonatomic) IBOutlet UIButton *Search_IMG;

- (IBAction)Search_Click:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *Searc_BTN;
@property (strong, nonatomic) IBOutlet UISearchBar *SearchBar;
@end
