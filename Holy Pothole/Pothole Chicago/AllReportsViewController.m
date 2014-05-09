//
//  AllReportsViewController.m
//  Pothole Chicago
//
//  Created by Guest User on 4/10/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "AllReportsViewController.h"
#import "LogViewController.h"
#import "PotholeDetails.h"

@interface AllReportsViewController ()
{
    int _selectedIndex;
}

@end

@implementation AllReportsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _selectedIndex = 0;
    self.array = [[NSMutableArray alloc] initWithCapacity:50];
    
    // Animate the spinner
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    
    // Create the URL & URLRequest
    NSURL *myURL = [NSURL URLWithString:@"http://311api.cityofchicago.org/open311/v2/requests.json?status=open&page_size=500"];
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myURL];
    
    // Create the connection
    self.myConnection = [NSURLConnection connectionWithRequest:myRequest delegate:self];
    
    //Test to make sure the connection worked
    if (self.myConnection){
        self.buffer = [NSMutableData data];
        [self.myConnection start];
    }else{
        NSLog(@"Connection Failed");
    }

}

- (void)insertNewObject:(PotholeDetails *)pothole
{
//    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
//    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
//    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
//    
//    // If appropriate, configure the new managed object.
//    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
//    [newManagedObject setValue:@"open" forKey:@"status"];
//    [newManagedObject setValue:[pothole.getArray objectForKey:@"lat"]  forKey:@"lat"];
//    [newManagedObject setValue:[pothole.getArray objectForKey:@"long"]  forKey:@"lon"];
//    
//    // Save the context.
//    NSError *error = nil;
//    if (![context save:&error]) {
//        // Replace this implementation with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
    
    [self.array addObject:pothole];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.array.count inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //return [[self.fetchedResultsController sections] count];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
//    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
//    return [sectionInfo numberOfObjects];
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReportCell" forIndexPath:indexPath];
//    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UILabel *label1 = (UILabel *)[cell.contentView viewWithTag:1];
    UILabel *label2 = (UILabel *)[cell.contentView viewWithTag:2];
    UILabel *label3 = (UILabel *)[cell.contentView viewWithTag:3];
    NSDictionary *tempDict = [self.array objectAtIndex:indexPath.row];
    //PotholeDetails* tempDetail = [self.array objectAtIndex:indexPath.row];
    //NSDictionary *tempDict = [tempDetail getArray];
    label1.text = [tempDict objectForKey:@"address"];
    label2.text = [tempDict objectForKey:@"service_request_id"];
//    label3.text = [[object valueForKey:@"status"] description];
    label3.text = [tempDict objectForKey:@"status"];;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndex = indexPath.row;
    //[self performSegueWithIdentifier:@"showPotholeDetails" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showPotholeDetails"])
    {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setPotholeDetails:[self.array objectAtIndex:_selectedIndex]];
    }
}

# pragma NSURLConnection Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [self.buffer setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.buffer appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Do cleanup
    self.myConnection = nil;
    self.buffer = nil;
    
    // Inform the user, most likely in a UIAlert
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //Create a queue and dispatch the parsing of the data
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Parse the data from JSON to an array
        NSError *error = nil;
        NSArray *jsonString = [NSJSONSerialization JSONObjectWithData:_buffer options:NSJSONReadingMutableContainers error:&error];
        
        // Return to the main queue to handle the data & UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //Check if error or not
            if (!error) {
                //If no error then PROCESS ARRAY
                for (NSDictionary *tempDictionary in jsonString) {                    // Extract each dictionary’s data & create pin
                    if ([[tempDictionary objectForKey:@"service_name"] isEqualToString:@"Pothole in Street"])
                    {
                        PotholeDetails *details = [[PotholeDetails alloc] init];
                        details = tempDictionary.copy;
                        [self insertNewObject:details];
                    }
                }
                // Call reload in order to refresh the tableview
                [self.tableView reloadData];
                
            }else{
                NSLog(@"ERROR %@", [error localizedDescription]);
            }
            
            //Stop animating the spinner
            [UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
            
            // Do cleanup
            self.myConnection = nil;
            self.buffer     = nil;
        });
        
    });
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Pothole" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:50];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lat" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Holy Pothole"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            //[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


@end

