//
//  myAnnotation.h
//  MapView
//
//  Created by dev27 on 5/30/13.
//  Copyright (c) 2013 codigator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface myAnnotation : MKAnnotationView
{
    
}

@property (strong, nonatomic)  NSString *AnnotationRest_IMG;
@property (strong, nonatomic)  NSString *AnnotationRestNAME_LBL;
@property (strong, nonatomic)  NSString *AnnotationDesc_LBL;
@property (strong, nonatomic)  NSString *AnnotationItem_LBL;
@property (strong, nonatomic)  NSString *AnnotationReview_LBL;
@property (strong, nonatomic)  NSString *AnnotationDistance;
@property (strong, nonatomic)  NSString *AnnotationRestPINCODE;
@property (strong, nonatomic)  NSString *AnnotationRest_ID;


@property (strong, nonatomic)  NSString *AnnotationStar;
@property (strong, nonatomic) UIButton *AnnotationDistance_BTN;
@property(strong ,nonatomic)UIImage *userimage;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle image:(UIImage *)userimage;
-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate AnnotationRest_IMG:(NSString *)Rest_IMG AnnotationRestNAME_LBL:(NSString *)RestNAME_LBL AnnotationDesc_LBL:(NSString *)Desc AnnotationItem_LBL:(NSString *)Item_LBL AnnotationReview_LBL:(NSString *)Review_LBL AnnotationStar:(NSString *)Star AnnotationDistance:(NSString *)distance AnnotationRestPINCODE:(NSString *)ID AnnotationRestPINCODE:(NSString *)PIN;


@property (strong, nonatomic) IBOutlet UIImageView *Rest_IMG;
@property (strong, nonatomic) IBOutlet UILabel *RestNAME_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Desc_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Item_LBL;
@property (strong, nonatomic) IBOutlet UILabel *Review_LBL;

@property (weak, nonatomic) IBOutlet UIImageView *Star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;

-(void)ReviewCount:(NSString*)stars;
@property (strong, nonatomic) IBOutlet UIButton *Distance_BTN;

- (IBAction)MainBTN_Click:(id)sender;
@end
