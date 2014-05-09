//
//  DrivingViewController.m
//  Pothole Chicago
//
//  Created by Guest Account on 3/31/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "DrivingViewController.h"
#import "DrivingLogViewController.h"
#import "MyAnnotation.h"
#import "AppDelegate.h"

@interface DrivingViewController ()
{
    CLLocationCoordinate2D coordinate;
    CLLocationManager *locationManager;
    AppDelegate *app;
}
@end

@implementation DrivingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	//Adds tap press gesture recognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.mapView addGestureRecognizer:tap];
    
    //other setup
    [self.navigationItem setTitle:@"Back"];
    app = [UIApplication sharedApplication].delegate;
    self.mapView.delegate = self;
    [self showCurrentLocation];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView addAnnotations:app.annotations];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [locationManager stopUpdatingLocation];
    [super viewDidDisappear:animated];
}

-(void)handleTap:(UIGestureRecognizer *)gestureRecognizer
{
    //create a blank white view
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:whiteView aboveSubview:self.view]; //add it to view
    //flash screen and disappear 
    [UIView animateWithDuration: 1.0
                     animations: ^{
                         whiteView.alpha = 0.0;
                     }
                     completion: ^(BOOL finished) {
                         [whiteView removeFromSuperview];
                     }
     ];
    [self placePin];
}

-(void)placePin
{
    //create annotation
    MyAnnotation *annotation = [[MyAnnotation alloc] init];
    [annotation setCoordinate:coordinate];
    [annotation setTitle:[NSString stringWithFormat:@"Pothole %d", (app.annotations.count+1)]];
    [annotation setSubtitle:@"Watch Out!"];
    
    //add annotation to array and map
    [app.annotations addObject:annotation];
    [UIView animateWithDuration:0.5 animations:^{
        [self.mapView addAnnotations:app.annotations];}];
}

- (void)showCurrentLocation
{
    //set up location manager
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    //zoom and center to current location
    self.mapView.showsUserLocation = YES;
    [UIView animateWithDuration:2.0 animations:^{
        [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.mapView removeAnnotations:app.annotations];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        coordinate.longitude = currentLocation.coordinate.longitude;
        coordinate.latitude = currentLocation.coordinate.latitude;
    }
}
- (IBAction)findCurrentLocation:(id)sender {
    //zoom and center to current location
    self.mapView.showsUserLocation = YES;
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}
@end
