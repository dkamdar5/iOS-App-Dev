//
//  MasterViewController.h
//  MP2
//
//  Created by Guest Account on 3/14/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UITableViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableViewer;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong) NSString *category;
@property (strong) NSArray *categories;
@end
