//
//  PotholeViewController.m
//  Pothole Chicago
//
//  Created by Guest Account on 4/2/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "PotholeViewController.h"
#import "MyAnnotation.h"

@interface PotholeViewController ()
{
    CLLocationCoordinate2D coordinate;
    NSMutableArray *annotations;
    CLLocationDegrees zoomLevel;
    BOOL loaded;
}

@end

@implementation PotholeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //other setup
    annotations = [[NSMutableArray alloc] init];
    zoomLevel = 100;
    loaded = NO;
    self.mapView.delegate = self;
    //[self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    // Animate the spinner
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    
    // Create the URL & URLRequest
    NSURL *myURL = [NSURL URLWithString:@"http://311api.cityofchicago.org/open311/v2/requests.json?status=open&page_size=500"];
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
    
    // Create the connection
    self.myConnection = [NSURLConnection connectionWithRequest:myRequest delegate:self];
    
    //Test to make sure the connection worked
    if (self.myConnection){
        self.buffer = [NSMutableData data];
        [self.myConnection start];
    }else{
        NSLog(@"Connection Failed");
    }
}

-(void)createPin:(NSString *)title andSubtitle:(NSString *)subtitle withLat:(NSString *)myLat withLong:(NSString *)myLong
{
    CLLocationDegrees latitude = [myLat doubleValue];
    CLLocationDegrees longitude = [myLong doubleValue];
    CLLocationCoordinate2D touchMapCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    //create and set annotation details
    MyAnnotation *annotation1 = [[MyAnnotation alloc] init];
    [annotation1 setCoordinate:touchMapCoordinate];
    //[annotation1 setTitle:[NSString stringWithFormat:@"Pothole %d", (annotations.count+1)]];
    //[annotation1 setSubtitle:@"Watch Out!"];
    [annotation1 setTitle:title];
    [annotation1 setSubtitle:subtitle];
    [annotations addObject:annotation1];
}

-(void)filterAnnotations{
    float latDelta=self.mapView.region.span.latitudeDelta/(640/10);
    float longDelta=self.mapView.region.span.longitudeDelta/(1136/10);
    
    NSMutableArray *shopsToShow=[[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i=0; i<[annotations count]; i++) {
        MyAnnotation *checkingLocation=[annotations objectAtIndex:i];
        CLLocationDegrees latitude = checkingLocation.coordinate.latitude;
        CLLocationDegrees longitude = checkingLocation.coordinate.longitude;
        
        bool found=FALSE;
        for (MyAnnotation *tempPlacemark in annotations) {
            if(fabs(tempPlacemark.coordinate.latitude-latitude) < latDelta &&
               fabs(tempPlacemark.coordinate.longitude-longitude) <longDelta ){
                [self.mapView removeAnnotation:checkingLocation];
                found=TRUE;
                break;
            }
        }
        if (!found) {
            [shopsToShow addObject:checkingLocation];
            [self.mapView addAnnotation:checkingLocation];
        }
        
    }
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
}

-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    loaded = YES;
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
//    if (loaded){
//        if (self.mapView.region.span.longitudeDelta)
//        {
//            if (zoomLevel!=self.mapView.region.span.longitudeDelta) {
//                if (self.mapView.region.span.longitudeDelta > 1)
//                {
//                    //[self filterAnnotations];
//                    zoomLevel=self.mapView.region.span.longitudeDelta;
//                }
//                [self filterAnnotations];
//            }
//        }
//    }
}

//https://developer.apple.com/library/ios/documentation/userexperience/conceptual/LocationAwarenessPG/AnnotatingMaps/AnnotatingMaps.html#//apple_ref/doc/uid/TP40009497-CH6-SW47

- (MKAnnotationView *) mapView:(MKMapView *)mapView
             viewForAnnotation:(id <MKAnnotation>) annotation {
    // If the annotation is the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;

    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MyAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView* pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.pinColor = MKPinAnnotationColorGreen;
            pinView.animatesDrop = NO;
            pinView.canShowCallout = YES;
            
            // If appropriate, customize the callout by adding accessory views.
            //UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            //[rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            //pinView.rightCalloutAccessoryView = rightButton;
            
            // Add a custom image to the left side of the callout.
            UIImageView *myCustomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cone.png"]];
            pinView.leftCalloutAccessoryView = myCustomImage;
        }
        else
            pinView.annotation = annotation;
        
        return pinView;
    }
    
    return nil;
}

# pragma NSURLConnection Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [self.buffer setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.buffer appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Do cleanup
    self.myConnection = nil;
    self.buffer = nil;
    
    // Inform the user, most likely in a UIAlert
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //Create a queue and dispatch the parsing of the data
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Parse the data from JSON to an array
        NSError *error = nil;
        NSArray *jsonString = [NSJSONSerialization JSONObjectWithData:_buffer options:NSJSONReadingMutableContainers error:&error];
        
        // Return to the main queue to handle the data & UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //Check if error or not
            if (!error) {
                //If no error then PROCESS ARRAY
                NSString *title, *subtitle, *lat, *lon;
                NSArray *addr;
                for (NSDictionary *tempDictionary in jsonString) {                    // Extract each dictionary’s data & create pin
                    if ([[tempDictionary objectForKey:@"service_name"] isEqualToString:@"Pothole in Street"]) {
                        title = [tempDictionary objectForKey:@"service_request_id"];
                        addr = [[tempDictionary objectForKey:@"address"] componentsSeparatedByString:@","];
                        subtitle = [addr objectAtIndex:0];
                        lat = [tempDictionary objectForKey:@"lat"];
                        lon = [tempDictionary objectForKey:@"long"];
                        [self createPin:title andSubtitle:subtitle withLat:lat withLong:lon];
                    }
                }
                // Call reload in order to refresh the tableview
                [self.mapView addAnnotations:annotations];
                
            }else{
                NSLog(@"ERROR %@", [error localizedDescription]);
            }
            
            //Stop animating the spinner
            [UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
            
            [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
            
            // Do cleanup
            self.myConnection = nil;
            self.buffer     = nil;
        });
        
    });
}

@end
