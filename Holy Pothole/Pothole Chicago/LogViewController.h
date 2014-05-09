//
//  LogViewController.h
//  Pothole Chicago
//
//  Created by Guest Account on 4/2/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PotholeDetails.h"

@interface LogViewController : UITableViewController

@property (strong, nonatomic) NSDictionary *pothole;
@property (strong, nonatomic) PotholeDetails *potholeDetails;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
