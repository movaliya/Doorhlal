//
//  OrderHistoryView.m
//  HalalMeatDelivery
//
//  Created by kaushik on 28/08/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import "OrderHistoryView.h"
#import "OrderHistoryCell.h"
#import "OrderHistoryDetailView.h"
#import "UIImageView+WebCache.h"
#import "DateAlert.h"

@interface OrderHistoryView ()
{
    DateAlert *DateFiiterPOPUp;
}
@property (strong, nonatomic) UIButton *ClearPop;
@property (strong, nonatomic) UIButton *NoPop;
@property (strong, nonatomic) UIButton *YesPop;
@property (strong, nonatomic) UITextField *ToTextPop;
@property (strong, nonatomic) UITextField *FromTextPop;
@property AppDelegate *appDelegate;

@end

@implementation OrderHistoryView
@synthesize Table,ViewChkStr,Menu_BTN;
@synthesize ClearPop,NoPop,YesPop,ToTextPop,FromTextPop,Empty_LBL;


- (void)viewDidLoad
{
    [super viewDidLoad];
    //WhiteBackArrow.png
    //WhiteMenuIcon.png
    
    if ([ViewChkStr isEqualToString:@"BACK"])
    {
        [Menu_BTN setImage:[UIImage imageNamed:@"WhiteBackArrow"] forState:UIControlStateNormal];
    }
    else
    {
        [Menu_BTN setImage:[UIImage imageNamed:@"WhiteMenuIcon"] forState:UIControlStateNormal];
    }
    
    Empty_LBL.hidden=YES;
    self.appDelegate = [AppDelegate sharedInstance];
   
    UINib *nib = [UINib nibWithNibName:@"OrderHistoryCell" bundle:nil];
    OrderHistoryCell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    Table.rowHeight = cell.frame.size.height;
    [Table registerNib:nib forCellReuseIdentifier:@"OrderHistoryCell"];
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
         [self performSelector:@selector(GetOrderHistry) withObject:nil afterDelay:0.0];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
   

    DateFiiterPOPUp =[[[NSBundle mainBundle]loadNibNamed:@"DateAlert" owner:nil options:nil]firstObject];
    DateFiiterPOPUp.frame =self.view.frame;
    [self.view addSubview:DateFiiterPOPUp];
    DateFiiterPOPUp.hidden=YES;
    // Do any additional setup after loading the view.
}
-(void)GetOrderHistry
{
    NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
    NSString *User_UID=[UserData valueForKey:@"u_id"];
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:GetOrderHistryServiceName  forKey:@"service"];
    [dictParams setObject:User_UID  forKey:@"uid"];

    NSLog(@"get order Item Dic=%@",dictParams);
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,GetOrderHistryItem_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleOrderCardItemResponse:response];
     }];
}
- (void)handleOrderCardItemResponse:(NSDictionary*)response
{
    Table.hidden=NO;
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        OderHistryDic=[[response objectForKey:@"result"] mutableCopy];
        filterArray=[[response objectForKey:@"result"] mutableCopy];
        if (filterArray.count==0)
        {
            Empty_LBL.hidden=NO;
            Table.hidden=YES;
            Empty_LBL.text=[response objectForKey:@"ack_msg"];
        }
        else
        {
            for (int i=0; i<filterArray.count; i++)
            {
                NSString *dateStr=[[[filterArray valueForKey:@"orderdate"]objectAtIndex:i] substringToIndex:10];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd"];
                NSDate *Startdate = [dateFormat dateFromString:dateStr];
                NSString *startTimeStamp = [[NSNumber numberWithInt:floor([Startdate timeIntervalSince1970])] stringValue];
                
                [[filterArray objectAtIndex:i] setValue:startTimeStamp forKey:@"date"];
                [[OderHistryDic objectAtIndex:i] setValue:startTimeStamp forKey:@"date"];
            }
            
            ExchangeArray=[OderHistryDic mutableCopy];
            [Table reloadData];
        }
        
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - photoShotSavedDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection = %li", (long)selectionIndex);
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ExchangeArray.count;
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
    static NSString *CellIdentifier = @"OrderHistoryCell";
    OrderHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    }
    cell.Title_LBL.text=[[ExchangeArray valueForKey:@"restorant_name"] objectAtIndex:indexPath.section];

    //
    cell.Price_LBL.text=[NSString stringWithFormat:@"$%@",[[ExchangeArray valueForKey:@"subtotal"] objectAtIndex:indexPath.section]];
    cell.Date_LBL.text=[[ExchangeArray valueForKey:@"orderdate"] objectAtIndex:indexPath.section];
    cell.PaymentMethod_LBL.text=[[ExchangeArray valueForKey:@"payment_method"] objectAtIndex:indexPath.section];
    
    cell.cancelOrderBtn.tag=indexPath.section;
    
    NSString *odernumber=[NSString stringWithFormat:@"Order ID : %@",[[ExchangeArray valueForKey:@"cart_id"] objectAtIndex:indexPath.section]];
    NSString *orderSug=[[ExchangeArray valueForKey:@"orderstatusslug"] objectAtIndex:indexPath.section];
    if ([orderSug isEqualToString:@"2"])
    {
        cell.Order_LBL.text=[NSString stringWithFormat:@"Order ID : %@",[[ExchangeArray valueForKey:@"cart_id"] objectAtIndex:indexPath.section]];
    }
    else
    {
        [cell.cancelOrderBtn setHidden:YES];
        
        NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:odernumber];
        // making text property to strike text- NSStrikethroughStyleAttributeName
        [titleString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [titleString length])];
        // using text on label
        [cell.Order_LBL  setAttributedText:titleString];
    }
    [cell.cancelOrderBtn addTarget:self action:@selector(CancelOrder_Click:) forControlEvents:UIControlEventTouchUpInside];

    NSString *Urlstr=[[ExchangeArray valueForKey:@"r_image"] objectAtIndex:indexPath.section];
    Urlstr = [Urlstr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [cell.RestorntImage sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
    [cell.RestorntImage setShowActivityIndicatorView:YES];
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderHistoryDetailView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OrderHistoryDetailView"];
    
    vcr.card_id=[[ExchangeArray valueForKey:@"cart_id"] objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:vcr animated:YES];
}
-(void)CancelOrder_Click:(id)sender
{
    UIButton *instanceButton = (UIButton*)sender;
    NSLog(@"Tag=%ld",(long)instanceButton.tag);
    
    
    NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
    NSString *User_UID=[UserData valueForKey:@"u_id"];
    NSString *cart_id=[[ExchangeArray valueForKey:@"cart_id"] objectAtIndex:instanceButton.tag];
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:cancel_orderServiceName  forKey:@"service"];
    [dictParams setObject:User_UID  forKey:@"uid"];
    [dictParams setObject:cart_id  forKey:@"cid"];
    [dictParams setObject:User_UID  forKey:@"reason"];
    [dictParams setObject:@"reason to cancel order"  forKey:@"reason"];
    
    NSLog(@"cancelorder Dic=%@",dictParams);
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,cancel_order_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleCancelResponse:response];
     }];
}
- (void)handleCancelResponse:(NSDictionary*)response
{
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
        {
            [self performSelector:@selector(GetOrderHistry) withObject:nil afterDelay:0.0];
        }
        else
            [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
}
- (IBAction)Menu_Click:(id)sender
{
    if ([ViewChkStr isEqualToString:@"BACK"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.rootNav drawerToggle];
    }
    
    
}

- (IBAction)Filter_Click:(id)sender
{
    [DateFiiterPOPUp bringSubviewToFront:self.view];
    DateFiiterPOPUp.hidden=NO;
    
    [self TodateFill];
    [self FromdateFill];
    
    ClearPop= (UIButton *)[DateFiiterPOPUp viewWithTag:100];
    ClearPop.layer.cornerRadius=3.5;
    [ClearPop addTarget:self action:@selector(Clear_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    NoPop= (UIButton *)[DateFiiterPOPUp viewWithTag:101];
    NoPop.layer.cornerRadius=3.5;
    [NoPop addTarget:self action:@selector(Nobtn_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    YesPop= (UIButton *)[DateFiiterPOPUp viewWithTag:102];
    YesPop.layer.cornerRadius=3.5;
    [YesPop addTarget:self action:@selector(Yesbtn_Click:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)Clear_Click:(id)sender
{
    ToTextPop.text=@"";
    FromTextPop.text=@"";
    DateFiiterPOPUp.hidden=YES;
    ExchangeArray=[OderHistryDic mutableCopy];
    [Table reloadData];
}
-(void)Nobtn_Click:(id)sender
{
    DateFiiterPOPUp.hidden=YES;

}
-(void)Yesbtn_Click:(id)sender
{
    
    if([self.ToTextPop.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Alert..!" message:@"Please Select To Date." delegate:nil];
    }
    else if ([self.FromTextPop.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Alert..!" message:@"Please Select From Date." delegate:nil];
    }
    else
    {
       
        // NSString *dateStr = @"2016-09-20";
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd-MM-yyyy"];
        NSDate *Startdate = [dateFormat dateFromString:self.FromTextPop.text];
        
        // NSString *dateStr2 = @"2016-09-21";
        NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
        [dateFormat2 setDateFormat:@"dd-MM-yyyy"];
        NSDate *Enddate = [dateFormat2 dateFromString:self.ToTextPop.text];
        
        if ([[Enddate laterDate:Startdate] isEqualToDate:Enddate]) {
            NSLog(@"currentDate is later then previousDate");
             DateFiiterPOPUp.hidden=YES;
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit ) fromDate:[NSDate date]];
            //create a date with these components
            NSDate *startDate = [calendar dateFromComponents:components];
            [components setMonth:0];
            [components setDay:0]; //reset the other components
            [components setYear:0]; //reset the other components
            NSDate *endDate = [calendar dateByAddingComponents:components toDate:startDate options:0];
            
            startDate = [NSDate date];
            endDate = [startDate dateByAddingTimeInterval:-(7 * 24 * 60 * 60)];//change here
            
            NSString *startTimeStamp = [[NSNumber numberWithInt:floor([Startdate timeIntervalSince1970])] stringValue];
            NSString *endTimeStamp = [[NSNumber numberWithInt:floor([Enddate timeIntervalSince1970])] stringValue];
            
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"((date >= %@) AND (date <= %@))",startTimeStamp,endTimeStamp];
            NSLog(@"predicate is %@",predicate);
            NSArray *totalArr = [filterArray filteredArrayUsingPredicate:predicate];
            ExchangeArray = [totalArr mutableCopy];
            
            NSLog(@"NEW ARR==%@",totalArr);
            [Table reloadData];
        }
        else
        {
             [AppDelegate showErrorMessageWithTitle:@"Alert..!" message:@"From date is greater than To date" delegate:nil];
        }
    }
    
    
}
-(void)TodateFill
{
    
    ToTextPop= (UITextField *)[DateFiiterPOPUp viewWithTag:20];
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.backgroundColor=[UIColor whiteColor];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.barStyle   = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *itemDone  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:ToTextPop action:@selector(resignFirstResponder)];
    UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolbar.items = @[itemSpace,itemDone];
    
    ToTextPop.inputAccessoryView = toolbar;
    [ToTextPop setInputView:datePicker];
}

-(void)FromdateFill
{
    
    FromTextPop= (UITextField *)[DateFiiterPOPUp viewWithTag:21];
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.backgroundColor=[UIColor whiteColor];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateTextField1:) forControlEvents:UIControlEventValueChanged];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.barStyle   = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *itemDone  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:FromTextPop action:@selector(resignFirstResponder)];
    UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolbar.items = @[itemSpace,itemDone];
    
    FromTextPop.inputAccessoryView = toolbar;
    [FromTextPop setInputView:datePicker];
}

-(void) dateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)ToTextPop.inputView;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = picker.date;
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    ToTextPop.text = [NSString stringWithFormat:@"%@",dateString];
}
-(void) dateTextField1:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)FromTextPop.inputView;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = picker.date;
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    FromTextPop.text = [NSString stringWithFormat:@"%@",dateString];
}
@end
