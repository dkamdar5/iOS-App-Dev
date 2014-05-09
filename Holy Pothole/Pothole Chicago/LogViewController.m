//
//  LogViewController.m
//  Pothole Chicago
//
//  Created by Guest Account on 4/2/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "LogViewController.h"

@interface LogViewController ()

@end

@implementation LogViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pothole = self.potholeDetails.copy;
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
    //return [self.potholeDetails details].count;
    //return self.potholeDetails.details.count;
    return self.pothole.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel *label1 = (UILabel *)[cell.contentView viewWithTag:1];
    UILabel *label2 = (UILabel *)[cell.contentView viewWithTag:2];
    //NSLog(@"%@ %@", [[self.potholeDetails allKeys] objectAtIndex:indexPath.row],[[self.potholeDetails allValues] objectAtIndex:indexPath.row]);
    label1.text = [[self.pothole allKeys] objectAtIndex:indexPath.row];
    if (!([label1.text isEqualToString:@"long"] || [label1.text isEqualToString:@"lat"] || [label1.text isEqualToString:@"lon"])) {
        label2.text = [[self.pothole allValues] objectAtIndex:indexPath.row];
    }else{
        label2.text = [[[self.pothole allValues] objectAtIndex:indexPath.row] stringValue];
    }
    return cell;
}

@end
