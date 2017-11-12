/*
 * Copyright (c) 2012 Mario Negro Martín
 * 
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 
 */

#import "MNMBottomPullToRefreshManager22.h"
#import "MNMBottomPullToRefreshView22.h"

CGFloat const kAnimationDurationtab = 0.2f;

@interface MNMBottomPullToRefreshManager22()


@property (nonatomic, readwrite, strong) MNMBottomPullToRefreshView22 *pullToRefreshView;


@property (nonatomic, readwrite, weak) UITableView *table;

@property (nonatomic, readwrite, weak) id<MNMBottomPullToRefreshManager22Client> clients;


- (CGFloat)tableScrollOffset;

@end

@implementation MNMBottomPullToRefreshManager22

@synthesize pullToRefreshView = pullToRefreshView_;
@synthesize table = table_;
@synthesize clients = client_;

#pragma mark -
#pragma mark Instance initialization


- (id)initWithPullToRefreshViewHeight:(CGFloat)height tableView:(UITableView *)table withClient:(id<MNMBottomPullToRefreshManager22Client>)client {

    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidths = screenSize.width;
    
    if (self = [super init])
    {
        
        client_ = client;
        table_ = table;        
        pullToRefreshView_ = [[MNMBottomPullToRefreshView22 alloc] initWithFrame:CGRectMake(0.0f, 0.0f, screenWidths, height)];
    }
    
    return self;
}

#pragma mark -
#pragma mark Visuals

- (CGFloat)tableScrollOffset {
    
    CGFloat offset = 0.0f;        
    
    if ([table_ contentSize].height < CGRectGetHeight([table_ frame])) {
        
        offset = -[table_ contentOffset].y;
        
    } else {
        
        offset = ([table_ contentSize].height - [table_ contentOffset].y) - CGRectGetHeight([table_ frame]);
    }
    
    return offset;
}

- (void)relocatePullToRefreshView
{
    CGFloat yOrigin = 0.0f;
    if ([table_ contentSize].height >= CGRectGetHeight([table_ frame]))
    {
        yOrigin = [table_ contentSize].height;
    }
    else
    {
        yOrigin = CGRectGetHeight([table_ frame]);
    }
    
    CGRect frame = [pullToRefreshView_ frame];
    frame.origin.y = yOrigin;
    [pullToRefreshView_ setFrame:frame];
    
    [table_ addSubview:pullToRefreshView_];
}

- (void)setPullToRefreshViewVisible:(BOOL)visible {
    
    [pullToRefreshView_ setHidden:!visible];
}

#pragma mark -
#pragma mark Table view scroll management

- (void)tableViewScrolled {
    
    if (![pullToRefreshView_ isHidden] && ![pullToRefreshView_ isLoading]) {
        
        CGFloat offset = [self tableScrollOffset];

        if (offset >= 0.0f) {
            
            [pullToRefreshView_ changeStateOfControl:MNMBottomPullToRefreshView22StateIdle offset:offset];
            
        } else if (offset <= 0.0f && offset >= -[pullToRefreshView_ fixedHeight]) {
                
            [pullToRefreshView_ changeStateOfControl:MNMBottomPullToRefreshView22StatePull offset:offset];
            
        } else {
            
            [pullToRefreshView_ changeStateOfControl:MNMBottomPullToRefreshView22StateRelease offset:offset];
        }
    }
}

- (void)tableViewReleased {
    
    if (![pullToRefreshView_ isHidden] && ![pullToRefreshView_ isLoading]) {
        
        CGFloat offset = [self tableScrollOffset];
        CGFloat height = -[pullToRefreshView_ fixedHeight];
        
        if (offset <= 0.0f && offset < height) {
            
            [client_ bottomPullToRefreshTriggered:self];
            
            [pullToRefreshView_ changeStateOfControl:MNMBottomPullToRefreshView22StateLoading offset:offset];
            
            [UIView animateWithDuration:kAnimationDurationtab animations:^{
                
                if ([table_ contentSize].height >= CGRectGetHeight([table_ frame])) {
                
                    [table_ setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, -height, 0.0f)];
                    
                } else {
                    
                    [table_ setContentInset:UIEdgeInsetsMake(height, 0.0f, 0.0f, 0.0f)];
                }
            }];
        }
    }
}

- (void)tableViewReloadFinished
{
    [table_ setContentInset:UIEdgeInsetsZero];

    [self relocatePullToRefreshView];

    [pullToRefreshView_ changeStateOfControl:MNMBottomPullToRefreshView22StateIdle offset:CGFLOAT_MAX];
}

@end