//
//  HomeView.m
//  HalalMeatDelivery
//
//  Created by kaushik on 24/08/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import "HomeView.h"

@interface HomeView ()
@property AppDelegate *appDelegate;
@end

@implementation HomeView
@synthesize Search_BTN,SearchByStore_BTN;
@synthesize LogoHight,LogoWidht,LogoLBL_Gap,Search_Gap,TopLogoGap;
@synthesize pincodeTxt;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.appDelegate = [AppDelegate sharedInstance];
        
    Search_BTN.layer.cornerRadius=20.0;
    Search_BTN.autoresizingMask=YES;
    
    SearchByStore_BTN.layer.cornerRadius=20.0;
    Search_BTN.autoresizingMask=YES;
    
    Search_BTN.autoresizingMask=YES;
    
//    PinView.layer.cornerRadius=20.0;
//    PinView.autoresizingMask=YES;
//    [PinCode_TXT setValue:[UIColor colorWithRed:246.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1.0f] forKeyPath:@"_placeholderLabel.textColor"];

}


-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self prefersStatusBarHidden];

    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:YES];
    
    if (SCREEN_HEIGHT==480)
    {
        LogoWidht.constant=170;
        LogoHight.constant=86;
        LogoLBL_Gap.constant=55;
        Search_Gap.constant=45;
        TopLogoGap.constant=40;
    }
    else
    {
        LogoWidht.constant=212;
        LogoHight.constant=114;
        LogoLBL_Gap.constant=72;
        Search_Gap.constant=60;
        TopLogoGap.constant=58;
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)Leftmenu_click:(id)sender
{
    [self.rootNav drawerToggle];
}

#pragma mark - photoShotSavedDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection = %li", (long)selectionIndex);
}

- (IBAction)SearchBySore_click:(id)sender
{
    MapNearbyPlace *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MapNearbyPlace"];
    [self.navigationController pushViewController:vcr animated:YES];
}

- (IBAction)SearchBtn_Action:(id)sender
{
    if ([pincodeTxt.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please Enter Zip Code" delegate:nil];
    }
    else
    {
        NearByView *vcr=[[NearByView alloc] init];
        vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NearByView"];
        vcr.PincodeSTR=pincodeTxt.text;
        [self.navigationController pushViewController:vcr animated:YES];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField * )textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [pincodeTxt resignFirstResponder];
    UITouch *touch =[touches anyObject];
    if (touch.phase ==UITouchPhaseBegan)
    {
       // [self.view endEditing:YES];
    }
}
@end
