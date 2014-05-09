//
//  ViewController.m
//  Pothole Chicago
//
//  Created by Guest Account on 3/11/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "MainViewController.h"

#import <Parse/Parse.h>
#import "AppDelegate.h"

@interface MainViewController ()
{
    AppDelegate *app;
}

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    app = [UIApplication sharedApplication].delegate;
    [self.navigationController setNavigationBarHidden:NO];
    self.screenName = @"Main Screen";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    app = [UIApplication sharedApplication].delegate;
    [app.annotations removeAllObjects];
}

- (IBAction)logout:(id)sender {
    if (!app.guest)
        [PFUser logOut];
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
