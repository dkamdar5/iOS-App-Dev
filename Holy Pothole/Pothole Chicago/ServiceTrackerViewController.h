//
//  ServiceTrackerViewController.h
//  Pothole Chicago
//
//  Created by Guest Account on 4/16/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceTrackerViewController : UIViewController <NSURLConnectionDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, strong) NSMutableArray *testArray;
@property (nonatomic, strong) NSMutableData *buffer;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView  *spinner;
@property (nonatomic, strong) NSURLConnection *myConnection;
@property (strong, nonatomic) NSMutableDictionary *dict;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)done:(id)sender;
@end
