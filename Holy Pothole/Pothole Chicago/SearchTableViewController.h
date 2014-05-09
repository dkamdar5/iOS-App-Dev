//
//  SearchTableViewController.h
//  Holy Pothole
//
//  Created by Guest Account on 4/29/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
