//
//  MapViewController.m
//  Pothole Chicago
//
//  Created by Guest Account on 3/11/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "MapViewController.h"
#import "MyAnnotation.h"

@interface MapViewController ()
{
    CLLocationCoordinate2D coordinate;
    NSMutableArray *annotations;
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
    annotations = [[NSMutableArray alloc] init];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}

- (IBAction)showCurrentLocation:(id)sender {
    //zoom and center to current location
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}

//http://jonathanfield.me/mkmapview-adding-pins-map-showing-annotations/


- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    //get coordinate
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    //CLLocation *loc = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    
    //create and set annotation details
    MyAnnotation *annotation1 = [[MyAnnotation alloc] init];
    [annotation1 setCoordinate:touchMapCoordinate];
    [annotation1 setTitle:[NSString stringWithFormat:@"Pothole %d", (annotations.count+1)]];
    [annotation1 setSubtitle:@"Watch Out!"];
    [annotations addObject:annotation1];
//    for (id annotation in self.mapView.annotations) {
//        [self.mapView removeAnnotation:annotation];
//    }
    [self.mapView addAnnotations:annotations];
}

@end
