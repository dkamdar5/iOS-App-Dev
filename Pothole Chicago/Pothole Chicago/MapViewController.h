//
//  MapViewController.h
//  Pothole Chicago
//
//  Created by Guest Account on 3/11/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController <MKMapViewDelegate, MKAnnotation, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;


@end
