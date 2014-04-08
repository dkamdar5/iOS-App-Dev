//
//  AddCategoryViewController.m
//  MP2
//
//  Created by Guest Account on 4/8/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "AddCategoryViewController.h"
#import "CategoryViewController.h"
#import "AppDelegate.h"

@interface AddCategoryViewController ()

@end

@implementation AddCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.category = @"";
}

- (IBAction)addButtonPressed:(id)sender {
    self.category = self.textField.text;
    AppDelegate *appDel = [[AppDelegate alloc] init];
    appDel.categ = self.category;
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
