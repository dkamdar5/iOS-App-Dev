//
//  WelcomeScreenViewController.h
//  Pothole Chicago
//
//  Created by Guest Account on 4/3/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUpViewController.h"
#import <iAd/iAd.h>

@interface WelcomeScreenViewController : UIViewController <ADBannerViewDelegate>

@property BOOL success;

- (IBAction)guestButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet ADBannerView *banner;

@end
