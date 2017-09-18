//
//  SearchByCategoryView.h
//  HalalMeatDelivery
//
//  Created by Mango Software Lab on 26/08/2016.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HalalMeatDelivery.pch"
#import "TTRangeSlider.h"

@interface SearchByShop : UIViewController<CCKFNavDrawerDelegate,TTRangeSliderDelegate>
@property (strong, nonatomic) CCKFNavDrawer *rootNav;

@property (strong, nonatomic) IBOutlet UITableView *Table;

@property (strong, nonatomic) IBOutlet UIButton *Search_IMG;

- (IBAction)Search_Click:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *Searc_BTN;
@property (strong, nonatomic) IBOutlet UISearchBar *SearchBar;
- (IBAction)Menu_Click:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *Filter_BTN;
- (IBAction)Filter_click:(id)sender;


@property (strong, nonatomic) IBOutlet UIView *FilterView;
- (IBAction)FilterBack_Ckick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *SearchByCatBTN;
@property (strong, nonatomic) IBOutlet UIButton *SearchByPriceBTN;
@property (strong, nonatomic) IBOutlet UIButton *SearchByRatBTN;
@property (strong, nonatomic) IBOutlet UIButton *SearchByDistBTN;
@property (strong, nonatomic) IBOutlet UIButton *FreeDelevBTN;

@property (strong, nonatomic) IBOutlet UIView *PriceView;

- (IBAction)AllCatBTN_Click:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *CatTBL;
@property (weak, nonatomic) IBOutlet TTRangeSlider *rangeSliderCurrency;
- (IBAction)ConfrimFliterBtn_action:(id)sender;
- (IBAction)ClearFliterBtn_action:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *Title_LBL;

@end
