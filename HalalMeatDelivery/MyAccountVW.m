//
//  MyAccountVW.m
//  HalalMeatDelivery
//
//  Created by Mango SW on 29/04/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "MyAccountVW.h"
#import "ProfileView.h"
#import "OrderHistoryView.h"
#import "SavePaymentMethod.h"
#import "AppDelegate.h"
#import "HalalMeatDelivery.pch"
#import "AddressListView.h"
#import "ReedemPointVW.h"

@interface MyAccountVW ()

@property AppDelegate *appDelegate;

@end

@implementation MyAccountVW
@synthesize KLoginView,KLogOutView;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:YES];
    
    self.appDelegate = [AppDelegate sharedInstance];
    if ([self.appDelegate isUserLoggedIn] == NO)
    {
        KLoginView.hidden=NO;
        KLogOutView.hidden =YES;
    }
    else
    {
        KLoginView.hidden=YES;
        KLogOutView.hidden =NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)MyDetailsBtn_Action:(id)sender
{
    ProfileView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProfileView"];
    [self.navigationController pushViewController:vcr animated:YES];
}

- (IBAction)MyOrderBtn_Action:(id)sender
{
    OrderHistoryView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OrderHistoryView"];
    vcr.ViewChkStr=@"BACK";
    [self.navigationController pushViewController:vcr animated:YES];
}
- (IBAction)RedeemPoint_Click:(id)sender
{
    ProfileView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ReedemPointVW"];
    [self.navigationController pushViewController:vcr animated:YES];
}

- (IBAction)PaymentMethodBtn_action:(id)sender
{
    SavePaymentMethod *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SavePaymentMethod"];
    [self.navigationController pushViewController:vcr animated:YES];
    
}
- (IBAction)DeliveryAddressBtn_action:(id)sender
{
    AddressListView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddressListView"];
    [self.navigationController pushViewController:vcr animated:YES];
}

- (IBAction)LogoutBtn_action:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Are you sure want to Logout?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Logout",nil];
    alert.tag=55;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // the user clicked Logout
    if (alertView.tag==55)
    {
        if (buttonIndex == 1)
        {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"LoginUserDic"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Email"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Password"];
           // [[FBSession activeSession] closeAndClearTokenInformation];
            
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
    }
}
- (IBAction)LoginBtn_action:(id)sender
{
    LoginView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginView"];
    [self.navigationController  pushViewController:vcr animated:YES];
}
- (IBAction)RateApp_Btn_Click:(id)sender
{
    //https://itunes.apple.com/us/app/feed-me-meat/id1234871251?ls=1&mt=8
    
    NSString * appId = @"1234871251";
    NSString * theUrl = [NSString  stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software",appId];
    if ([[UIDevice currentDevice].systemVersion integerValue] > 6) theUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:theUrl]];
}
- (IBAction)Help_Btn_Click:(id)sender {
}

- (IBAction)MenuBtn_action:(id)sender
{
    [self.rootNav drawerToggle];
}

#pragma mark - photoShotSavedDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection = %li", (long)selectionIndex);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
