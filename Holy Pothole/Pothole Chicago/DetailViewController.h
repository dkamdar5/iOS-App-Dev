//
//  DetailViewController.h
//  Pothole Chicago
//
//  Created by Guest User on 4/3/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAnnotation.h"

@interface DetailViewController : UITableViewController

- (IBAction)submit:(id)sender;
//@property NSMutableArray *annotations;
@property int *number;

@end
