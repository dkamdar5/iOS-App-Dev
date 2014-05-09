//
//  UserInfoViewController.m
//  Pothole Chicago
//
//  Created by Guest Account on 3/11/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfo.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController
{
    NSArray *_fields;
    NSMutableDictionary *_userInfo;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //set info from plist
    NSString *pathToPlist = [[NSBundle mainBundle] pathForResource:@"User Info" ofType:@"plist"];
    _userInfo = [NSMutableDictionary dictionaryWithContentsOfFile:pathToPlist];
    _fields = [_userInfo valueForKey:@"Fields"];
}

-(void)checkChanged
{
    BOOL changed = [[_userInfo valueForKey:@"Changed"] boolValue];
    if (!changed)
    {
        NSArray *keys = @[@"First Name", @"Last Name", @"Email", @"Phone Number", @"Changed", @"Fields"];
        NSArray *vals = @[@"John", @"Doe", @"johndoe@email.com", @"000-000-0000", @NO, @[@"First Name", @"Last Name", @"Email", @"Phone Number"]];
        NSDictionary *original = [[NSDictionary alloc] initWithObjects:vals forKeys:keys];
        if (![original isEqualToDictionary:_userInfo])
            [_userInfo setValue:@YES forKey:@"Changed"];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //number of rows per section
    return _fields.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //reuse cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoCell" forIndexPath:indexPath];
    
    //create label and set properties
    UILabel *label =(UILabel *)[cell.contentView viewWithTag:2];
    label.font = [UIFont fontWithName:@"System Bold" size:14.0];
    label.text = _fields[indexPath.row];
    
    //create text field and set properties
    UITextField *textField = (UITextField *)[cell.contentView viewWithTag:1];
    textField.text = [_userInfo valueForKey:label.text];
    
    return cell;
}

#pragma mark - Table View delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UITextField *textField = (UITextField *)[cell.contentView viewWithTag:1];
    //[self.textField becomeFirstResponder];
    [textField becomeFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //dismiss keyboard on return key press
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)saveButtonPressed:(id)sender {
    [self checkChanged];
    for (NSInteger i = 0; i < _fields.count; i++)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UILabel *label =(UILabel *)[cell.contentView viewWithTag:2];
        UITextField *textField = (UITextField *)[cell.contentView viewWithTag:1];
        [_userInfo setValue:textField.text forKey:label.text];
    }
    NSString *pathToPlist = [[NSBundle mainBundle] pathForResource:@"User Info" ofType:@"plist"];
    [_userInfo writeToFile:pathToPlist atomically:YES];
}
@end
