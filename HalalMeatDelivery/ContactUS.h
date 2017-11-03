//
//  ContactUS.h
//  DoorToDoor
//
//  Created by Mango SW on 03/11/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HalalMeatDelivery.pch"

@interface ContactUS : UIViewController<CCKFNavDrawerDelegate>
{
    
}
@property (strong, nonatomic) CCKFNavDrawer *rootNav;

@property (strong, nonatomic) IBOutlet UITextField *Name_TXT;
@property (strong, nonatomic) IBOutlet UITextField *Email_TXT;
@property (strong, nonatomic) IBOutlet UITextField *Phone_TXT;

@property (weak, nonatomic) IBOutlet UITextField *Message_TXT;


@property (strong, nonatomic) IBOutlet UIButton *Submit_BTN;
- (IBAction)SubmitBtn_Click:(id)sender;
@end
