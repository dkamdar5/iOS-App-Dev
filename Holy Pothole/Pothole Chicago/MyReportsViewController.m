//
//  MyReportsViewController.m
//  Pothole Chicago
//
//  Created by Guest User on 4/10/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "MyReportsViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "LogViewController.h"
@interface MyReportsViewController ()
{
    NSMutableArray *_reports;
    NSMutableDictionary *_report;
    int _selectedIndex;
}
@end

@implementation MyReportsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _selectedIndex = 0;
    _report = [[NSMutableDictionary alloc] init];
    _reports = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Pothole"];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    if (!app.guest)
    {
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
    }else{
        [query whereKey:@"deviceID" equalTo:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    NSArray *queryResults = [[NSArray alloc] initWithArray:[query findObjects]];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
    [self convertFromPFObject:queryResults];
    [self.tableView reloadData];
}

-(void)convertFromPFObject:(NSArray *)array
{
    for (int i = 0; i < array.count; i++)
    {
        PFObject *object = [array objectAtIndex:i];
        NSArray *keys = [object allKeys];
        for (int j = 0; j < keys.count; j++) {
            NSString *key = [keys objectAtIndex:j];
            if (!([key isEqualToString:@"user"] || [key isEqualToString:@"deviceID"]))
                [_report setValue:[object objectForKey:key] forKey:key];
        }
        [_reports addObject:_report];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        [[segue destinationViewController] setPotholeDetails:[_reports objectAtIndex:_selectedIndex]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _reports.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReportCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Pothole %d",indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndex = indexPath.row;
}

@end
