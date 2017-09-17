//
//  ViewController.h
//  SwipewithTableHeader
//
//  Created by BacancyMac-i7 on 12/09/16.
//  Copyright © 2016 BacancyMac-i7. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    
}
@property (strong, nonatomic) IBOutlet UIScrollView *ImgScroll;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ImgScrollWidth;

@property (strong, nonatomic) IBOutlet UIScrollView *TabScroll;


@property (strong, nonatomic) IBOutlet UIScrollView *TableScroll;
@property (strong, nonatomic) IBOutlet UIScrollView *MainScroll;

@end

