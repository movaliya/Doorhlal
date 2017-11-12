//
//  ReedemPointVW.m
//  DoorToDoor
//
//  Created by Mango SW on 11/11/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "ReedemPointVW.h"
#import "ReedemPntCell.h"
@interface ReedemPointVW ()
{
    NSUInteger reloadsCount;
}
@end

@implementation ReedemPointVW
@synthesize ReedTableView,TotalReedemPoint_LBL;


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    reloadsCount = 10;
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self GetRedeemPoint:reloadsCount];
    UINib *nib = [UINib nibWithNibName:@"ReedemPntCell" bundle:nil];
    ReedemPntCell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    cell.layer.shadowOffset = CGSizeMake(1, 0);
    cell.layer.shadowColor = [[UIColor blackColor] CGColor];
    cell.layer.shadowRadius = 5;
    cell.layer.shadowOpacity = .25;
    ReedTableView.rowHeight = cell.frame.size.height;
    [ReedTableView registerNib:nib forCellReuseIdentifier:@"ReedemPntCell"];
    
}

-(void)GetRedeemPoint :(NSInteger )Count
{
    NSLog(@"remove cell click");
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        
        //http://bulkbox.in/door2door/service/service_cart.php?r_p=1224&service=get_user_reedem_transactions&uid=1&ul=0&ll=10
        
        NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
        NSString *User_UID=[UserData valueForKey:@"u_id"];
        
        NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
        [dictParams setObject:r_p  forKey:@"r_p"];
        [dictParams setObject:GetRedeemPointWithLimit forKey:@"service"];
        [dictParams setObject:User_UID  forKey:@"uid"];
        [dictParams setObject:@"0"  forKey:@"ul"];
        [dictParams setObject:[NSString stringWithFormat:@"%ld",(long)Count]  forKey:@"ll"];
        
        
        [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,RemoveCardItem_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
         {
             [self handleRemoveCardItemResponse:response];
         }];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
}


- (void)handleRemoveCardItemResponse:(NSDictionary*)response
{
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        
    }
    else
    {
        
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
}

#pragma mark -
#pragma mark MNMBottomPullToRefreshManagerClient2

- (void)viewDidLayoutSubviews {
    [pullToRefreshManager relocatePullToRefreshView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [pullToRefreshManager tableViewScrolled];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [pullToRefreshManager tableViewReleased];
}

- (void)bottomPullToRefreshTriggered:(MNMBottomPullToRefreshManager22 *)manager
{
    [self performSelector:@selector(loadTable) withObject:nil afterDelay:1.0f];
}

- (void)loadTable
{
    [pullToRefreshManager tableViewReloadFinished];
    reloadsCount=reloadsCount+10;
    [self GetRedeemPoint:reloadsCount];
    [ReedTableView reloadData];
    
    [pullToRefreshManager tableViewReloadFinished];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 3.; // you can have your own choice, of course
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ReedemPntCell";
    ReedemPntCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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

@end
