//
//  ShoppingCartView.m
//  HalalMeatDelivery
//
//  Created by kaushik on 28/08/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import "ShoppingCartView.h"
#import "ProductDetailCell.h"
#import "UIImageView+WebCache.h"
#import "PaymentView.h"

//New Implement file
#import "PaymentView1.h"
#import "DeliveryView1.h"

@interface ShoppingCartView ()

@property AppDelegate *appDelegate;
@property (strong, nonatomic) IBOutlet UITableView *TableView;
@property (strong, nonatomic) NSMutableDictionary *dic,*MainDic;
@property (strong, nonatomic) NSMutableArray *arr,*MainCount;
@end

@implementation ShoppingCartView
@synthesize TableView,dic,arr,MainDic,MainCount;
@synthesize SelectDate_TXT,upperDateGBLBL,upperView;
@synthesize RestruntNameView,EmptyCartView,BottomView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = [AppDelegate sharedInstance];
    EmptyCartView.hidden=YES;
        
    UINib *nib = [UINib nibWithNibName:@"ProductDetailCell" bundle:nil];
    ProductDetailCell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    TableView.rowHeight = cell.frame.size.height;
    [TableView registerNib:nib forCellReuseIdentifier:@"ProductDetailCell"];
    
    POPView =[[[NSBundle mainBundle]loadNibNamed:@"AlertView" owner:nil options:nil]firstObject];
    POPView.frame =self.view.frame;
    [self.view addSubview:POPView];
    POPView.hidden=YES;
    
    [self setPickerToTXT];
    upperDateGBLBL.layer.cornerRadius=5;
    upperDateGBLBL.layer.masksToBounds=YES;
    upperDateGBLBL.layer.borderColor=[[UIColor colorWithRed:226.0f/255.0f green:226.0f/255.0f blue:226.0f/255.0f alpha:1.0] CGColor];
    upperDateGBLBL.layer.borderWidth=1;
    
    upperView.layer.cornerRadius=5;
    upperView.layer.masksToBounds=YES;
    upperView.layer.borderColor=[[UIColor colorWithRed:226.0f/255.0f green:226.0f/255.0f blue:226.0f/255.0f alpha:1.0] CGColor];
    upperView.layer.borderWidth=1;

    RestruntNameView.hidden=YES;
    [upperView setHidden:YES];
    [_RestorantImage setHidden:YES];
    [_RestNameLBL setHidden:YES];
    [_RestAddressLBL setHidden:YES];
    [_RestDeleveryLBL setHidden:YES];
    [_JustDeleveyLBL setHidden:YES];
    [_justCellRestImge setHidden:YES];

    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        [self performSelector:@selector(GetCardDetail) withObject:nil afterDelay:0.1];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
}
-(void)setPickerToTXT
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy hh:mm a"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    SelectDate_TXT.text = dateString;
    
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"hh:mm a"];
    
    theDate = [dateFormat stringFromDate:[NSDate date]];
    theTime = [timeFormat stringFromDate:[NSDate date]];
    
    
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:GregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:1];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [comps setYear:-100];
    [datePicker setMaximumDate:maxDate];
    datePicker.backgroundColor=[UIColor whiteColor];
    
    [datePicker setMinimumDate:[NSDate date]];
    
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.barStyle   = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *itemDone  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:SelectDate_TXT action:@selector(resignFirstResponder)];
    UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolbar.items = @[itemSpace,itemDone];
    
    SelectDate_TXT.inputAccessoryView = toolbar;
    [SelectDate_TXT setInputView:datePicker];
}
-(void) dateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)SelectDate_TXT.inputView;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = picker.date;
    [dateFormat setDateFormat:@"dd-MM-yyyy hh:mm a"];
    
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    
    [dateFormat1 setDateFormat:@"dd-MM-yyyy"];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"hh:mm a"];
    
    theDate = [dateFormat1 stringFromDate:eventDate];
    theTime = [timeFormat stringFromDate:eventDate];
    NSLog(@"theDate=%@",theDate);
    NSLog(@"theDate=%@",theTime);
    
    
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    SelectDate_TXT.text = [NSString stringWithFormat:@"%@",dateString];
}

-(void)GetCardDetail
{
    NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
    
    NSString *User_UID=[UserData valueForKey:@"u_id"];
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:get_cart_itemsServiceName  forKey:@"service"];
    [dictParams setObject:User_UID  forKey:@"uid"];

    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,GetCardItem_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleGetCardDetailResponse:response];
     }];
}

- (void)handleGetCardDetailResponse:(NSDictionary*)response
{
    NSLog(@"card respose respone=%@",response);
    
    
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        RestruntNameView.hidden=NO;
        [_RestorantImage setHidden:NO];
        [_RestNameLBL setHidden:NO];
        [_RestAddressLBL setHidden:NO];
        [_RestDeleveryLBL setHidden:NO];
        [_JustDeleveyLBL setHidden:NO];
        [_justCellRestImge setHidden:NO];
         [upperView setHidden:NO];
        
        CardDicnory=[response valueForKey:@"result"];
        
        itemDetailDic=[[CardDicnory valueForKey:@"items"] valueForKey:@"product_detail"];
        deleteproductDic=[CardDicnory valueForKey:@"items"];
        
        NSString *TotalQTY=[NSString stringWithFormat:@"%lu",(unsigned long)itemDetailDic.count];
        [[NSUserDefaults standardUserDefaults] setObject:TotalQTY forKey:@"QUANTITYCOUNT"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        dic=[[NSMutableDictionary alloc]init];
        MainDic=[[NSMutableDictionary alloc]init];
        
        arr=[[NSMutableArray alloc]initWithArray:[[CardDicnory valueForKey:@"items"] valueForKey:@"qty"]];
        MainCount=[[NSMutableArray alloc]initWithArray:[[CardDicnory valueForKey:@"items"] valueForKey:@"qty"]];

        [dic setObject:arr forKey:@"Count"];
        [MainDic setObject:MainCount forKey:@"MainCount"];
        
        _upperOrderQTYLBL.text=[NSString stringWithFormat:@"Order Total (%lu Items)",(unsigned long)itemDetailDic.count];
        self.Total_LBL.text=[NSString stringWithFormat:@"Total : $ %@",[[CardDicnory valueForKey:@"sub_total"] stringValue]];
        _upperTotalLBL.text=[NSString stringWithFormat:@"$ %@",[[CardDicnory valueForKey:@"sub_total"] stringValue]];
        
        SubTotalValues=[[CardDicnory valueForKey:@"sub_total"]integerValue];
        OldSubTotalValues=[[CardDicnory valueForKey:@"sub_total"]integerValue];
        
        
        // Restorant_detail
        NSString *Urlstr=[[CardDicnory valueForKey:@"restorant_detail"] valueForKey:@"image_path"];
        Urlstr = [Urlstr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self.RestorantImage sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
        [self.RestorantImage setShowActivityIndicatorView:YES];
        
        self.RestNameLBL.text=[[CardDicnory valueForKey:@"restorant_detail"] valueForKey:@"name"];
        self.RestAddressLBL.text=[[CardDicnory valueForKey:@"restorant_detail"] valueForKey:@"address"];
        NSString *delivery_option=[[CardDicnory valueForKey:@"restorant_detail"] valueForKey:@"delivery_option"];
        if ([delivery_option integerValue]==1)
        {
            self.RestDeleveryLBL.text=@"available";
        }
        else
        {
             self.RestDeleveryLBL.text=@"Not available";
        }
        
        [TableView reloadData];
    }
    else
    {
        EmptyCartView.hidden=NO;
        BottomView.hidden=YES;
        [upperView setHidden:YES];
        [_RestorantImage setHidden:YES];
        [_RestNameLBL setHidden:YES];
        [_RestAddressLBL setHidden:YES];
        [_RestDeleveryLBL setHidden:YES];
        [_JustDeleveyLBL setHidden:YES];
        [_justCellRestImge setHidden:YES];
        //[AppDelegate showErrorMessageWithTitle:AlertTitleError message:@"CART EMPTY" delegate:nil];
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

#pragma mark - photoShotSavedDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection = %li", (long)selectionIndex);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)BackBtn_Click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)Menu_Click:(id)sender
{
    [self.rootNav drawerToggle];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return itemDetailDic.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 4.; // you can have your own choice, of course
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProductDetailCell";
    ProductDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    }
    
    cell.AddCart_BTN.hidden=YES;
    cell.JustQuantityLBL.hidden=YES;
    cell.RestDetailPlusView.hidden=YES;
    //cell.PlushView.hidden=NO;
    cell.Plush_BTN.tag=indexPath.row;
    cell.Minush_BTN.tag=indexPath.row;
    cell.Close_BTN.tag=indexPath.row;
    
    cell.Cancel_BTN.tag=indexPath.row;
    cell.Update_BTN.tag=indexPath.row;
    
    
    NSInteger *Main=[[[MainDic valueForKey:@"MainCount"] objectAtIndex:indexPath.row] integerValue];
    
    NSInteger *Second=[[[dic valueForKey:@"Count"] objectAtIndex:indexPath.row] integerValue];
    
    if (Main==Second)
    {
        cell.Update_View.hidden=YES;
        cell.Qunt_LBL.text=[NSString stringWithFormat:@"%ld",Main];
        
        
    }
    else
    {
        cell.Update_View.hidden=NO;
        cell.Qunt_LBL.text=[NSString stringWithFormat:@"%ld",Second];
    }
    
    [cell.Plush_BTN addTarget:self action:@selector(PlushClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.Minush_BTN addTarget:self action:@selector(MinushClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.Close_BTN addTarget:self action:@selector(RemoveCellClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.Update_BTN addTarget:self action:@selector(UpdateCellClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.Cancel_BTN addTarget:self action:@selector(CancelCellClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.Title_LBL.text=[[itemDetailDic valueForKey:@"name"] objectAtIndex:indexPath.row];
    cell.Price_LBL.text=[NSString stringWithFormat:@"$%@",[[itemDetailDic valueForKey:@"sell_price"] objectAtIndex:indexPath.row]];
    
    cell.Cat_LBL.text=[[itemDetailDic valueForKey:@"category"] objectAtIndex:indexPath.row];
    
    NSString *Urlstr=[[itemDetailDic valueForKey:@"image_path"] objectAtIndex:indexPath.row];
    Urlstr = [Urlstr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [cell.item_IMG sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
    [cell.item_IMG setShowActivityIndicatorView:YES];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)CancelCellClick:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
//    UIView *cellContentView = (UIView *)senderButton.superview;
//    UITableViewCell *buttonCell = (UITableViewCell *)[[cellContentView superview] superview];
//    UITableView* table = (UITableView *)[[buttonCell superview] superview];
//    NSIndexPath* pathOfTheCell = [table indexPathForCell:buttonCell];
//    NSDictionary *item = sortedItems[sortedItems.allKeys[pathOfTheCell.row]];
    
    NSInteger *Main=[[[MainDic valueForKey:@"MainCount"] objectAtIndex:senderButton.tag] integerValue];
   // NSInteger *Second=[[[dic valueForKey:@"Count"] objectAtIndex:senderButton.tag] integerValue];
    
    [arr replaceObjectAtIndex:senderButton.tag withObject:[NSString stringWithFormat:@"%ld",Main]];
    [dic setObject:arr forKey:@"Count"];
    self.Total_LBL.text=[NSString stringWithFormat:@"Total : $ %ld",(long)OldSubTotalValues];
    _upperTotalLBL.text=[NSString stringWithFormat:@"$ %ld",(long)OldSubTotalValues];
    SubTotalValues=OldSubTotalValues;
    
    [TableView reloadData];
    
}
-(void)UpdateCellClick:(id)sender
{
    
    NSLog(@"update Method Call");
    UIButton *senderButton = (UIButton *)sender;
    UIView *cellContentView = (UIView *)senderButton.superview;
    UITableViewCell *buttonCell = (UITableViewCell *)[[cellContentView superview] superview];
    UITableView* table = (UITableView *)[[buttonCell superview] superview];
    NSIndexPath* pathOfTheCell = [table indexPathForCell:buttonCell];
    ProductDetailCell *cell = (ProductDetailCell *)[TableView cellForRowAtIndexPath:pathOfTheCell];
   
    [self UpdatecardDetail:cell.Qunt_LBL.text CatgoryId:[[[CardDicnory valueForKey:@"items"] valueForKey:@"id"] objectAtIndex:senderButton.tag]];
    
    [arr replaceObjectAtIndex:senderButton.tag withObject:[NSString stringWithFormat:@"%@",cell.Qunt_LBL.text]];
    [dic setObject:arr forKey:@"Count"];
    
    [MainCount replaceObjectAtIndex:senderButton.tag withObject:[NSString stringWithFormat:@"%@",cell.Qunt_LBL.text]];
    [MainDic setObject:MainCount forKey:@"MainCount"];
    OldSubTotalValues=SubTotalValues;
    
    [TableView reloadData];
    
}

-(void)PlushClick:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    UIView *cellContentView = (UIView *)senderButton.superview;
    UITableViewCell *buttonCell = (UITableViewCell *)[[cellContentView superview] superview];
    UITableView* table = (UITableView *)[[buttonCell superview] superview];
    NSIndexPath* pathOfTheCell = [table indexPathForCell:buttonCell];
    //NSDictionary *item = sortedItems[sortedItems.allKeys[pathOfTheCell.row]];
    ProductDetailCell *cell = (ProductDetailCell *)[TableView cellForRowAtIndexPath:pathOfTheCell];
    NSLog(@"senderButton.tag=%ld",(long)senderButton.tag);
    cell.Update_View.hidden=NO;
    
    NSInteger count = [cell.Qunt_LBL.text integerValue];
    count = count + 1;
    if (count<11)
    {
        cell.Qunt_LBL.text = [NSString stringWithFormat:@"%ld",count];
        
        [arr replaceObjectAtIndex:senderButton.tag withObject:[NSString stringWithFormat:@"%ld",count]];
        [dic setObject:arr forKey:@"Count"];
        SubTotalValues=SubTotalValues+[[[itemDetailDic valueForKey:@"sell_price"] objectAtIndex:senderButton.tag] integerValue];
        self.Total_LBL.text=[NSString stringWithFormat:@"Total : $ %ld",(long)SubTotalValues];
        _upperTotalLBL.text=[NSString stringWithFormat:@"$ %ld",(long)SubTotalValues];
        
        ButtonTag=senderButton.tag;
        chechPlusMinus=1;
        cell.Update_View.hidden=NO;
    }
    
    //[TableView reloadData];
    
}

-(void)MinushClick:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    UIView *cellContentView = (UIView *)senderButton.superview;
    UITableViewCell *buttonCell = (UITableViewCell *)[[cellContentView superview] superview];
    UITableView* table = (UITableView *)[[buttonCell superview] superview];
    NSIndexPath* pathOfTheCell = [table indexPathForCell:buttonCell];
    //NSDictionary *item = sortedItems[sortedItems.allKeys[pathOfTheCell.row]];
    ProductDetailCell *cell = (ProductDetailCell *)[TableView cellForRowAtIndexPath:pathOfTheCell];
    
    NSInteger count = [cell.Qunt_LBL.text integerValue];
    count = count - 1;
    if (count!=0)
    {
        cell.Qunt_LBL.text = [NSString stringWithFormat:@"%ld",count];
        [arr replaceObjectAtIndex:senderButton.tag withObject:[NSString stringWithFormat:@"%ld",count]];
        [dic setObject:arr forKey:@"Count"];
        ButtonTag=senderButton.tag;
        chechPlusMinus=0;
        cell.Update_View.hidden=NO;
        SubTotalValues=SubTotalValues-[[[itemDetailDic valueForKey:@"sell_price"] objectAtIndex:senderButton.tag] integerValue];
        self.Total_LBL.text=[NSString stringWithFormat:@"Total : $ %ld",(long)SubTotalValues];
        _upperTotalLBL.text=[NSString stringWithFormat:@"$ %ld",(long)SubTotalValues];
    }
}

-(void)UpdatecardDetail:(NSString *)qty CatgoryId:(NSString *)cid
{
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
        NSString *User_UID=[UserData valueForKey:@"u_id"];
        
        NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
        [dictParams setObject:r_p  forKey:@"r_p"];
        [dictParams setObject:updateCardItemServiceName  forKey:@"service"];
        [dictParams setObject:User_UID  forKey:@"uid"];
        [dictParams setObject:cid  forKey:@"cid"];
        [dictParams setObject:qty  forKey:@"qty"];
        NSLog(@"itemDetailDic=%@",dictParams);
        
        [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,GetCardItem_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
         {
             [self handleUpdateCardDetailResponse:response];
         }];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
   
}

- (void)handleUpdateCardDetailResponse:(NSDictionary*)response
{
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
       [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
        SubTotalValues=[[response objectForKey:@"total_price"] integerValue];
        OldSubTotalValues=[[response objectForKey:@"total_price"] integerValue];
       
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
    
}

-(void)RemoveCellClick:(id)sender
{
    NSLog(@"remove cell click");
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        UIButton *senderButton = (UIButton *)sender;
        ButtonTag=senderButton.tag;
        NSLog(@"remove cell tag=%ld",(long)senderButton.tag);
        
        NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
        NSString *User_UID=[UserData valueForKey:@"u_id"];
        
        NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
        [dictParams setObject:r_p  forKey:@"r_p"];
        [dictParams setObject:RemoveCardItemServiceName  forKey:@"service"];
        [dictParams setObject:User_UID  forKey:@"uid"];
        [dictParams setObject:[[deleteproductDic valueForKey:@"id"] objectAtIndex:senderButton.tag]  forKey:@"cid"];
        deleteQTY=[[deleteproductDic valueForKey:@"qty"] objectAtIndex:senderButton.tag];
        NSLog(@"deleteproductDic=%@",deleteproductDic);
        
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
        //*********************setup Quantity ********************************
        NSString *savedQTY = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"QUANTITYCOUNT"];
        
        if (savedQTY)
        {
            NSString *CalculateQTY=[NSString stringWithFormat:@"%d",[savedQTY integerValue]-1];
            [[NSUserDefaults standardUserDefaults] setObject:CalculateQTY forKey:@"QUANTITYCOUNT"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        //********************************************************************
        
        NSLog(@"ButtonTag delete=%ld",(long)ButtonTag);
        
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
        
       // NSMutableArray *tempDic1=[[[CardDicnory valueForKey:@"items"] valueForKey:@"product_detail"]mutableCopy ];
         NSMutableArray *tempDic1=[deleteproductDic mutableCopy ];
        
        [tempDic1 removeObjectAtIndex:ButtonTag];
        
        itemDetailDic = [[NSMutableDictionary alloc]init];
        itemDetailDic=[[tempDic1 valueForKey:@"product_detail"] mutableCopy];
        deleteproductDic=[tempDic1 mutableCopy];
        NSString *removeZeroStr = [[response objectForKey:@"total_price"] stringByReplacingOccurrencesOfString:@".00" withString:@""];
        SubTotalValues=[removeZeroStr integerValue];
        
        self.Total_LBL.text=[NSString stringWithFormat:@"Total : $ %ld",(long)SubTotalValues];
        _upperTotalLBL.text=[NSString stringWithFormat:@"$ %ld",(long)SubTotalValues];
         _upperOrderQTYLBL.text=[NSString stringWithFormat:@"Order Total (%lu Items)",(unsigned long)itemDetailDic.count];
        [TableView reloadData];
        
        if (itemDetailDic.count==0)
        {
            EmptyCartView.hidden=NO;
             RestruntNameView.hidden=YES;
            [upperView setHidden:YES];
            [_RestorantImage setHidden:YES];
            [_RestNameLBL setHidden:YES];
            [_RestAddressLBL setHidden:YES];
            [_RestDeleveryLBL setHidden:YES];
            [_JustDeleveyLBL setHidden:YES];
            [_justCellRestImge setHidden:YES];
        }
        
        NSLog(@"itemDetailDic=%@",itemDetailDic);
    }
    else
    {
        
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
    
    
}

#pragma mark - pop AlertView;

-(void)ShowPOPUP
{
    [POPView bringSubviewToFront:self.view];
    POPView.hidden=NO;
    
      _POPFristView= (UIView *)[POPView viewWithTag:1];
     _POPSecondView= (UIView *)[POPView viewWithTag:2];
     _POPThirdView= (UIView *)[POPView viewWithTag:3];
    
    [_POPFristView setHidden:YES];
    [_POPSecondView setHidden:YES];
    [_POPThirdView setHidden:YES];
    
    _POPTakeAway= (UIButton *)[POPView viewWithTag:22];
    [_POPTakeAway addTarget:self action:@selector(POPTakeAway_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    _POPDelivery =(UIButton *)[POPView viewWithTag:33];
    [_POPDelivery addTarget:self action:@selector(POPDelivery_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    _POPProceed =(UIButton *)[POPView viewWithTag:44];
    [_POPProceed addTarget:self action:@selector(POPProceed_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    _POPCancel =(UIButton *)[POPView viewWithTag:55];
     _POPMinValue =(UILabel *)[POPView viewWithTag:11];
    [_POPCancel addTarget:self action:@selector(POPCancel_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    _POPTakeAway44= (UIButton *)[POPView viewWithTag:44];
    [_POPTakeAway44 addTarget:self action:@selector(POPTakeAway_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    _POPDelivery55 =(UIButton *)[POPView viewWithTag:55];
    [_POPDelivery55 addTarget:self action:@selector(POPDelivery_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    _POPTakeAway66= (UIButton *)[POPView viewWithTag:66];
    [_POPTakeAway66 addTarget:self action:@selector(POPTakeAway_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    
     NSString *delivery_option=[[CardDicnory valueForKey:@"restorant_detail"] valueForKey:@"delivery_option"];
    
    if ([delivery_option integerValue]==0)
    {
        [_POPThirdView setHidden:NO];
         _POPTakeAway66.enabled=YES;
    }
    else
    {
         NSString *MinVlaue=[[CardDicnory valueForKey:@"restorant_detail"] valueForKey:@"min_delivery_amount"];
        if ([MinVlaue integerValue]>OldSubTotalValues)
        {
            
            _POPDelivery55.enabled=NO;
            [_POPSecondView setHidden:NO];
            [_POPFristView setHidden:YES];
            [_POPThirdView setHidden:YES];
             NSString *min_delivery_amount=[[CardDicnory valueForKey:@"restorant_detail"] valueForKey:@"min_delivery_amount"];
             _POPMinValue.text=[NSString stringWithFormat:@"$ %@",min_delivery_amount];
        }
        else
        {
             _POPDelivery55.enabled=YES;
            [_POPFristView setHidden:NO];
            [_POPSecondView setHidden:YES];
            [_POPThirdView setHidden:YES];
        }
    }
    
}

-(void)POPTakeAway_Click:(id)sender
{
    POPView.hidden=YES;
    
    //self.POPTakeAway.backgroundColor= [UIColor colorWithRed:(25/255.0) green:(123/255.0) blue:(48/255.0) alpha:1.0];
   // self.POPDelivery.backgroundColor= [UIColor colorWithRed:(204/255.0) green:(204/255.0) blue:(204/255.0) alpha:1.0];
    
    PaymentView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaymentView"];
      vcr.C_ID=[CardDicnory valueForKey:@"cart_id"];
    [self.navigationController pushViewController:vcr animated:NO];
}

-(void)POPDelivery_Click:(id)sender
{
    POPView.hidden=YES;
    //self.POPDelivery.backgroundColor= [UIColor colorWithRed:(25/255.0) green:(123/255.0) blue:(48/255.0) alpha:1.0];
   // self.POPTakeAway.backgroundColor= [UIColor colorWithRed:(204/255.0) green:(204/255.0) blue:(204/255.0) alpha:1.0];
    
   // DeliveryView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DeliveryView"];
   //  vcr.C_ID_Delivery=[CardDicnory valueForKey:@"cart_id"];
   // [self.navigationController pushViewController:vcr animated:NO];
}

-(void)POPProceed_Click:(id)sender
{
    NSLog(@"processed");
    POPView.hidden=YES;
}

-(void)POPCancel_Click:(id)sender
{
    POPView.hidden=YES;
}

- (IBAction)CheckOut_btnClick:(id)sender
{
    self.CheckoutBTN.enabled=NO;
    if (itemDetailDic.count==0)
    {
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:@"CART EMPTY" delegate:nil];
        self.CheckoutBTN.enabled=YES;
    }
    else
    {
        
        if (Paymethod_Str.length==0)
        {
            [AppDelegate showErrorMessageWithTitle:AlertTitleError message:@"Please Select Delivery Option." delegate:nil];
            self.CheckoutBTN.enabled=YES;
        }
        else if(theDate.length==0 || theTime.length==0)
        {
            [AppDelegate showErrorMessageWithTitle:AlertTitleError message:@"Please Select Date and Time" delegate:nil];
            self.CheckoutBTN.enabled=YES;
        }
        else
        {
            BOOL internet=[AppDelegate connectedToNetwork];
            if (internet)
            {
                if ([Paymethod_Str isEqualToString:@"Delivery"])
                {
                    NSString *tempTotalcheck=_upperTotalLBL.text;
                    tempTotalcheck = [tempTotalcheck stringByReplacingOccurrencesOfString:@"$ " withString:@""];
                    
                    [self performSelector:@selector(checkDeliveryTime) withObject:nil afterDelay:0.1];
                   
                }
                else
                {
                    [self performSelector:@selector(checkTakeAwayTime) withObject:nil afterDelay:0.1];
                }
                
            }
            else
            {
                [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
                self.CheckoutBTN.enabled=YES;
            }
            
        }
         //[self ShowPOPUP];
        
    }
}

-(void)checkTakeAwayTime
{
    NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
    NSString *User_UID=[UserData valueForKey:@"u_id"];
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:checkTakeAwayTimeServiceName  forKey:@"service"];
    [dictParams setObject:User_UID  forKey:@"uid"];
    [dictParams setObject:[CardDicnory valueForKey:@"cart_id"]  forKey:@"cid"];
    [dictParams setObject:theTime  forKey:@"take_away_time"];
    [dictParams setObject:theDate  forKey:@"take_away_date"];
    
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,CardService_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleCheckTakeAwayTimeResponse:response];
     }];
}
- (void)handleCheckTakeAwayTimeResponse:(NSDictionary*)response
{
    
    NSLog(@"check takeway Response=%@",response);
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        PaymentView1 *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaymentView1"];
        vcr.C_ID=[CardDicnory valueForKey:@"cart_id"];
        vcr.PassDateNTime=[NSString stringWithFormat:@"%@ %@",theDate,theTime];
        [self.navigationController pushViewController:vcr animated:NO];
         self.CheckoutBTN.enabled=YES;
        
    }
    else
    {
         self.CheckoutBTN.enabled=YES;
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
    
    
}
-(void)checkDeliveryTime
{
    NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
    NSString *User_UID=[UserData valueForKey:@"u_id"];
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:checkDeliveryTimeServiceName  forKey:@"service"];
    [dictParams setObject:User_UID  forKey:@"uid"];
    [dictParams setObject:[CardDicnory valueForKey:@"cart_id"]  forKey:@"cid"];
    [dictParams setObject:theTime  forKey:@"delivery_time"];
    [dictParams setObject:theDate  forKey:@"delivery_date"];
    
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,CardService_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleCheckDilveryTimeResponse:response];
     }];
}
- (void)handleCheckDilveryTimeResponse:(NSDictionary*)response
{
    
    NSLog(@"check delvery Response=%@",response);
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        DeliveryView1 *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DeliveryView1"];
        vcr.C_ID_Delivery1=[CardDicnory valueForKey:@"cart_id"];
        vcr.theDateNTimeDilvery=[NSString stringWithFormat:@"%@ %@",theDate,theTime];
        [self.navigationController pushViewController:vcr animated:NO];
         self.CheckoutBTN.enabled=YES;
        
    }
    else
    {
         self.CheckoutBTN.enabled=YES;
        [AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
    }
    
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
   //  POPView.hidden=YES;// this will do the trick
}
- (IBAction)DeliveryRadioBtn_Action:(id)sender
{
    self.UpperDeliveryRadioImage.image=[UIImage imageNamed:@"YellowRadioON"];
    self.upperTakeAwayImage.image=[UIImage imageNamed:@"YellowRadioOff"];
    
    Paymethod_Str=@"Delivery";
}
- (IBAction)TakeAwayBtn_action:(id)sender
{
    self.UpperDeliveryRadioImage.image=[UIImage imageNamed:@"YellowRadioOff"];
    self.upperTakeAwayImage.image=[UIImage imageNamed:@"YellowRadioON"];
   
    Paymethod_Str=@"TakeAway";

}


@end
