//
//  RestaurantDetailView.m
//  HalalMeatDelivery
//
//  Created by kaushik on 25/08/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import "RestaurantDetailView.h"
#import "HalalMeatDelivery.pch"
#import "ProductDetailCell.h"
#import "RestaurantDetailView.h"
#import "RestaurantHeaderView.h"
#import "UIImageView+WebCache.h"
#import "ShoppingCartView.h"
#import "RateView.h"
#import <CoreLocation/CoreLocation.h>


@interface RestaurantDetailView ()<UIScrollViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    RestaurantHeaderView *HeaderView;
    UIScrollView *Imagescr;
    UIPageControl *pageControl ;
    NSMutableArray *Cat_Arr,*LoadArr;
    NSMutableDictionary *ItemDic;
    
    NSMutableArray *MainCountArr;
    
    UIImageView *ImgVW;
    CGFloat screenWidth;
    NSMutableArray *arrData;
    int pageTable;
    UITableView *DataTable;
}
@property AppDelegate *appDelegate;


@property (strong, nonatomic) UILabel *DistBTN;
@property (strong, nonatomic) NSMutableDictionary *dic,*MainDic;
@property (strong, nonatomic) NSMutableArray *arr,*MainCount;
@end

@implementation RestaurantDetailView
@synthesize MapPlaceIMG,CartIMG,Back_BTN,DistBTN;
@synthesize RestraorntDic,R_ID,Pin;
@synthesize dic,arr,MainDic,MainCount;


@synthesize MainScroll;
@synthesize ImgScroll,ImgScrollWidth;
@synthesize TabScroll,TableScroll,ScrollHight;
@synthesize QTYICON_LBL;

#pragma mark - photoShotSavedDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection = %li", (long)selectionIndex);
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [QTYICON_LBL.layer removeAllAnimations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = [AppDelegate sharedInstance];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    [self settabscroll:3];
    
    _RestDistance_LBL.layer.cornerRadius=5;
    _RestDistance_LBL.layer.masksToBounds=YES;
    _RestDistance_LBL.layer.borderColor=[[UIColor whiteColor] CGColor];
    _RestDistance_LBL.layer.borderWidth=1;
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        if (R_ID.length>0)
        {
            [self GetRestDetail];
        }
        else
        {
            
            [self SetdataInTable];
        }
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
    [self.view bringSubviewToFront:Back_BTN];
    [self.view bringSubviewToFront:QTYICON_LBL];
    [self.view bringSubviewToFront:CartIMG];
    [self.view bringSubviewToFront:MapPlaceIMG];
    
    if (IS_IPHONE_4)
    {
        ScrollHight.constant=800;
    }
    if (IS_IPHONE_5)
    {
        ScrollHight.constant=885;
    }
    if (IS_IPHONE_6)
    {
        ScrollHight.constant=987;
    }
    if (IS_IPHONE_6P)
    {
        ScrollHight.constant=1053;
    }
    
    //QTYICON_LBL.layer.masksToBounds = YES;
    //QTYICON_LBL.layer.cornerRadius = 8.0;
    
    NSString *savedQTY = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"QUANTITYCOUNT"];
    
    if (savedQTY)
    {
        if ([savedQTY integerValue]==0 && savedQTY == nil)
        {
            [QTYICON_LBL setHidden:YES];
            Back_BTN.hidden=YES;
            self.MapPlaceIMG.hidden=YES;
            self.CartIMG.hidden=YES;
        }
        else
        {
            Back_BTN.hidden=NO;
            QTYICON_LBL.hidden=NO;
            self.MapPlaceIMG.hidden=NO;
            self.CartIMG.hidden=NO;
            QTYICON_LBL.text=savedQTY;
            
            QTYICON_LBL.alpha = 0;
            [UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
                QTYICON_LBL.alpha = 1;
            } completion:nil];
        }
    }
    else
    {
        Back_BTN.hidden=YES;
        QTYICON_LBL.hidden=YES;
        self.MapPlaceIMG.hidden=YES;
        self.CartIMG.hidden=YES;
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:NO];
    
    pageControl = [[UIPageControl alloc] init];
    [MainScroll addSubview:pageControl];
    [MainScroll setContentOffset:CGPointMake(0,2) animated:YES];

}

-(void)viewWillLayoutSubviews
{
    [self Setimagesroll];
    [self.view layoutIfNeeded];
}

- (void)leftSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
    NSLog(@"leftSwipeHandle");
}


#pragma mark -
#pragma mark - Scrollview Delegate

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if([scrollView isKindOfClass:[UITableView class]])
    {
        return;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)sender
{
    if([sender isKindOfClass:[UITableView class]])
    {
        return;
    }
    CGFloat pageWidth = TableScroll.frame.size.width;
    pageTable = floor((TableScroll.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    NSLog(@"Current page %d",pageTable);
    
    
    for (UIButton *subview in [TabScroll subviews])
    {
        if([subview isKindOfClass:[UIButton class]])
        {
            if ([subview isKindOfClass:[UIButton class]])
            {
                if (subview.tag==pageTable)
                {
                    //[subview setTitleColor:[UIColor colorWithRed:208/255.0f green:170/255.0f blue:105/255.0f alpha:1.0f] forState:UIControlStateNormal];
                    [subview setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
                else
                {
                    [subview setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
            }
        }
    }
    
    for (UILabel *subview in [TabScroll subviews])
    {
        if([subview isKindOfClass:[UILabel class]])
        {
            if (subview.tag==pageTable)
            {
                subview.backgroundColor=[UIColor colorWithRed:169/255.0f green:32/255.0f blue:40/255.0f alpha:1.0f];
            }
            else
            {
                subview.backgroundColor=[UIColor colorWithRed:209/255.0f green:209/255.0f blue:209/255.0f alpha:1.0f];
            }
        }
    }
    
}

-(void)Setimagesroll
{
    int x=0;
    for (int i=0; i<[[RestraorntDic valueForKey:@"alt_img"] count]; i++)
    {
        ImgVW=[[UIImageView alloc]initWithFrame:CGRectMake(x, 0, screenWidth, 250)];
        NSString *Urlstr=[[RestraorntDic valueForKey:@"alt_img"] objectAtIndex:i];
        Urlstr = [Urlstr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [ImgVW sd_setImageWithURLforPromotion:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
        [ImgVW setShowActivityIndicatorView:YES];
        [ImgScroll addSubview:ImgVW];
        
       UIImageView *maskimg=[[UIImageView alloc]initWithFrame:CGRectMake(x, 0, screenWidth, 250)];
        maskimg.backgroundColor=[UIColor blackColor];
        maskimg.alpha=0.3f;
        //[Imagescr addSubview:maskimg];
        [ImgScroll addSubview:maskimg];
        
        x=x+screenWidth;
    }
    ImgScrollWidth.constant=x-screenWidth;

    
    pageControl.frame = CGRectMake(0,ImgVW.frame.size.height-30,screenWidth,5);
    pageControl.numberOfPages =[[RestraorntDic valueForKey:@"alt_img"] count];
    pageControl.currentPage = 0;
    
    if (Cat_Arr.count>0)
    {
        [HeaderView.Tab_Scroll layoutIfNeeded];
        [self settabscroll:Cat_Arr.count];
        
//        if (Cat_Arr.count>=3)
//        {
//            [HeaderView.Tab_Scroll layoutIfNeeded];
//            [self settabscroll:Cat_Arr.count];
//        }
//        else
//        {
//
//            [HeaderView.Tab_Scroll layoutIfNeeded];
//            [self settabscroll:3];
//        }
    }
    
}

-(void)settabscroll:(NSInteger)itemCount
{
    NSArray* subviews = [[NSArray alloc] initWithArray: TabScroll.subviews];
    for (UIView* view in subviews)
    {
        if ([view isKindOfClass:[UIView class]])
        {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UIImageView class]])
        {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UILabel class]])
        {
            [view removeFromSuperview];
        }
    }
  //  float wdi=screenWidth/itemCount;
    

    
    int x=0;
    for (int i=0; i<itemCount; i++)
    {
        CGSize stringsize = [[[Cat_Arr objectAtIndex:i] uppercaseString] sizeWithFont:[UIFont systemFontOfSize:17]];

        UIButton *BTN=[[UIButton alloc]initWithFrame:CGRectMake(x, 0, stringsize.width-1, 40)];
        [BTN setTitle:[[Cat_Arr objectAtIndex:i] uppercaseString] forState:UIControlStateNormal];
        BTN.backgroundColor=[UIColor clearColor];
        BTN.tag=i;
        BTN.titleLabel.font=[UIFont systemFontOfSize:15];
        [BTN addTarget:self action:@selector(BTN_Click:) forControlEvents:UIControlEventTouchUpInside];
        [BTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [TabScroll addSubview:BTN];
        
        UILabel *LineLBL=[[UILabel alloc]initWithFrame:CGRectMake(x, 41, stringsize.width-1, 4)];
        if (i==0)
        {
            [BTN setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            LineLBL.backgroundColor=[UIColor colorWithRed:169/255.0f green:32/255.0f blue:40/255.0f alpha:1.0f];
        }
        else
        {
            [BTN setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            LineLBL.backgroundColor=[UIColor colorWithRed:209/255.0f green:209/255.0f blue:209/255.0f alpha:1.0f];
        }
        LineLBL.tag=i;
        [TabScroll  addSubview:LineLBL];
        x=x+stringsize.width+1;
    }
    [TabScroll setContentSize:CGSizeMake(x, 0)];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if([sender isKindOfClass:[UITableView class]])
    {
        return;
    }
    
    if (sender==ImgScroll)
    {
        CGFloat pageWidth = ImgScroll.frame.size.width;
        float fractionalPage = ImgScroll.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        pageControl.currentPage = page;
    }
    if (sender==MainScroll)
    {
        CGPoint offset = MainScroll.contentOffset;
        CGRect bounds = MainScroll.bounds;
        UIEdgeInsets inset = MainScroll.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        // float h = size.height;
        NSString *savedQTY = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"QUANTITYCOUNT"];
        
        if (IS_IPHONE_4)
        {
            if (y>780)
            {
                Back_BTN.hidden=YES;
                QTYICON_LBL.hidden=YES;
                self.MapPlaceIMG.hidden=YES;
                self.CartIMG.hidden=YES;
                HeaderView.Desc_LBL.hidden=YES;
                _RestorantAddress_Lbl.hidden=YES;
                self.Cart_BTN.hidden=YES;
                self.Map_BTN.hidden=YES;
            }
            else
            {
                Back_BTN.hidden=NO;
               // QTYICON_LBL.hidden=NO;
                self.MapPlaceIMG.hidden=NO;
                self.CartIMG.hidden=NO;
                HeaderView.Desc_LBL.hidden=NO;
                _RestorantAddress_Lbl.hidden=NO;
                self.Cart_BTN.hidden=NO;
                self.Map_BTN.hidden=NO;
                if (savedQTY)
                {
                    if ([savedQTY integerValue]==0)
                    {
                        [QTYICON_LBL setHidden:YES];
                    }
                    else
                    {
                        QTYICON_LBL.hidden=NO;
                        QTYICON_LBL.text=savedQTY;
                    }
                }
                else
                {
                    QTYICON_LBL.hidden=YES;
                }
            }
        }
        if (IS_IPHONE_5)
        {
            if (y>850)
            {
                Back_BTN.hidden=YES;
                QTYICON_LBL.hidden=YES;
                self.MapPlaceIMG.hidden=YES;
                self.CartIMG.hidden=YES;
                HeaderView.Desc_LBL.hidden=YES;
                _RestorantAddress_Lbl.hidden=YES;
                self.Cart_BTN.hidden=YES;
                self.Map_BTN.hidden=YES;
            }
            else
            {
                Back_BTN.hidden=NO;
               // QTYICON_LBL.hidden=NO;
                self.MapPlaceIMG.hidden=NO;
                self.CartIMG.hidden=NO;
                HeaderView.Desc_LBL.hidden=NO;
                _RestorantAddress_Lbl.hidden=NO;
                self.Cart_BTN.hidden=NO;
                self.Map_BTN.hidden=NO;
                if (savedQTY)
                {
                    if ([savedQTY integerValue]==0)
                    {
                        [QTYICON_LBL setHidden:YES];
                    }
                    else
                    {
                        QTYICON_LBL.hidden=NO;
                        QTYICON_LBL.text=savedQTY;
                    }
                }
                else
                {
                    QTYICON_LBL.hidden=YES;
                }
            }
        }
        if (IS_IPHONE_6)
        {
            if (y>978)
            {
                Back_BTN.hidden=YES;
                QTYICON_LBL.hidden=YES;
                self.MapPlaceIMG.hidden=YES;
                self.CartIMG.hidden=YES;
                HeaderView.Desc_LBL.hidden=YES;
                _RestorantAddress_Lbl.hidden=YES;
                self.Cart_BTN.hidden=YES;
                self.Map_BTN.hidden=YES;
            }
            else
            {
                Back_BTN.hidden=NO;
               // QTYICON_LBL.hidden=NO;
                self.MapPlaceIMG.hidden=NO;
                self.CartIMG.hidden=NO;
                HeaderView.Desc_LBL.hidden=NO;
                _RestorantAddress_Lbl.hidden=NO;
                self.Cart_BTN.hidden=NO;
                self.Map_BTN.hidden=NO;
                if (savedQTY)
                {
                    if ([savedQTY integerValue]==0)
                    {
                        [QTYICON_LBL setHidden:YES];
                    }
                    else
                    {
                        QTYICON_LBL.hidden=NO;
                        QTYICON_LBL.text=savedQTY;
                    }
                }
                else
                {
                    QTYICON_LBL.hidden=YES;
                }
            }
        }
        if (IS_IPHONE_6P)
        {
            if (y>1048)
            {
                Back_BTN.hidden=YES;
                QTYICON_LBL.hidden=YES;
                self.MapPlaceIMG.hidden=YES;
                self.CartIMG.hidden=YES;
                HeaderView.Desc_LBL.hidden=YES;
                _RestorantAddress_Lbl.hidden=YES;
                self.Cart_BTN.hidden=YES;
                self.Map_BTN.hidden=YES;
            }
            else
            {
                Back_BTN.hidden=NO;
               // QTYICON_LBL.hidden=NO;
                self.MapPlaceIMG.hidden=NO;
                self.CartIMG.hidden=NO;
                HeaderView.Desc_LBL.hidden=NO;
                _RestorantAddress_Lbl.hidden=NO;
                self.Cart_BTN.hidden=NO;
                self.Map_BTN.hidden=NO;
                if (savedQTY)
                {
                    if ([savedQTY integerValue]==0)
                    {
                        [QTYICON_LBL setHidden:YES];
                    }
                    else
                    {
                        QTYICON_LBL.hidden=NO;
                        QTYICON_LBL.text=savedQTY;
                    }
                }
                else
                {
                    QTYICON_LBL.hidden=YES;
                }
            }
        }
        
        
        NSLog(@"%f",y);
    }
}

-(void)BTN_Click:(UIButton *)sender
{
    pageTable=[sender tag];
    for (UIButton *subview in [TabScroll subviews])
    {
        if([subview isKindOfClass:[UIButton class]])
        {
            if (subview.tag==sender.tag)
            {
                [subview setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            else
            {
                [subview setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
    }
    
    for (UILabel *subview in [TabScroll subviews])
    {
        if([subview isKindOfClass:[UILabel class]])
        {
            if (subview.tag==sender.tag)
            {
                subview.backgroundColor=[UIColor colorWithRed:169/255.0f green:32/255.0f blue:40/255.0f alpha:1.0f];
            }
            else
            {
                subview.backgroundColor=[UIColor colorWithRed:209/255.0f green:209/255.0f blue:209/255.0f alpha:1.0f];
            }
        }
    }
    [self scrollToPage:sender.tag];
    
}

-(void)scrollToPage:(NSInteger)aPage
{
    float myPageWidth = [TableScroll frame].size.width;
    [TableScroll setContentOffset:CGPointMake(aPage*myPageWidth,0) animated:YES];
    
    NSArray* subviews = [[NSArray alloc] initWithArray: TableScroll.subviews];
    for (UITableView* view in subviews)
    {
        if ([view isKindOfClass:[UITableView class]])
        {
            [view reloadData];
        }
    }
}


-(void)Settable
{
    NSArray* subviews = [[NSArray alloc] initWithArray: TableScroll.subviews];
    for (UIView* view in subviews)
    {
        if ([view isKindOfClass:[UIView class]])
        {
            [view removeFromSuperview];
        }
        
        if ([view isKindOfClass:[UITableView class]])
        {
            [view removeFromSuperview];
        }
    }
    int width=0;
    for (int i = 0; i<[arrData count]; i++)
    {
        DataTable = [[UITableView alloc] initWithFrame:CGRectMake(width, 0, screenWidth, 600) style:UITableViewStylePlain];
        
        DataTable.tag=i;
        DataTable.dataSource = self;
        DataTable.delegate = self;
        [DataTable setBackgroundColor:[UIColor clearColor]];
        DataTable.separatorColor = [UIColor clearColor];
        DataTable.separatorStyle = UITableViewCellSeparatorStyleNone;

        [TableScroll addSubview:DataTable];
        width+=screenWidth;
    }
    
    [TableScroll setContentSize:CGSizeMake(([arrData count])*screenWidth, TableScroll.frame.size.height)];
}


-(void)GetRestDetail
{
    
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
    [dictParams setObject:r_p  forKey:@"r_p"];
    [dictParams setObject:SerachByPincodeServiceName  forKey:@"service"];
    [dictParams setObject:R_ID  forKey:@"rid"];
    [dictParams setObject:@"1"  forKey:@"p_required"];
    //[dictParams setObject:Pin  forKey:@"pin"];
    
   
    
    NSLog(@"rest dictParams==%@",dictParams);
    
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,GerRestByCatID_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleResponse:response];
     }];
    
}

- (void)handleResponse:(NSDictionary*)response
{
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        RestraorntDic=[[response valueForKey:@"result"] objectAtIndex:0];
        
        [self SetdataInTable];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:@"Error" message:@"Nothing to Show" delegate:nil];
    }
}

-(void)SetdataInTable
{
   // NSLog(@"REST===%@",RestraorntDic);
    NSArray* subviews = [[NSArray alloc] initWithArray: TableScroll.subviews];
    for (UIView* view in subviews)
    {
        if ([view isKindOfClass:[UIView class]])
        {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UIImageView class]])
        {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UILabel class]])
        {
            [view removeFromSuperview];
        }
    }
    
    //--------------------------Header View Of Restorant ---------------------------------------
    _RestorantName_Lbl.text=[RestraorntDic valueForKey:@"name"];
    _RestorantAddress_Lbl.text=[RestraorntDic valueForKey:@"address"];
    _ReviewCount_LBL.text=[NSString stringWithFormat:@"(%@ Review)",[RestraorntDic valueForKey:@"count_review"]];
    [self ReviewCount:[NSString stringWithFormat:@"%@",[RestraorntDic valueForKey:@"rate"]]];
    Cat_Arr=[[[RestraorntDic valueForKey:@"products"] valueForKey:@"service_category"]mutableCopy];
    _RestDistance_LBL.text=[NSString stringWithFormat:@" %@ ",[RestraorntDic valueForKey:@"distance"] ];
    ResLat=[RestraorntDic valueForKey:@"latitude"];
    ResLog=[RestraorntDic valueForKey:@"longitude"];
    if (Cat_Arr.count>0)
    {
        ItemDic=[[RestraorntDic valueForKey:@"products"] valueForKey:[Cat_Arr objectAtIndex:0]];
        MainCount=[[NSMutableArray alloc]init];
        NSString *CatStr=[[NSString alloc]init];
        arrData=[[NSMutableArray alloc] init];
        for (int i=0; i<Cat_Arr.count; i++)
        {
            arr=[[RestraorntDic valueForKey:@"products"] valueForKey:[Cat_Arr objectAtIndex:i]];
            NSMutableArray *countArr=[[NSMutableArray alloc]init];
            for (int j=0; j<arr.count; j++)
            {
                [countArr addObject:@"1"];
            }
            [MainCount addObject:countArr];
           
            //***************** static array or Dic *****************************
//            dic=[[NSMutableDictionary alloc]init];
//            MainDic=[[NSMutableDictionary alloc]init];
//            arr=[[NSMutableArray alloc]init];
//            MainCount=[[NSMutableArray alloc]init];
//            for (int i = 0; i<[arr count]; i++)
//            {
//                [arr addObject:@"1"];
//                [MainCount addObject:@"1"];
//            }
//            [dic setObject:arr forKey:@"Count"];
//            [MainDic setObject:MainCount forKey:@"MainCount"];
            //***************** static array or Dic *****************************
            [arrData addObject:arr];
            if (i==0)
            {
                CatStr=[NSString stringWithFormat:@"%@",[Cat_Arr objectAtIndex:i]];
            }
            else
            {
                CatStr=[NSString stringWithFormat:@"%@,%@",CatStr,[Cat_Arr objectAtIndex:i]];
            }
        }
        _RestroantProName_Lbl.text=CatStr;
    }
    //-------------------------------------END-----------------------------------------------------
    
    int width=0;
    for (int i = 0; i<[arrData count]; i++)
    {
        DataTable = [[UITableView alloc] initWithFrame:CGRectMake(width, 0, screenWidth, 600) style:UITableViewStylePlain];
        
        UINib *nib = [UINib nibWithNibName:@"ProductDetailCell" bundle:nil];
        ProductDetailCell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        DataTable.rowHeight = cell.frame.size.height;
        [DataTable registerNib:nib forCellReuseIdentifier:@"ProductDetailCell"];
        
        DataTable.tag=i;
        DataTable.dataSource = self;
        DataTable.delegate = self;
        [DataTable setBackgroundColor:[UIColor clearColor]];
        DataTable.separatorColor = [UIColor blackColor];
        [TableScroll addSubview:DataTable];
        width+=screenWidth;
    }
    
    
    
    
    [TableScroll setContentSize:CGSizeMake(([arrData count])*screenWidth, TableScroll.frame.size.height)];
    [self Setimagesroll];
}

#pragma mark
#pragma mark - Table view data source
#pragma mark UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return [[arrData objectAtIndex:tableView.tag]count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProductDetailCell";
    ProductDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.accessoryView = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.PlushView.hidden=YES;
        cell.Update_View.hidden=YES;
        cell.Close_BTN.hidden=YES;
        cell.Close_IMG.hidden=YES;
        cell.Plush_BTN.tag=indexPath.row;
        cell.Minush_BTN.tag=indexPath.row;
        
        
        cell.RestQuatityLBL.text=[[MainCount objectAtIndex:tableView.tag] objectAtIndex:indexPath.row];
        cell.TitleTriling.constant=0;
        
        
//        NSInteger *Main=[[[MainDic valueForKey:@"MainCount"] objectAtIndex:indexPath.row] integerValue];
//        
//        NSInteger *Second=[[[dic valueForKey:@"Count"] objectAtIndex:indexPath.row] integerValue];
//        
//        if (Main==Second)
//        {
//            cell.RestQuatityLBL.text=[NSString stringWithFormat:@"%ld",Main];
//        }
//        else
//        {
//            cell.RestQuatityLBL.text=[NSString stringWithFormat:@"%ld",Second];
//        }
        
        [cell.AddCart_BTN addTarget:self action:@selector(AddToCardClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.AddCart_BTN.tag=indexPath.row;
        NSLog(@"ddd===%ld",(long)indexPath.row);
        
        [cell.RestPlusBtn addTarget:self action:@selector(PlushClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.RestPlusBtn.tag=indexPath.row;
        [cell.RestMinuBTN addTarget:self action:@selector(MinushClick:) forControlEvents:UIControlEventTouchUpInside];
         cell.RestMinuBTN.tag=indexPath.row;
        
        LoadArr = [[arrData objectAtIndex:tableView.tag] mutableCopy];
        
        
        cell.Title_LBL.text=[[LoadArr valueForKey:@"name"] objectAtIndex:indexPath.row];
        
        
        cell.Price_LBL.text=[NSString stringWithFormat:@"$%@",[[LoadArr valueForKey:@"sell_price"] objectAtIndex:indexPath.row]];
        cell.Cat_LBL.text=[[LoadArr valueForKey:@"category"] objectAtIndex:indexPath.row];
        
        NSString *Urlstr=[[LoadArr valueForKey:@"image_path"] objectAtIndex:indexPath.row];
        Urlstr = [Urlstr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [cell.item_IMG sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
        [cell.item_IMG setShowActivityIndicatorView:YES];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
        {
            cell.preservesSuperviewLayoutMargins = NO;
        }
        cell.separatorInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, cell.bounds.size.width);
        if([cell respondsToSelector:@selector(setLayoutMargins:)])
        {
            cell.layoutMargins = UIEdgeInsetsZero;
        }
        
        if (indexPath.row == LoadArr.count-1)
        {
            cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
        }

        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
        cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.0f);
}

-(void)PlushClick:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    UIView *cellContentView = (UIView *)senderButton.superview;
    UITableViewCell *buttonCell = (UITableViewCell *)[[cellContentView superview] superview];
    UITableView* table = (UITableView *)[[buttonCell superview] superview];
    NSIndexPath* pathOfTheCell = [table indexPathForCell:buttonCell];
    //NSDictionary *item = sortedItems[sortedItems.allKeys[pathOfTheCell.row]];
    ProductDetailCell *cell = (ProductDetailCell *)[DataTable cellForRowAtIndexPath:pathOfTheCell];
    NSLog(@"senderButton.tag=%ld",(long)senderButton.tag);
    
    NSLog(@"Array===%@",[[MainCount objectAtIndex:pageTable] objectAtIndex:senderButton.tag]);
    
    NSInteger count = [[[MainCount objectAtIndex:pageTable] objectAtIndex:senderButton.tag] integerValue];
    count = count + 1;
    cell.RestQuatityLBL.text = [NSString stringWithFormat:@"%ld",(long)count];
    
    [[MainCount objectAtIndex:pageTable] replaceObjectAtIndex:senderButton.tag withObject:[NSString stringWithFormat:@"%ld",(long)count]];
    
    ButtonTag=senderButton.tag;
    chechPlusMinus=1;
    
    NSArray* subviews = [[NSArray alloc] initWithArray: TableScroll.subviews];
    for (UITableView* view in subviews)
    {
        if ([view isKindOfClass:[UITableView class]])
        {
            [view reloadData];
        }
    }    //[TableView reloadData];
    
}

-(void)MinushClick:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    UIView *cellContentView = (UIView *)senderButton.superview;
    UITableViewCell *buttonCell = (UITableViewCell *)[[cellContentView superview] superview];
    UITableView* table = (UITableView *)[[buttonCell superview] superview];
    NSIndexPath* pathOfTheCell = [table indexPathForCell:buttonCell];
    //NSDictionary *item = sortedItems[sortedItems.allKeys[pathOfTheCell.row]];
    ProductDetailCell *cell = (ProductDetailCell *)[DataTable cellForRowAtIndexPath:pathOfTheCell];
    
    NSInteger count = [[[MainCount objectAtIndex:pageTable] objectAtIndex:senderButton.tag] integerValue];
    count = count - 1;
    if (count!=0)
    {
        cell.RestQuatityLBL.text = [NSString stringWithFormat:@"%ld",(long)count];
        [[MainCount objectAtIndex:pageTable] replaceObjectAtIndex:senderButton.tag withObject:[NSString stringWithFormat:@"%ld",(long)count]];
        ButtonTag=senderButton.tag;
        chechPlusMinus=0;
       
    }
    NSArray* subviews = [[NSArray alloc] initWithArray: TableScroll.subviews];
    for (UITableView* view in subviews)
    {
        if ([view isKindOfClass:[UITableView class]])
        {
            [view reloadData];
        }
    }
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


-(void)checkLoginAndPresentContainer
{
    LoginView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginView"];
    [self.navigationController  pushViewController:vcr animated:YES];
}

-(void)AddToCardClick:(id)sender
{
    NSArray *LoadArr2 = [[arrData objectAtIndex:pageTable] mutableCopy];
    NSLog(@"===%@",[LoadArr2 objectAtIndex: [sender tag]]);
     NSLog(@"ID===%@",[[LoadArr2 objectAtIndex: [sender tag]] valueForKey:@"id"]);
    
    NSArray *QTYARR= [[MainCount objectAtIndex:pageTable] mutableCopy];
    
    if ([self.appDelegate isUserLoggedIn] == NO)
    {
        [self performSelector:@selector(checkLoginAndPresentContainer) withObject:nil afterDelay:0.0];
    }
    else
    {
       // UIButton *senderButton = (UIButton *)sender;//RestraorntDic
        
        NSMutableDictionary *UserData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
              
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
        {
            NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] init];
            [dictParams setObject:r_p  forKey:@"r_p"];
            [dictParams setObject:AddToCardServiceName  forKey:@"service"];
            [dictParams setObject:[UserData valueForKey:@"u_id"] forKey:@"uid"];
            [dictParams setObject:[RestraorntDic valueForKey:@"id"]  forKey:@"rid"];
            [dictParams setObject:[[LoadArr2 objectAtIndex: [sender tag]] valueForKey:@"id"]  forKey:@"pid"];
            [dictParams setObject:[QTYARR objectAtIndex: [sender tag]]  forKey:@"qty"];
            
            QUANTITYCOUNT=[QTYARR objectAtIndex: [sender tag]];
            
            [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,AddToCard_url] withParam:dictParams withCompletion:^(NSDictionary *response, BOOL success1)
             {
                 [self handleAddToCardResponse:response];
             }];
        }
        else
            [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
        
    }
}

- (void)handleAddToCardResponse:(NSDictionary*)response
{
    
    NSLog(@"add to cart Response=%@",response);
    
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
         NSString *TotalQTY=[response objectForKey:@"cart_item"];
        
        [[NSUserDefaults standardUserDefaults] setObject:TotalQTY forKey:@"QUANTITYCOUNT"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSString *message = [response objectForKey:@"ack_msg"];
        
        UIAlertView *toast = [[UIAlertView alloc] initWithTitle:AlertTitleError
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil, nil];
        [toast show];
        
        float duration = 2.5; // duration in seconds
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [toast dismissWithClickedButtonIndex:0 animated:YES];
        });
        
        NSString *savedQTY = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"QUANTITYCOUNT"];
        NSLog(@"savedQTY=%@",savedQTY);
        if (savedQTY)
        {
            if ([savedQTY integerValue]==0)
            {
                [QTYICON_LBL setHidden:YES];
                Back_BTN.hidden=YES;
                self.MapPlaceIMG.hidden=YES;
                self.CartIMG.hidden=YES;
            }
            else
            {
                Back_BTN.hidden=NO;
                QTYICON_LBL.hidden=NO;
                self.MapPlaceIMG.hidden=NO;
                self.CartIMG.hidden=NO;
                QTYICON_LBL.text=savedQTY;
            }
        }
        else
        {
            [QTYICON_LBL setHidden:YES];
        }
        
    }
    else
    {
        //[AppDelegate showErrorMessageWithTitle:AlertTitleError message:[response objectForKey:@"ack_msg"] delegate:nil];
        NSString *message = [response objectForKey:@"ack_msg"];
        
        UIAlertView *toast = [[UIAlertView alloc] initWithTitle:AlertTitleError
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil, nil];
        [toast show];
        
        float duration = 2.5; // duration in seconds
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [toast dismissWithClickedButtonIndex:0 animated:YES];
        });
    }
    
}
-(NSString *)Quantity_Count:(NSString *)count
{
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"QUANTITYCOUNT"];
    NSInteger TempAdd=0;
    NSString *finalVAL;
    if (savedValue)
    {
        TempAdd=[savedValue integerValue]+[count integerValue];
        finalVAL=[NSString stringWithFormat:@"%d",TempAdd];
    }
    else
    {
         finalVAL=[NSString stringWithFormat:@"%@",count];
    }
    
    return finalVAL;
}
- (IBAction)Cart_Click:(id)sender
{
    if ([self.appDelegate isUserLoggedIn] == NO)
    {
        [self performSelector:@selector(checkLoginAndPresentContainer) withObject:nil afterDelay:0.0];
    }
    else
    {
        ShoppingCartView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ShoppingCartView"];
        [self.navigationController pushViewController:vcr animated:YES];
    }
}


- (IBAction)ReviewBtn_Click:(id)sender
{
    
    RateView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateView"];
    
    vcr.Rest_ID=[NSString stringWithFormat:@"%@",[RestraorntDic valueForKey:@"id"]];
    NSLog(@"restid=%@",[RestraorntDic valueForKey:@"id"]);
    [self.navigationController pushViewController:vcr animated:YES];
}

- (IBAction)Map_Click:(id)sender
{
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        [locationManager requestWhenInUseAuthorization];
        [locationManager startUpdatingLocation];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
}
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    [AppDelegate showErrorMessageWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    if (currentLocation != nil) {
        
        NSString *coordinateString1 = [NSString stringWithFormat:@"%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude];
        
        NSString *coordinateString2 = [NSString stringWithFormat:@"%@,%@",ResLat,ResLog];
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]])
        {
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?saddr=%@&daddr=%@",coordinateString1,coordinateString2]]];
        }
        else
        {
            NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%@&daddr=%@",coordinateString1,coordinateString2]];
            if ([[UIApplication sharedApplication] canOpenURL:URL])
            {
                [[UIApplication sharedApplication] openURL: URL];
            }
            NSLog(@"Can't use comgooglemaps://");
        }
        
        NSLog(@"longitude=%.8f",currentLocation.coordinate.longitude);
        NSLog(@"latitude=%.8f",currentLocation.coordinate.latitude);
    }
    [locationManager stopUpdatingLocation];
    locationManager=nil;
}
- (IBAction)Back_Click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)ReviewCount:(NSString*)stars
{
    NSLog(@"stars=%@",stars);
    
    if ([stars integerValue]<=5)
    {
        if ([stars integerValue]==0) {
            _star1.image=[UIImage imageNamed:@"DisableWhiteStar"];
            _star2.image=[UIImage imageNamed:@"DisableWhiteStar"];
            _star3.image=[UIImage imageNamed:@"DisableWhiteStar"];
            _star4.image=[UIImage imageNamed:@"DisableWhiteStar"];
            _star5.image=[UIImage imageNamed:@"DisableWhiteStar"];
        }
        if ([stars integerValue]==1) {
            _star1.image=[UIImage imageNamed:@"WhiteStat"];
            _star2.image=[UIImage imageNamed:@"DisableWhiteStar"];
            _star3.image=[UIImage imageNamed:@"DisableWhiteStar"];
            _star4.image=[UIImage imageNamed:@"DisableWhiteStar"];
            _star5.image=[UIImage imageNamed:@"DisableWhiteStar"];
        }
        if ([stars integerValue]==2) {
            _star1.image=[UIImage imageNamed:@"WhiteStat"];
            _star2.image=[UIImage imageNamed:@"WhiteStat"];
            _star3.image=[UIImage imageNamed:@"DisableWhiteStar"];
            _star4.image=[UIImage imageNamed:@"DisableWhiteStar"];
            _star5.image=[UIImage imageNamed:@"DisableWhiteStar"];
        }
        if ([stars integerValue]==3) {
            _star1.image=[UIImage imageNamed:@"WhiteStat"];
            _star2.image=[UIImage imageNamed:@"WhiteStat"];
            _star3.image=[UIImage imageNamed:@"WhiteStat"];
            _star4.image=[UIImage imageNamed:@"DisableWhiteStar"];
            _star5.image=[UIImage imageNamed:@"DisableWhiteStar"];
        }
        if ([stars integerValue]==4) {
            _star1.image=[UIImage imageNamed:@"WhiteStat"];
            _star2.image=[UIImage imageNamed:@"WhiteStat"];
            _star3.image=[UIImage imageNamed:@"WhiteStat"];
            _star4.image=[UIImage imageNamed:@"WhiteStat"];
            _star5.image=[UIImage imageNamed:@"DisableWhiteStar"];
        }
        if ([stars integerValue]==5) {
            _star1.image=[UIImage imageNamed:@"WhiteStat"];
            _star2.image=[UIImage imageNamed:@"WhiteStat"];
            _star3.image=[UIImage imageNamed:@"WhiteStat"];
            _star4.image=[UIImage imageNamed:@"WhiteStat"];
            _star5.image=[UIImage imageNamed:@"WhiteStat"];
        }
    }
}

@end
