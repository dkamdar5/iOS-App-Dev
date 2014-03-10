//
//  ViewController.h
//  MP1
//
//  Created by Guest Account on 2/27/14.
//  Copyright (c) 2014 IIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

- (IBAction)convertButtonPressed:(id)sender;
- (IBAction)segmentChanged:(id)sender;
- (IBAction)directionButtonPressed:(id)sender;
- (IBAction)topFieldEditingChanged:(id)sender;
- (IBAction)bottomFieldEditingChanged:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *viewOutlet;

@property (weak, nonatomic) IBOutlet UITextField *topField;
@property (weak, nonatomic) IBOutlet UITextField *bottomField;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *categorySegmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *convertButton;
@property (weak, nonatomic) IBOutlet UIButton *directionButton;


@end
