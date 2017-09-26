//
//  MapNearbyPlace.m
//  Halal Meat Delivery
//
//  Created by kaushik on 21/08/16.
//  Copyright © 2016 kaushik. All rights reserved.
//

#import "MapNearbyPlace.h"
#import "MapCellView.h"
#import <CoreLocation/CoreLocation.h>
#import "UIImageView+WebCache.h"
#import "myAnnotation.h"
#import "RestaurantDetailView.h"

//@interface DXAnnotation : NSObject <MKAnnotation>

//@property(nonatomic, assign) CLLocationCoordinate2D coordinate;

//@end

@interface MapNearbyPlace ()<CLLocationManagerDelegate,UIAlertViewDelegate>
{
    NSMutableArray *LatArr,*LogArr;
    CLLocationManager *locationManager;
    NSMutableDictionary *MainDic;
    myAnnotation *myAnno;
    NSString *Rest_ID,*Rest_PIN;
    MKAnnotationView *annotationView;

}
@property AppDelegate *appDelegate;
@property (strong, nonatomic) UIButton *DistBTN;
@end

@implementation MapNearbyPlace
@synthesize MapView,DistBTN;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTestNotification:) name:@"TestNotification" object:nil];

    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager requestWhenInUseAuthorization];

    [locationManager startUpdatingLocation];
    NearbydictParams=[[NSMutableDictionary alloc]init];
  
    

    self.appDelegate = [AppDelegate sharedInstance];
    
    //LatArr=[NSMutableArray arrayWithObjects:@"12.9667",@"44.518640",@"44.521318",@"44.500746",@"44.490537",@"44.504082", nil];
   // LogArr=[NSMutableArray arrayWithObjects:@"77.5667",@"11.362665",@"11.374080",@"11.345394",@"11.358033",@"11.354256", nil];
   
   
}
-(void)CallForLoction
{
    
    NSLog(@"NearbydictParams==%@",NearbydictParams);
    [CommonWS AAwebserviceWithURL:[NSString stringWithFormat:@"%@%@",BaseUrl,Nearbyrestorant_url] withParam:NearbydictParams withCompletion:^(NSDictionary *response, BOOL success1)
     {
         [self handleNearLocationResponse:response];
     }];
}

- (void)handleNearLocationResponse:(NSDictionary*)response
{
    //NSLog(@"mapdata==%@",response);
    if ([[[response objectForKey:@"ack"]stringValue ] isEqualToString:@"1"])
    {
        MainDic=[response valueForKey:@"result"];
        [self loadMapPins];
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:@"Alert..!" message:@"No Shops Found." delegate:nil];
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

- (IBAction)Menu_click:(id)sender
{
    [self.rootNav drawerToggle];
}

- (void)loadMapPins
{
    
    if (MainDic.count==0)
    {
        [AppDelegate showErrorMessageWithTitle:@"" message:@"THERE IS NO SHOPS NEAR BY YOU." delegate:nil];
    }
    
    for (int i=0; i<MainDic.count; i++)
    {
        double latitude = [[[MainDic valueForKey:@"latitude"] objectAtIndex:i] doubleValue];
        double longitude = [[[MainDic valueForKey:@"longitude"] objectAtIndex:i] doubleValue];
        myAnno=[[myAnnotation alloc] init];
        
        CLLocationCoordinate2D theCoordinate1;
        theCoordinate1.latitude = latitude;
        theCoordinate1.longitude = longitude;
        
        myAnno.coordinate=theCoordinate1;
        myAnno.AnnotationRest_IMG=[[MainDic valueForKey:@"image_path"] objectAtIndex:i];
        
        myAnno.AnnotationRestNAME_LBL=[[MainDic valueForKey:@"name"] objectAtIndex:i];
        
        myAnno.AnnotationItem_LBL=[[MainDic valueForKey:@"serving_category"] objectAtIndex:i];
        
        myAnno.AnnotationDesc_LBL=[[MainDic valueForKey:@"address"] objectAtIndex:i];
        
        myAnno.AnnotationReview_LBL=[NSString stringWithFormat:@"(%@ Review)",[[MainDic valueForKey:@"count_review"] objectAtIndex:i]];
        
        myAnno.AnnotationStar=[NSString stringWithFormat:@"%@",[[MainDic valueForKey:@"rate"] objectAtIndex:i]];
        
        myAnno.AnnotationDistance=[NSString stringWithFormat:@"%@",[[MainDic valueForKey:@"distance"] objectAtIndex:i]];
        
        myAnno.AnnotationRestPINCODE=[NSString stringWithFormat:@"%@",[[MainDic valueForKey:@"pin"] objectAtIndex:i]];
        myAnno.AnnotationRest_ID=[NSString stringWithFormat:@"%@",[[MainDic valueForKey:@"id"] objectAtIndex:i]];

        
        [MapView addAnnotation:myAnno];
        theCoordinate1=CLLocationCoordinate2DMake(latitude, longitude);
        [MapView setRegion:MKCoordinateRegionMakeWithDistance(myAnno.coordinate, 500, 500)];
        //      [MainMapview setRegion:region animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"click");
    if(![view.annotation isKindOfClass:[MKUserLocation class]])
    {
        
        NSLog(@"click11");
        
        myAnnotation *calloutView = (myAnnotation *)[[[NSBundle mainBundle] loadNibNamed:@"myView" owner:self options:nil] objectAtIndex:0];
        CGRect calloutViewFrame = calloutView.frame;
        calloutViewFrame.origin = CGPointMake(-calloutViewFrame.size.width/2 + 15, -calloutViewFrame.size.height);
        calloutView.frame = calloutViewFrame;
        [calloutView.Rest_IMG sd_setImageWithURL:[NSURL URLWithString:[(myAnnotation*)[view annotation]AnnotationRest_IMG]] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
        [calloutView.Rest_IMG setShowActivityIndicatorView:YES];
        [calloutView.RestNAME_LBL setText:[(myAnnotation*)[view annotation] AnnotationRestNAME_LBL]];
        [calloutView.Desc_LBL setText:[(myAnnotation*)[view annotation] AnnotationDesc_LBL]];
        [calloutView.Item_LBL setText:[(myAnnotation*)[view annotation] AnnotationItem_LBL]];
        [calloutView.Review_LBL setText:[(myAnnotation*)[view annotation] AnnotationReview_LBL]];
        [calloutView ReviewCount:[(myAnnotation*)[view annotation] AnnotationStar]];
        [calloutView.Distance_BTN setTitle:[(myAnnotation*)[view annotation] AnnotationDistance] forState:UIControlStateNormal];
       
        Rest_ID=[(myAnnotation*)[view annotation] AnnotationRest_ID];
        Rest_PIN=[(myAnnotation*)[view annotation] AnnotationRestPINCODE];


        
        [view addSubview:calloutView];
        [mapView setCenterCoordinate:[(myAnnotation*)[view annotation] coordinate]];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    static NSString *identifier = @"myAnnotation";
    myAnnotation *Annoc = (myAnnotation *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (annotation !=nil)
    {
        Annoc = [[myAnnotation alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        Annoc.image = [UIImage imageNamed:@"pin"];
        Annoc.annotation = annotation;
        
    }
    return Annoc;
}


-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    for (UIView *subview in view.subviews)
    {
        
        [subview removeFromSuperview];
    }
    
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
        
        [NearbydictParams setObject:r_p  forKey:@"r_p"];
        [NearbydictParams setObject:Nearby_restorantsServiceName  forKey:@"service"];
        [NearbydictParams setObject:[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]  forKey:@"lat"];
        [NearbydictParams setObject:[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]  forKey:@"long"];
        //[NearbydictParams setObject:@"22.274051"  forKey:@"lat"];
        //[NearbydictParams setObject:@"70.757931"  forKey:@"long"];
        UIAlertView *alert;
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
        {
            [self performSelector:@selector(CallForLoction) withObject:nil afterDelay:0.0];
        }
        else
            [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
        

        
        
        NSLog(@"longitude=%.8f",currentLocation.coordinate.longitude);
        NSLog(@"latitude=%.8f",currentLocation.coordinate.latitude);
    }
     [locationManager stopUpdatingLocation];
    locationManager=nil;
}

#pragma mark - photoShotSavedDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection = %li", (long)selectionIndex);
    
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        RestaurantDetailView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RestaurantDetailView"];
        
        vcr.R_ID=Rest_ID;
        vcr.Pin=Rest_PIN;
        [self.navigationController pushViewController:vcr animated:YES];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
   
}


@end
