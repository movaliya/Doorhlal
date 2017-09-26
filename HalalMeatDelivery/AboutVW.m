//
//  AboutVW.m
//  DoorToDoor
//
//  Created by Mango SW on 20/09/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "AboutVW.h"
#import "HalalMeatDelivery.pch"
@interface AboutVW ()

@end

@implementation AboutVW
@synthesize About_Title,About_TXTVW,AboutImageVw,About_Subtitle;

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        [self CallForAboutService];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:YES];
    
}
#pragma mark - photoShotSavedDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection = %li", (long)selectionIndex);
    
}
-(void)CallForAboutService
{
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:AboutServiceName  forKey:@"service"];
   
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,service_general_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleAboutResponse:response];
     }];
    
}

- (void)handleAboutResponse:(NSDictionary*)response
{
    NSLog(@"response ===%@",response);
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        NSMutableDictionary *result=[[response objectForKey:@"result"] mutableCopy];
        
        NSString *Urlstr=[result valueForKey:@"image"];
        [AboutImageVw sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
        [AboutImageVw setShowActivityIndicatorView:YES];
        
       // About_Title.text=[result valueForKey:@"title"];
      //  About_Subtitle.text=[result valueForKey:@"subtitle"];
        About_TXTVW.text=[result valueForKey:@"description"];
        
        
    }
    else
    {
        
    }
}

- (IBAction)Toogle_BTN:(id)sender
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
