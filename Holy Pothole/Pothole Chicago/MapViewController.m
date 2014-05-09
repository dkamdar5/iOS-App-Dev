//
//  MapViewController.m
//  Pothole Chicago
//
//  Created by Guest Account on 3/11/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "MapViewController.h"
#import "MyAnnotation.h"
#import "DrivingLogViewController.h"
#import "AppDelegate.h"

@interface MapViewController ()
{
    CLLocationCoordinate2D coordinate;
    CLGeocoder *geocoder;
    CLPlacemark *_placemark;
    NSDictionary *_address;
    AppDelegate *app;
}
@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	//Adds long press gesture recognizer
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self.mapView addGestureRecognizer:lpgr];
    
    //other setup
    //self.annotations = [[NSMutableArray alloc] init];
    app = [UIApplication sharedApplication].delegate;
    _placemark = [[CLPlacemark alloc] init];
    _address = [[NSDictionary alloc] init];
    [UIView animateWithDuration:2.0 animations:^{
        [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView addAnnotations:app.annotations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Detects touch to UIView and makes the keyboard dissappear
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
    [self.mapView becomeFirstResponder];
    [self.textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //dismiss keyboard on return key press
    //[self.view endEditing:YES];
    [self.textField resignFirstResponder];
    [self.mapView becomeFirstResponder];
    
    //perform search
    //[self search:textField.text];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    //[self search:textField.text];
}

-(void)search:(NSString *)searchQuery
{
    MKLocalSearchRequest *searchRequest = [[MKLocalSearchRequest alloc] init];
    searchRequest.naturalLanguageQuery = searchQuery;
    searchRequest.region = self.mapView.region;
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:searchRequest];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        NSMutableArray *placemarks = [NSMutableArray array];
        for (MKMapItem *item in response.mapItems) {
            [placemarks addObject:item.placemark];
        }
        [self.mapView removeAnnotations:[self.mapView annotations]];
        [self.mapView showAnnotations:placemarks animated:NO];
    }];
}

//http://jonathanfield.me/mkmapview-adding-pins-map-showing-annotations/


- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    //get coordinate
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    //CLLocation *loc = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    //[self search:self.textField.text];
    //create and set annotation details
    MyAnnotation *annotation1 = [[MyAnnotation alloc] init];
    [annotation1 setCoordinate:touchMapCoordinate];
    [annotation1 setTitle:[NSString stringWithFormat:@"Pothole %d", (app.annotations.count+1)]];
    //[self geocodeLocation:loc forAnnotation:annotation1];
    [annotation1 setSubtitle:[_address objectForKey:@"street"]];
    [app.annotations addObject:annotation1];
//    for (id annotation in self.mapView.annotations) {
//        [self.mapView removeAnnotation:annotation];
//    }
    [self.mapView addAnnotations:app.annotations];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.mapView removeAnnotations:app.annotations];
    if([[segue identifier] isEqualToString:@"Option"])
    {
        
    }else{
        //[[segue destinationViewController] setAnnotations:self.annotations];
    }
}

-(IBAction)findCurrentLocation:(id)sender
{
    //zoom and center to current location
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}

//- (void)geocodeLocation:(CLLocation*)location forAnnotation:(MyAnnotation *)annotation
//{
//    if (!geocoder)
//        geocoder = [[CLGeocoder alloc] init];
//    [geocoder reverseGeocodeLocation:location completionHandler:
//     ^(NSArray* placemarks, NSError* error){
//         if ([placemarks count] > 0)
//         {
//             CLPlacemark *placemark = [placemarks objectAtIndex:0];
//             _address = [placemark addressDictionary];
//             
//             // Add a More Info button to the annotation's view.
////             MKPinAnnotationView* view = (MKPinAnnotationView*)[self.mapView viewForAnnotation:annotation];
////             if (view && (view.rightCalloutAccessoryView == nil))
////             {
////                 view.canShowCallout = YES;
////                 view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
////             }
//         }
//     }];
//}
@end
