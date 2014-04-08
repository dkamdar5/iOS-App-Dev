//
//  MyAnnotation.h
//  Pothole Chicago
//
//  Creates an annotation for a pin to be used in a map.
//  It contains a coordinate, a title, and a subtitle.
//
//  Created by Guest User on 3/27/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject<MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
