//
//  DrivingViewController.h
//  Pothole Chicago
//
//  Created by Guest Account on 3/31/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DrivingViewController : UIViewController <MKMapViewDelegate, MKAnnotation, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)findCurrentLocation:(id)sender;

@end
