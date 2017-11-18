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
    //[KmyappDelegate SetimageinTextfield:Phone_TXT :@"IconPhone"];
    [KmyappDelegate SetimageinAndPrefixTextfield:Phone_TXT:@"IconPhone"];
    
    [KmyappDelegate SetbuttonCorner:Submit_BTN];
    
    // Initialize the appDelegate property.
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // Do any additional setup after loading the view.
}
- (IBAction)SubmitBtn_Click:(id)sender
{
    [Name_TXT resignFirstResponder];
    [Message_TXT resignFirstResponder];
    [Phone_TXT resignFirstResponder];
    [Email_TXT resignFirstResponder];
    
    if ([Name_TXT.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Name" delegate:nil];
    }
    else if ([Message_TXT.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Message" delegate:nil];
    }
    else if ([Phone_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Mobile Number" delegate:nil];
    }
    else if ([Email_TXT.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Email" delegate:nil];
    }
    else
    {
        if (![AppDelegate IsValidEmail:Email_TXT.text])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter valid email" delegate:nil];
        }
        else if (![AppDelegate myMobileNumberValidate:Phone_TXT.text])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please Enter a Valid Mobile number" delegate:nil];
        }
        
        else
        {
            
            BOOL internet=[AppDelegate connectedToNetwork];
            if (internet)
            {
                [self ContactUsServiceCall];
            }
            else
                [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
            
        }
    }
}
-(void)ContactUsServiceCall
{
    NSString *phoneStr=[NSString stringWithFormat:@"+1%@",Phone_TXT.text];
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:ContactUsServiceName  forKey:@"service"];
    
    [dictParams setObject:Email_TXT.text  forKey:@"email"];
    [dictParams setObject:Name_TXT.text  forKey:@"name"];
    [dictParams setObject:Message_TXT.text  forKey:@"msg"];
    [dictParams setObject:phoneStr  forKey:@"phone_no"];
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,ContactServc_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleResponse:response];
     }];
}

- (void)handleResponse:(NSDictionary*)response
{
    //NSLog(@"Logindata==%@",response);
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        Email_TXT.text=@"";
        Name_TXT.text=@"";
        Message_TXT.text=@"";
        Phone_TXT.text=@"";
        
       [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"result"] delegate:nil];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
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
