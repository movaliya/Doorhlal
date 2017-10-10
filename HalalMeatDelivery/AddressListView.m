//
//  AddressListView.m
//  HalalMeatDelivery
//
//  Created by kaushik on 03/05/17.
//  Copyright © 2017 kaushik. All rights reserved.
//

#import "AddressListView.h"
#import "HalalMeatDelivery.pch"
#import "AddressListCell.h"
#import "CreateNewAddressView.h"


#define ButtonColor [UIColor colorWithRed:242.0/255.0 green:18.0/255.0 blue:43.0/255.0 alpha:1.0]
#define DefaultBTNColor [UIColor colorWithRed:25.0/255.0 green:123.0/255.0 blue:48.0/255.0 alpha:1.0]

@interface AddressListView ()
{
    NSMutableArray *AddressArr;
}
@end

@implementation AddressListView
@synthesize TBL;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"AddressListCell" bundle:nil];
    AddressListCell *cell2 = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    TBL.rowHeight = cell2.frame.size.height;
    [TBL registerNib:nib forCellReuseIdentifier:@"AddressListCell"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getAddressData];
    
}

-(void)getAddressData
{
    NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
    NSString *User_UID=[UserData valueForKey:@"u_id"];
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:GetDeleveryHistory  forKey:@"service"];
    [dictParams setObject:User_UID  forKey:@"uid"];
    
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,Filter_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleGetFilterResponse:response];
     }];
}

- (void)handleGetFilterResponse:(NSDictionary*)response
{
    NSLog(@"GetFilterResponse ===%@",response);
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        AddressArr=[[response valueForKey:@"result"] mutableCopy];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:nil message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
    [TBL reloadData];

}

-(void)DeleteAddress :(NSString *)DeliveryAddress_idStr
{
    //http://bulkbox.in/feedmemeat/service/service_general.php?r_p=1224&service=delete_delivery_address&uid=4&delivery_address_id=21 
    
    NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
    NSString *User_UID=[UserData valueForKey:@"u_id"];
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:DeleteDeliveryAddress  forKey:@"service"];
    [dictParams setObject:User_UID  forKey:@"uid"];
    [dictParams setObject:DeliveryAddress_idStr  forKey:@"delivery_address_id"];
    
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,Filter_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleDeleteAddress:response];
     }];
}

- (void)handleDeleteAddress:(NSDictionary*)response
{
    NSLog(@"GetFilterResponse ===%@",response);
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        [AppDelegate showErrorMessageWithTitle:nil message:[response objectForKey:@"result"] delegate:nil];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:nil message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
    [self getAddressData];
}

-(void)SetDefaultAddress :(NSString *)DeliveryAddress_idStr
{
   
    
    NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
    NSString *User_UID=[UserData valueForKey:@"u_id"];
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:SetDefautAddress  forKey:@"service"];
    [dictParams setObject:User_UID  forKey:@"uid"];
    [dictParams setObject:DeliveryAddress_idStr  forKey:@"delivery_address_id"];
    
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,Filter_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleSetDefaultAddress:response];
     }];
}

- (void)handleSetDefaultAddress:(NSDictionary*)response
{
    NSLog(@"GetFilterResponse ===%@",response);
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        [AppDelegate showErrorMessageWithTitle:nil message:[response objectForKey:@"result"] delegate:nil];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:nil message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
    [self getAddressData];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)Back_Click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8.0f; // you can have your own choice, of course
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return AddressArr.count; // in your case, there are 3 cells
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AddressListCell";
    AddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    }
    
    if ([[[AddressArr objectAtIndex:indexPath.section]valueForKey:@"isDefault"] isEqualToString:@"1"])
    {
        cell.DefailtBTN.backgroundColor=DefaultBTNColor;
    }
    else
    {
        cell.DefailtBTN.backgroundColor=ButtonColor;
    }
    
    cell.Name_LBL.text=[NSString stringWithFormat:@"Name : %@",[[AddressArr objectAtIndex:indexPath.section]valueForKey:@"name"]];
    cell.Address_LBL.text=[NSString stringWithFormat:@"Address : %@",[[AddressArr objectAtIndex:indexPath.section]valueForKey:@"address"]];
    cell.Email_LBL.text=[NSString stringWithFormat:@"Email : %@",[[AddressArr objectAtIndex:indexPath.section]valueForKey:@"email"]];
    cell.Contact_LBL.text=[NSString stringWithFormat:@"Mobile no : %@",[[AddressArr objectAtIndex:indexPath.section]valueForKey:@"contact_number"]];
    
    
    cell.Delete_BTN.tag=indexPath.section;
    cell.Edit_BTN.tag=indexPath.section;
    cell.DefailtBTN.tag=indexPath.section;
    
    [cell.Delete_BTN addTarget:self action:@selector(DeleteBTN_Click:) forControlEvents:UIControlEventTouchUpInside];
    [cell.Edit_BTN addTarget:self action:@selector(EditBTN_Click:) forControlEvents:UIControlEventTouchUpInside];
    [cell.DefailtBTN addTarget:self action:@selector(DefaultBTN_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(void)DeleteBTN_Click:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    [self DeleteAddress:[[AddressArr objectAtIndex:btn.tag] valueForKey:@"id"]];
}

-(void)EditBTN_Click:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    
    CreateNewAddressView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CreateNewAddressView"];
    if (AddressArr.count>0)
    {
        vcr.CheckAddresscount=YES;
    }
    else
    {
        vcr.CheckAddresscount=NO;
    }
    vcr.AddressDic=[AddressArr objectAtIndex:btn.tag];
    [self.navigationController pushViewController:vcr animated:YES];
}

-(void)DefaultBTN_Click:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    NSLog(@"TAG==%ld",(long)btn.tag);
    
    [self SetDefaultAddress:[[AddressArr objectAtIndex:btn.tag] valueForKey:@"id"]];
}

- (IBAction)Plush_Click:(id)sender
{
    CreateNewAddressView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CreateNewAddressView"];
    if (AddressArr.count>0)
    {
        vcr.CheckAddresscount=YES;
    }
    else
    {
        vcr.CheckAddresscount=NO;
    }
    [self.navigationController pushViewController:vcr animated:YES];
}

@end
