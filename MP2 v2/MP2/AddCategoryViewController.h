//
//  AddCategoryViewController.h
//  MP2
//
//  Created by Guest Account on 4/8/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCategoryViewController : UIViewController

@property (strong) NSString *category;
@property (weak, nonatomic) IBOutlet UITextField *textField;

- (IBAction)addButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end
