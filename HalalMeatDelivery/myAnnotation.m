//
//  myAnnotation.m
//  MapView
//
//  Created by dev27 on 5/30/13.
//  Copyright (c) 2013 codigator. All rights reserved.
//

#import "myAnnotation.h"

@implementation myAnnotation
-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate AnnotationRest_IMG:(NSString *)Rest_IMG AnnotationRestNAME_LBL:(NSString *)RestNAME_LBL AnnotationDesc_LBL:(NSString *)Desc AnnotationItem_LBL:(NSString *)Item_LBL AnnotationReview_LBL:(NSString *)Review_LBL AnnotationStar:(NSString *)Star AnnotationDistance:(NSString *)distance AnnotationRestPINCODE:(NSString *)ID AnnotationRestPINCODE:(NSString *)PIN;
{
    if ((self = [super init]))
    {
        if ((self = [super init]))
        {
            self.AnnotationRest_IMG=Rest_IMG;
            self.AnnotationRestNAME_LBL=RestNAME_LBL;
            self.AnnotationDesc_LBL=Desc;
            self.AnnotationItem_LBL=Item_LBL;
            self.AnnotationReview_LBL=Review_LBL;
            self.AnnotationStar=Star;
            self.AnnotationDistance=distance;
            self.AnnotationRest_ID=ID;
            self.AnnotationRestPINCODE=PIN;
            NSLog(@"Rest_IMG=%@",Rest_IMG);
        }
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    _Distance_BTN.layer.cornerRadius=5;
    _Distance_BTN.layer.masksToBounds=YES;
    _Distance_BTN.layer.borderColor=[[UIColor colorWithRed:224.0f/255.0f green:66.0f/255.0f blue:66.0f/255.0f alpha:1.0] CGColor];
    _Distance_BTN.layer.borderWidth=1;
    
    // Initialization code
}
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView* v = [super hitTest:point withEvent:event];
    if (v != nil)
    {
        [self.superview bringSubviewToFront:self];
    }
    return v;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect rec = self.bounds;
    BOOL isIn = CGRectContainsPoint(rec, point);
    if(!isIn)
    {
        for (UIView *v in self.subviews)
        {
            isIn = CGRectContainsPoint(v.frame, point);
            if(isIn)
                break;
        }
    }
    return isIn;
}

- (IBAction)MainBTN_Click:(id)sender
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"TestNotification"
     object:self];
}

-(void)ReviewCount:(NSString*)stars
{
    NSLog(@"stars=%@",stars);
    
    if ([stars integerValue]<=5)
    {
        if ([stars integerValue]==0) {
            self.Star1.image=[UIImage imageNamed:@"HalStar"];
            self.star2.image=[UIImage imageNamed:@"HalStar"];
            self.star3.image=[UIImage imageNamed:@"HalStar"];
            self.star4.image=[UIImage imageNamed:@"HalStar"];
            self.star5.image=[UIImage imageNamed:@"HalStar"];
        }
        if ([stars integerValue]==1) {
            self.Star1.image=[UIImage imageNamed:@"FullStar"];
            self.star2.image=[UIImage imageNamed:@"HalStar"];
            self.star3.image=[UIImage imageNamed:@"HalStar"];
            self.star4.image=[UIImage imageNamed:@"HalStar"];
            self.star5.image=[UIImage imageNamed:@"HalStar"];
        }
        if ([stars integerValue]==2) {
            self.Star1.image=[UIImage imageNamed:@"FullStar"];
            self.star2.image=[UIImage imageNamed:@"FullStar"];
            self.star3.image=[UIImage imageNamed:@"HalStar"];
            self.star4.image=[UIImage imageNamed:@"HalStar"];
            self.star5.image=[UIImage imageNamed:@"HalStar"];
        }
        if ([stars integerValue]==3) {
            self.Star1.image=[UIImage imageNamed:@"FullStar"];
            self.star2.image=[UIImage imageNamed:@"FullStar"];
            self.star3.image=[UIImage imageNamed:@"FullStar"];
            self.star4.image=[UIImage imageNamed:@"HalStar"];
            self.star5.image=[UIImage imageNamed:@"HalStar"];
        }
        if ([stars integerValue]==4) {
            self.Star1.image=[UIImage imageNamed:@"FullStar"];
            self.star2.image=[UIImage imageNamed:@"FullStar"];
            self.star3.image=[UIImage imageNamed:@"FullStar"];
            self.star4.image=[UIImage imageNamed:@"FullStar"];
            self.star5.image=[UIImage imageNamed:@"HalStar"];
        }
        if ([stars integerValue]==5) {
            self.Star1.image=[UIImage imageNamed:@"FullStar"];
            self.star2.image=[UIImage imageNamed:@"FullStar"];
            self.star3.image=[UIImage imageNamed:@"FullStar"];
            self.star4.image=[UIImage imageNamed:@"FullStar"];
            self.star5.image=[UIImage imageNamed:@"FullStar"];
        }
    }
}
@end
