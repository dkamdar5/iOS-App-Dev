//
//  WelcomeScreenViewController.m
//  Pothole Chicago
//
//  Created by Guest Account on 4/3/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "WelcomeScreenViewController.h"
#import "SignUpViewController.h"
#import "LogInViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"

@implementation WelcomeScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.success = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.banner.delegate = self;
    if ([[self.navigationController presentedViewController] isKindOfClass:[LogInViewController class]])
    {
        if (self.success)
            [self performSegueWithIdentifier:@"goToMain" sender:self];
    }
    if ([[self.navigationController presentedViewController] isKindOfClass:[SignUpViewController class]])
    {
        if (self.success)
            [self performSegueWithIdentifier:@"goToMain" sender:self];
    }
}


-(void)viewWillDisappear:(BOOL)animated
{
    self.banner.delegate = nil;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)guestButtonPressed:(id)sender {
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.guest = YES;
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    
}
-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}
@end
