//
//  ViewController.m
//  SwipewithTableHeader
//
//  Created by BacancyMac-i7 on 12/09/16.
//  Copyright © 2016 BacancyMac-i7. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIPageControl *pageControl;
    UIImageView *ImgVW;
    CGFloat screenWidth;
    NSMutableArray *arrData;
    int pageTable;
    UITableView *DataTable;
}
@end

@implementation ViewController
@synthesize MainScroll;
@synthesize ImgScroll,ImgScrollWidth;
@synthesize TabScroll,TableScroll;

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    [self settabscroll:3];
    [self Settable];
    
    
}

-(void)viewWillLayoutSubviews
{
    [self Setimagesroll];
    [self.view layoutIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated{
    pageControl = [[UIPageControl alloc] init];
    [MainScroll addSubview:pageControl];

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
                    [subview setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
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
                subview.backgroundColor=[UIColor redColor];
            }
            else
            {
                subview.backgroundColor=[UIColor whiteColor];
            }
        }
    }
   
}


-(void)Setimagesroll
{
    int x=0;
    for (int i=0; i<3; i++)
    {
        ImgVW=[[UIImageView alloc]initWithFrame:CGRectMake(x, 0, screenWidth, 250)];
        ImgVW.image=[UIImage imageNamed:@"main_900.jpg"];
        [ImgScroll addSubview:ImgVW];
        
        x=x+screenWidth;
    }
    ImgScrollWidth.constant=x-screenWidth;
    
    pageControl.frame = CGRectMake(0,ImgVW.frame.size.height-30,screenWidth,5);
    pageControl.numberOfPages =3;
    pageControl.currentPage = 0;
    
}

-(void)settabscroll:(NSInteger)itemCount
{
    float wdi=screenWidth/itemCount;
    
    int x=0;
    for (int i=0; i<itemCount; i++)
    {
        UIButton *BTN=[[UIButton alloc]initWithFrame:CGRectMake(x, 0, wdi-2, 40)];
        [BTN setTitle:[NSString stringWithFormat:@"Title %d",i] forState:UIControlStateNormal];
        BTN.backgroundColor=[UIColor clearColor];
        BTN.tag=i;
        [BTN addTarget:self action:@selector(BTN_Click:) forControlEvents:UIControlEventTouchUpInside];
        [BTN setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [TabScroll addSubview:BTN];
        
        UILabel *LineLBL=[[UILabel alloc]initWithFrame:CGRectMake(x, 45, wdi-2, 5)];
        if (i==0)
        {
            LineLBL.backgroundColor=[UIColor redColor];
        }
        else
        {
            LineLBL.backgroundColor=[UIColor whiteColor];
        }
        LineLBL.tag=i;
        [TabScroll addSubview:LineLBL];
        x=x+wdi+1;
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
}

-(void)BTN_Click:(UIButton *)sender
{
    for (UIButton *subview in [TabScroll subviews])
    {
        if([subview isKindOfClass:[UIButton class]])
        {
            if (subview.tag==sender.tag)
            {
                [subview setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
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
                subview.backgroundColor=[UIColor redColor];
            }
            else
            {
                subview.backgroundColor=[UIColor whiteColor];
            }
        }
    }
    [self scrollToPage:sender.tag];
}

-(void)scrollToPage:(NSInteger)aPage
{
    float myPageWidth = [TableScroll frame].size.width;
    [TableScroll setContentOffset:CGPointMake(aPage*myPageWidth,0) animated:YES];
}


-(void)Settable
{
    NSArray *arr1 = [[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20", nil];
    NSArray *arr2 = [[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20", nil];
    NSArray *arr3 = [[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20", nil];
    arrData = [[NSMutableArray alloc] initWithObjects:arr1,arr2,arr3, nil];
    int width=0;
    for (int i = 0; i<[arrData count]; i++)
    {
        DataTable = [[UITableView alloc] initWithFrame:CGRectMake(width, 0, screenWidth, 600) style:UITableViewStylePlain];
        
        DataTable.tag=i;
        DataTable.dataSource = self;
        DataTable.delegate = self;
        [DataTable setBackgroundColor:[UIColor clearColor]];
        DataTable.separatorColor = [UIColor blackColor];
        [TableScroll addSubview:DataTable];
        width+=screenWidth;
    }
    
    [TableScroll setContentSize:CGSizeMake(([arrData count])*screenWidth, TableScroll.frame.size.height)];
}

#pragma mark
#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = [arrData objectAtIndex:section];
    
    return arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    // This will create a "invisible" footer
    return 0.01f;
}

// Customize the appearance of table view cells.
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.accessoryView = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSArray *arr = [arrData objectAtIndex:tableView.tag];
    
    cell.textLabel.text = [arr objectAtIndex:indexPath.row];
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:20];
    cell.textLabel.font = font;
    
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
