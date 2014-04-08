//
//  CategoryViewController.h
//  MP2
//
//  Created by Guest Account on 3/25/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableViewCell *tableViewCell;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property NSString *category;

- (IBAction)addButtonPressed:(id)sender;

@end
