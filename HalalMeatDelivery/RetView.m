//
//  RetView.m
//  HalalMeatDelivery
//
//  Created by kaushik on 10/09/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import "RetView.h"
#import <HCSStarRatingView/HCSStarRatingView.h>

@implementation RetView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    _Cancel_btn.layer.cornerRadius=5;
    _Cancel_btn.layer.masksToBounds=YES;
    
    _submit_btn.layer.cornerRadius=5;
    _submit_btn.layer.masksToBounds=YES;
   
    
    // Initialization code
}
- (IBAction)didChangeValue:(HCSStarRatingView *)sender {
    NSLog(@"Changed rating to %.1f", sender.value);
    
    if(sender.value==1.0)
    {
        self.Rate_LBL.text=@"Hate It";
    }
    else if(sender.value==2.0)
    {
        self.Rate_LBL.text=@"Disliked It";
    }
    else if(sender.value==3.0)
    {
        self.Rate_LBL.text=@"It's Ok";
    }
    else if(sender.value==4.0)
    {
        self.Rate_LBL.text=@"Liked It";
    }
    else if(sender.value==5.0)
    {
        self.Rate_LBL.text=@"Loved It";
    }
    else
    {
        self.Rate_LBL.text=@"Hate It";
    }
}

@end
