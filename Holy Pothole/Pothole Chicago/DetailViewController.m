//
//  DetailViewController.m
//  Pothole Chicago
//
//  Created by Guest User on 4/3/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "DetailViewController.h"
#import <Parse/Parse.h>
#import "DrivingLogViewController.h"
#import "AppDelegate.h"

@interface DetailViewController ()
{
    MyAnnotation *_annotation;
    AppDelegate *app;
}

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //additional setup
    app = [UIApplication sharedApplication].delegate;
    _annotation = [app.annotations objectAtIndex:self.number];
    [self.navigationController setTitle:_annotation.title];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel *label = label = (UILabel *)[cell.contentView viewWithTag:1];
    UILabel *label2 = (UILabel *)[cell.contentView viewWithTag:2];
    NSString *titles;
    switch (indexPath.row) {
        case 0:
            titles = [NSString stringWithFormat:@"%f", _annotation.coordinate.latitude];
            label2.text = titles;
            label.text = @"Lat:";
            break;
        case 1:
            label.text = @"Long:";
            titles = [NSString stringWithFormat:@"%f", _annotation.coordinate.longitude];
            label2.text = titles;
            break;
        default:
            break;
    }
    return cell;
}

- (IBAction)submit:(id)sender
{
    //report to Parse using PFObject
    PFObject *pot = [PFObject objectWithClassName:@"Pothole"];
    pot[@"lat"] = [NSNumber numberWithDouble:_annotation.coordinate.latitude];
    pot[@"lon"] = [NSNumber numberWithDouble:_annotation.coordinate.longitude];
    pot[@"deviceID"] = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    //if not guest
    if (!app.guest) {
        PFUser *user = [PFUser currentUser];
        pot[@"user"] = user;
    }
    [pot saveInBackground]; //save
    
    //remove reported annotation in both VCs
    //DrivingLogViewController *dlvc = (DrivingLogViewController *)self.navigationController.topViewController;
    [app.annotations removeObject:_annotation];
    //[dlvc setAnnotations:self.annotations];
    
    //exit
    [self.navigationController popViewControllerAnimated:YES];
}
@end
