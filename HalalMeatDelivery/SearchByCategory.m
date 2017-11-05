//
//  SearchByCategory.m
//  DoorToDoor
//
//  Created by Mango SW on 17/10/2017.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "SearchByCategory.h"

#import "HalalMeatDelivery.pch"
#import "SearchByCategoryCell.h"
#import "CategoryRestorant.h"



@interface SearchByCategory ()
{
    NSDictionary *DataDic;
    NSMutableArray *resultObjectsArray;
    NSMutableArray *SearchDictnory,*NewArr;
}
@property AppDelegate *appDelegate;

@end

@implementation SearchByCategory
@synthesize Table;
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = [AppDelegate sharedInstance];
    UINib *nib = [UINib nibWithNibName:@"SearchByCategoryCell" bundle:nil];
    SearchByCategoryCell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    Table.rowHeight = cell.frame.size.height;
    [Table registerNib:nib forCellReuseIdentifier:@"SearchByCategoryCell"];
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        [self CallForSearchByShop];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    }
  
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:NO];
    
}
-(void)CallForSearchByShop
{
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:get_categoryServiceName  forKey:@"service"];
    NSLog(@"dictParams search by Shop===%@",dictParams);
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,SerachByCategory_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleCategoryResponse:response];
     }];
}

- (void)handleCategoryResponse:(NSDictionary*)response
{
    NSLog(@"response ===%@",response);
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
            SearchDictnory=[[NSMutableArray alloc]init];
            NewArr=[[NSMutableArray alloc]init];
            DataDic=[response valueForKey:@"result"];
            for (NSDictionary *dic in DataDic)
            {
                [SearchDictnory addObject:dic];
            }
            [Table reloadData];
    }
}

#pragma mark - photoShotSavedDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection = %li", (long)selectionIndex);
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1; // in your case, there are 3 cells
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return SearchDictnory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"SearchByCategoryCell";
    SearchByCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    }
    
    NSString *Urlstr=[[SearchDictnory valueForKey:@"image_path"] objectAtIndex:indexPath.row];
    Urlstr = [Urlstr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [cell.RestIMG sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
    [cell.RestIMG setShowActivityIndicatorView:YES];
    
    
    cell.RestName_LBL.text=[[SearchDictnory valueForKey:@"name"] objectAtIndex:indexPath.row];
   // NSString *distanceMile=[[SearchDictnory valueForKey:@"distance"] objectAtIndex:indexPath.row];
   // int tempMile=[distanceMile integerValue];
    
   // cell.Distance_LBL.text=[NSString stringWithFormat:@" %d M ",tempMile] ;
    
   // cell.Address_LBL.text=[NSString stringWithFormat:@" %@ ",[[SearchDictnory valueForKey:@"address"] objectAtIndex:indexPath.row]] ;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CategoryRestorant *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CategoryRestorant"];
    vcr.C_ID=[[SearchDictnory valueForKey:@"id"]objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vcr animated:YES];
}

- (IBAction)Menu_Click:(id)sender
{
    [self.rootNav drawerToggle];
}
@end
