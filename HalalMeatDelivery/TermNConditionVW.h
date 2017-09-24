//
//  TermNConditionVW.h
//  DoorToDoor
//
//  Created by Mango SW on 20/09/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HalalMeatDelivery.pch"

@interface TermNConditionVW : UIViewController<CCKFNavDrawerDelegate>
{
    
}
@property (strong, nonatomic) CCKFNavDrawer *rootNav;

@property (weak, nonatomic) IBOutlet UITextView *Term_TXTVW;
@property (weak, nonatomic) IBOutlet UIImageView *Term_ImageVW;
@property (weak, nonatomic) IBOutlet UILabel *Term_Subtitle;
@property (weak, nonatomic) IBOutlet UILabel *Term_title;

@end
