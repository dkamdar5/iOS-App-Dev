//
//  DrivingLogViewController.m
//  Pothole Chicago
//
//  Created by Guest Account on 4/23/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "DrivingLogViewController.h"
#import "MyAnnotation.h"
#import "DetailViewController.h"
#import "DrivingViewController.h"
#import "PotholeViewController.h"
#import "AppDelegate.h"

@interface DrivingLogViewController ()
{
    AppDelegate *app;
}

@end

@implementation DrivingLogViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    app = [UIApplication sharedApplication].delegate;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDet"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //[[segue destinationViewController] setAnnotations:self.annotations];
        [[segue destinationViewController] setNumber:indexPath.row];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return app.annotations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    MyAnnotation *annotation = [[MyAnnotation alloc] init];
    annotation = [app.annotations objectAtIndex:indexPath.row];
    cell.textLabel.text = annotation.title;
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [app.annotations removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
