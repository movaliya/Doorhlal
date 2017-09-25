//
//  AboutVW.h
//  DoorToDoor
//
//  Created by Mango SW on 20/09/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HalalMeatDelivery.pch"

@interface AboutVW : UIViewController<CCKFNavDrawerDelegate>
{
    
}
@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@property (weak, nonatomic) IBOutlet UIImageView *AboutImageVw;

@property (weak, nonatomic) IBOutlet UITextView *About_TXTVW;
@property (weak, nonatomic) IBOutlet UILabel *About_Subtitle;
@property (weak, nonatomic) IBOutlet UILabel *About_Title;


@end
