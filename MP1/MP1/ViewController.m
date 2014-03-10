//
//  ViewController.m
//  MP1
//
//  Created by Guest Account on 2/27/14.
//  Copyright (c) 2014 IIT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    int currentSegment;
    BOOL convertDown;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //self.topField.text = @"212";
    //self.bottomLabel.text = @"*C";
    //[self.convertButton setTitle: @"Presto"];
    //[self.directionButton setTitle:@"⬇" forState:UIControlStateNormal];
    [self.categorySegmentedControl setTitle:NSLocalizedString(@"Temperature", nil) forSegmentAtIndex:0];
    [self.categorySegmentedControl setTitle:NSLocalizedString(@"Distance", nil) forSegmentAtIndex:1];
    [self.categorySegmentedControl setTitle:NSLocalizedString(@"Volume", nil) forSegmentAtIndex:2];
    [self.convertButton setTitle:NSLocalizedString(@"Convert", nil) forState:UIControlStateNormal];

    currentSegment = 0;
    convertDown = YES;
}

- (IBAction)convertButtonPressed:(id)sender {
    //insert code here
    //NSLog(@"I got pressed");
    //NSLog(@"%@ got pressed", sender);
    //NSLog(@"Top field contains %@",self.topField.text);
    //double topValue = [self.topField.text doubleValue];
    
    double baseValue, convertedValue;
    if (convertDown){
        baseValue = [self.topField.text doubleValue];
        convertedValue = [self convert:baseValue];
        self.bottomField.text = [NSString stringWithFormat:@"%.2f", convertedValue];

    }
    else{
        baseValue = [self.bottomField.text doubleValue];
        convertedValue = [self convert:baseValue];
        self.topField.text = [NSString stringWithFormat:@"%.2f", convertedValue];

    }
}

- (double)convert:(double)inputValue
{
    double convertedValue;
    switch (currentSegment)
    {
        case 0:
            if (convertDown) //F to C
                convertedValue = (((inputValue - 32) * 5) / 9);
            else //C to F
                convertedValue = ((inputValue * 1.8) + 32);
            break;
            
        case 1:
            if (convertDown) //miles to km
                convertedValue = inputValue * 1.60934;
            else //km to miles
                convertedValue = inputValue * 0.621371;
            break;
            
        case 2:
            if (convertDown) //gal to L
                convertedValue = inputValue * 3.78541178;
            else //L to gal
                convertedValue = inputValue * 0.264172052;
            break;
    }
    return convertedValue;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self convertButtonPressed:self.convertButton];
    //(textField == self.topField)?@"top":@"bottom";
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1)
        convertDown = NO;
    else
        convertDown = YES;
    [self directionButtonPressed:self.directionButton];
}

- (IBAction)segmentChanged:(id)sender {
    UISegmentedControl *control = sender;
    //NSLog(@"Segment changed to %d", [sender selectedSegmentIndex]);
    //NSLog(@"Segment changed to %d", control.selectedSegmentIndex);
    currentSegment = control.selectedSegmentIndex;
    switch (currentSegment)
    {
        case 0:
            self.topLabel.text = NSLocalizedString(@"°F", nil);
            self.bottomLabel.text = NSLocalizedString(@"°C", nil);
            break;
            
        case 1:
            self.topLabel.text = NSLocalizedString(@"Miles", nil);
            //[self.topLabel setText:NSLocalizedString(@"Miles", nil)];
            self.bottomLabel.text = NSLocalizedString(@"Kilometers", nil);
            break;
            
        case 2:
            self.topLabel.text = NSLocalizedString(@"Gallons", nil);
            self.bottomLabel.text = NSLocalizedString(@"Liters", nil);
            break;
    }
    [self convertButtonPressed:self.convertButton];
}

- (IBAction)directionButtonPressed:(id)sender {
    if (convertDown)
        [self.directionButton setTitle:@"⬆" forState:UIControlStateNormal];
    else
        [self.directionButton setTitle:@"⬇" forState:UIControlStateNormal];
    convertDown = !convertDown;
        
        
}

- (IBAction)topFieldEditingChanged:(id)sender {
    [self convertButtonPressed:self.convertButton];
}

- (IBAction)bottomFieldEditingChanged:(id)sender {
    [self convertButtonPressed:self.convertButton];
}

@end
