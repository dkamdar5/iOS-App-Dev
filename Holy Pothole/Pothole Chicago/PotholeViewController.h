//
//  PotholeViewController.h
//  Pothole Chicago
//
//  Created by Guest Account on 4/2/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PotholeViewController : UIViewController <NSURLConnectionDelegate, MKMapViewDelegate, MKAnnotation>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) NSMutableData *buffer;
@property (nonatomic, strong) NSURLConnection *myConnection;
@property (strong, nonatomic) NSMutableDictionary *dict;

@end
