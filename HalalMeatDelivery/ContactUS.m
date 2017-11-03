//
//  ContactUS.m
//  DoorToDoor
//
//  Created by Mango SW on 03/11/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "ContactUS.h"
#import "AppDelegate.h"
#import "HalalMeatDelivery.pch"

@interface ContactUS ()
@property AppDelegate *appDelegate;

@end

@implementation ContactUS
@synthesize Name_TXT,Email_TXT,Phone_TXT,Message_TXT;
@synthesize Submit_BTN;
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self prefersStatusBarHidden];
    
    [KmyappDelegate SetimageinTextfield:Name_TXT :@"IconUser"];
    [KmyappDelegate SetimageinTextfield:Email_TXT :@"IconEmail"];
    [KmyappDelegate SetimageinTextfield:Message_TXT :@"messageIcon"];
    [KmyappDelegate SetimageinTextfield:Phone_TXT :@"IconPhone"];
    
    [KmyappDelegate SetbuttonCorner:Submit_BTN];
    
    // Initialize the appDelegate property.
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // Do any additional setup after loading the view.
}
- (IBAction)SubmitBtn_Click:(id)sender
{

}
- (IBAction)MenuBtn_Click:(id)sender
{
    [self.rootNav drawerToggle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
