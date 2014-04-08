//
//  MasterViewController.m
//  MP2
//
//  Created by Guest Account on 3/14/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "MasterViewController.h"
#import "CategoryViewController.h"
#import "Conversion.h"

@interface MasterViewController () {
    //NSMutableArray *_objects;
    NSDictionary *_baseType;
    NSMutableDictionary *_conversions2;
    NSMutableArray *_finishedConversions;
    int _selectedIndex;
    Conversion *_convert;
}
@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *pathToPlist = [[NSBundle mainBundle] pathForResource:@"conversion" ofType:@"plist"];
    NSDictionary *dictFromPlist = [NSDictionary dictionaryWithContentsOfFile:pathToPlist];
    _conversions2 = [dictFromPlist objectForKey:self.category];
    _finishedConversions = [_conversions2 allValues].mutableCopy;
    _baseType = [dictFromPlist objectForKey:@"Base_Types"];
    _convert = [[Conversion alloc] initWithDictionary:[dictFromPlist objectForKey:self.category] andCategory:self.category andBaseTypes:_baseType];
    _finishedConversions = [_convert convertWithValue:1 andUnit:[_baseType valueForKey:self.category]].mutableCopy;
    
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Detects touch to UIView and makes the keyboard dissappear
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
    [self.textField resignFirstResponder];
}

id (^cellblock)(UITextField *) = ^(UITextField* text)
{
    UIView *superview = text.superview;
    while(![superview isKindOfClass:[UITableViewCell class]])
    {
        superview = superview.superview;
    }
    UITableViewCell *cell = (UITableViewCell *)superview;
    return cell;
};


#pragma mark - Text Field Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //dismiss keyboard on return key press
    [textField resignFirstResponder];
    //call convert action here
//    UIView *superview = textField.superview;
//    while(![superview isKindOfClass:[UITableViewCell class]])
//    {
//        superview = superview.superview;
//    }
//    UITableViewCell *cell = (UITableViewCell *)superview;
    UITableViewCell *cell = (UITableViewCell *)cellblock(textField);
    _selectedIndex = [self.tableView indexPathForCell:cell].row;
    [self convertUsingCell:cell];
    self.navigationItem.rightBarButtonItem = nil;
    return YES;
}



-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (![textField isFirstResponder]){
        self.navigationItem.rightBarButtonItem = nil;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UITableViewCell *cell = (UITableViewCell *)cellblock(textField);
    _selectedIndex = [self.tableView indexPathForCell:cell].row;
    //[self convertUsingCell:cell];
    //[self.tableView reloadData];
}


- (void)convertUsingCell:(UITableViewCell *)cell
{
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:2];
    UITextField *textField = (UITextField *)[cell.contentView viewWithTag:1];
    _finishedConversions = [_convert convertWithValue:[textField.text doubleValue] andUnit:label.text].mutableCopy;
    [self.tableView reloadData];
}

#pragma mark - Button Commands

//- (void)insertNewObject:(id)sender
//{
//    if (!_objects) {
//        _objects = [[NSMutableArray alloc] init];
//    }
//    [_objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}

- (void)doneButtonPressed:(id)sender
{
    //NSIndexPath *indexPath = [[NSIndexPath alloc] initWithIndex:_selectedIndex];
    //NSIndexPath *indexPath2 = [[NSIndexPath alloc] init];
    //[indexPath2 indexPathByAddingIndex:_selectedIndex];
    //[NSIndexPath indexPathForRow:_selectedIndex inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
    [self convertUsingCell:cell];
    [self.textField resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UnitCell" forIndexPath:indexPath];

    //cell.textLabel.text = [object description];
    UITextField *textField = (UITextField *)[cell.contentView viewWithTag:1];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:2];
    //textField.text = [NSString stringWithFormat:@"%d", indexPath.row];
    NSArray *a = [_conversions2 allKeys];
    NSArray *b = _finishedConversions;
    textField.text = [NSString stringWithFormat:@"%@", b[indexPath.row]];
    label.text = a[indexPath.row];
    return cell;
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [_objects removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UITextField *textField = (UITextField *)[cell.contentView viewWithTag:1];
    [textField becomeFirstResponder];
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
@end
