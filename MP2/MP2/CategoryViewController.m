//
//  CategoryViewController.m
//  MP2
//
//  Created by Guest Account on 3/25/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "CategoryViewController.h"
#import "MasterViewController.h"
#import "Conversions.h"

@interface CategoryViewController ()
{
    NSMutableArray *_categoryNames;
}
@end

@implementation CategoryViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSString *pathToPlist = [[NSBundle mainBundle] pathForResource:@"conversion" ofType:@"plist"];
    NSDictionary *dictFromPlist = [NSDictionary dictionaryWithContentsOfFile:pathToPlist];
    _categoryNames = [dictFromPlist objectForKey:@"Categories"];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Categories";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil action:nil];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [[segue identifier] isEqualToString:@"showConversions"])
    {
        NSString *pathToPlist = [[NSBundle mainBundle] pathForResource:@"conversion" ofType:@"plist"];
        NSDictionary *dictFromPlist = [NSDictionary dictionaryWithContentsOfFile:pathToPlist];
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *categoryName = _categoryNames[indexPath.row];
        //NSArray *categoryItems = [dictFromPlist objectForKey:categoryName];
        NSArray *categoryItems = dictFromPlist[categoryName];
        MasterViewController *controller = [segue destinationViewController];
        controller.categories = categoryItems;
        controller.category = categoryName;
        controller.title = categoryName;
        controller.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                                       style:UIBarButtonItemStylePlain
                                                                                      target:nil action:nil];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _categoryNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *category = _categoryNames[indexPath.row];
    cell.textLabel.text = category;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
     // ...
     // Pass the selected object to the new view controller.
     //[self.navigationController pushViewController:detailViewController animated:YES];
}

@end
