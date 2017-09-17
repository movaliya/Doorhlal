//
//  RateView.m
//  HalalMeatDelivery
//
//  Created by Mango Software Lab on 10/09/2016.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import "RateView.h"
#import "HalalMeatDelivery.pch"
#import "RetView.h"

@interface RateView ()
{
    
}
@property AppDelegate *appDelegate;

@end

@implementation RateView
@synthesize Rest_ID;

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = [AppDelegate sharedInstance];
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        [self GetReviewRestroant];

    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
    UIButton *AddReviewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [AddReviewButton addTarget:self
                        action:@selector(AddReview_Click:)
              forControlEvents:UIControlEventTouchUpInside];
    //[AddReviewButton setTitle:@"Show View" forState:UIControlStateNormal];
    [AddReviewButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [AddReviewButton setBackgroundImage:[UIImage imageNamed:@"AddReviewBtn.png"] forState:UIControlStateNormal];
    float ButtonWidth=60.0;
    float Buttonheight=60.0;
    float Y_Co = self.view.frame.size.height - (Buttonheight+20);
    float X_Co = self.view.frame.size.width - (ButtonWidth+20);
    [AddReviewButton setFrame:CGRectMake(X_Co,Y_Co, ButtonWidth,Buttonheight)];
    [self.view addSubview:AddReviewButton];
    
    
    PopAddReview =[[[NSBundle mainBundle]loadNibNamed:@"RetViewCell" owner:nil options:nil]firstObject];
    PopAddReview.frame =self.view.frame;
    [self.view addSubview:PopAddReview];
    PopAddReview.hidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)GetReviewRestroant
{
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:GetRestorantRateServiceName  forKey:@"service"];
    [dictParams setObject:Rest_ID  forKey:@"rid"];
   
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,Restorant_rate_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleReviewResponse:response];
     }];
}

- (void)handleReviewResponse:(NSDictionary*)response
{
    //NSLog(@"Logindata==%@",response);
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        ReviewDic=[response valueForKey:@"result"];
        self.Review_LBL.text=[NSString stringWithFormat:@"( Review %@ )",[ReviewDic valueForKey:@"count_reviews"]];
        [self ReviewCount:[ReviewDic valueForKey:@"rate"]];
        userReviewDic=[[ReviewDic valueForKey:@"reviews"] valueForKey:@"result"];
        if(userReviewDic.count>0)
        {
            [self.RateTableView reloadData];
        }
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
    
}
- (IBAction)Back_BtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return userReviewDic.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Ratevw";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [[userReviewDic valueForKey:@"username"] objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [[userReviewDic valueForKey:@"review"] objectAtIndex:indexPath.row];
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)ReviewCount:(NSString*)stars
{
    NSLog(@"stars=%@",stars);
    
    if ([stars integerValue]<=5)
    {
        if ([stars integerValue]==0) {
            self.Star1.image=[UIImage imageNamed:@"HalStar"];
            self.star2.image=[UIImage imageNamed:@"HalStar"];
            self.star3.image=[UIImage imageNamed:@"HalStar"];
            self.star4.image=[UIImage imageNamed:@"HalStar"];
            self.start5.image=[UIImage imageNamed:@"HalStar"];
        }
        if ([stars integerValue]==1) {
            self.Star1.image=[UIImage imageNamed:@"FullStar"];
            self.star2.image=[UIImage imageNamed:@"HalStar"];
            self.star3.image=[UIImage imageNamed:@"HalStar"];
            self.star4.image=[UIImage imageNamed:@"HalStar"];
            self.start5.image=[UIImage imageNamed:@"HalStar"];
        }
        if ([stars integerValue]==2) {
            self.Star1.image=[UIImage imageNamed:@"FullStar"];
            self.star2.image=[UIImage imageNamed:@"FullStar"];
            self.star3.image=[UIImage imageNamed:@"HalStar"];
            self.star4.image=[UIImage imageNamed:@"HalStar"];
            self.start5.image=[UIImage imageNamed:@"HalStar"];
        }
        if ([stars integerValue]==3) {
            self.Star1.image=[UIImage imageNamed:@"FullStar"];
            self.star2.image=[UIImage imageNamed:@"FullStar"];
            self.star3.image=[UIImage imageNamed:@"FullStar"];
            self.star4.image=[UIImage imageNamed:@"HalStar"];
            self.start5.image=[UIImage imageNamed:@"HalStar"];
        }
        if ([stars integerValue]==4) {
            self.Star1.image=[UIImage imageNamed:@"FullStar"];
            self.star2.image=[UIImage imageNamed:@"FullStar"];
            self.star3.image=[UIImage imageNamed:@"FullStar"];
            self.star4.image=[UIImage imageNamed:@"FullStar"];
            self.start5.image=[UIImage imageNamed:@"HalStar"];
        }
        if ([stars integerValue]==5) {
            self.Star1.image=[UIImage imageNamed:@"FullStar"];
            self.star2.image=[UIImage imageNamed:@"FullStar"];
            self.star3.image=[UIImage imageNamed:@"FullStar"];
            self.star4.image=[UIImage imageNamed:@"FullStar"];
            self.start5.image=[UIImage imageNamed:@"FullStar"];
        }
    }
    else
    {
        self.Star1.image=[UIImage imageNamed:@"HalStar"];
        self.star2.image=[UIImage imageNamed:@"HalStar"];
        self.star3.image=[UIImage imageNamed:@"HalStar"];
        self.star4.image=[UIImage imageNamed:@"HalStar"];
        self.start5.image=[UIImage imageNamed:@"HalStar"];
    }
}
-(void)AddReview_Click:(id)sender
{
    
    if ([self.appDelegate isUserLoggedIn] == NO)
    {
        [self performSelector:@selector(checkLoginAndPresentContainer) withObject:nil afterDelay:0.0];
    }
    else
    {
        [PopAddReview bringSubviewToFront:self.view];
        PopAddReview.hidden=NO;
        
        _POPReviewCancel= (UIButton *)[PopAddReview viewWithTag:40];
        [_POPReviewCancel addTarget:self action:@selector(POPCancel_Click:) forControlEvents:UIControlEventTouchUpInside];
        
        _POPReviewSubmit =(UIButton *)[PopAddReview viewWithTag:50];
        [_POPReviewSubmit addTarget:self action:@selector(POPSubmit_Click:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
}
#pragma mark - pop ;

-(void)POPCancel_Click:(id)sender
{
    
    PopAddReview.hidden=YES;
}

-(void)POPSubmit_Click:(id)sender
{
  
    
    if([PopAddReview.Review_TxtField.text isEqualToString:@""]|| [PopAddReview.Review_TxtField.text length]<10)
    {
        [AppDelegate showErrorMessageWithTitle:@"Alert" message:@"Please add review with atleast 10 characters" delegate:nil];
    }
    else
    {
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
        {
            NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
            NSString *User_UID=[UserData valueForKey:@"u_id"];
            NSString *rates=[self CountReview:PopAddReview.Rate_LBL.text];
            
            NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
            [dictParams setObject:r_p  forKey:@"r_p"];
            [dictParams setObject:GeAddRestorantRateReviewServiceName  forKey:@"service"];
            [dictParams setObject:Rest_ID  forKey:@"rid"];
            [dictParams setObject:User_UID  forKey:@"uid"];
            [dictParams setObject:rates  forKey:@"rate"];
            [dictParams setObject:PopAddReview.Review_TxtField.text  forKey:@"review"];
            
            NSLog(@"Rview=%@",dictParams);
            
            
            [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,Restorant_rate_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
             {
                 [self handleAddReviewResponse:response];
             }];
        }
        else
            [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
        
    }
}
- (void)handleAddReviewResponse:(NSDictionary*)response
{
    //NSLog(@"Logindata==%@",response);
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        PopAddReview.hidden=YES;
        [PopAddReview.Review_TxtField resignFirstResponder];
        PopAddReview.Review_TxtField.text=@"";
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
        [self GetReviewRestroant];
    }
    else
    {
        PopAddReview.hidden=YES;
        [PopAddReview.Review_TxtField resignFirstResponder];
        PopAddReview.Review_TxtField.text=@"";
        
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
    
}
-(void)checkLoginAndPresentContainer
{
    LoginView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginView"];
    [self.navigationController  pushViewController:vcr animated:YES];
}
-(NSString *)CountReview:(NSString *)rate
{
    NSString *ReviewRate;
    if([rate isEqualToString:@"Hate It"])
    {
        ReviewRate=@"1";
    }
    else if([rate isEqualToString:@"Disliked It"])
    {
        ReviewRate=@"2";
    }
    else if([rate isEqualToString:@"It's Ok"])
    {
        ReviewRate=@"3";
    }
    else if([rate isEqualToString:@"Liked It"])
    {
        ReviewRate=@"4";
    }
    else if([rate isEqualToString:@"Loved It"])
    {
        ReviewRate=@"5";
    }
    else
    {
        ReviewRate=@"1";
    }

    
    return ReviewRate;
}
@end
