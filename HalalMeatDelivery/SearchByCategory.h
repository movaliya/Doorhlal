//
//  SearchByCategory.h
//  DoorToDoor
//
//  Created by Mango SW on 17/10/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HalalMeatDelivery.pch"

@interface SearchByCategory : UIViewController<CCKFNavDrawerDelegate>
{
    
}
@property (strong, nonatomic) CCKFNavDrawer *rootNav;

@property (strong, nonatomic) IBOutlet UITableView *Table;


- (IBAction)Menu_Click:(id)sender;

@end
