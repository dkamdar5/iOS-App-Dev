//
//  ServiceTrackerViewController.m
//  Pothole Chicago
//
//  Created by Guest Account on 4/16/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "ServiceTrackerViewController.h"

@interface ServiceTrackerViewController ()
{
    BOOL _show;
}

@end

@implementation ServiceTrackerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp;
    [self.tableView addGestureRecognizer:tap];
    [self.view addGestureRecognizer:swipe];
    _show = NO;
	// Do any additional setup after loading the view.
    //http://www.techrepublic.com/blog/software-engineer/create-your-own-web-service-for-an-ios-app-part-two/
    //
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.textField resignFirstResponder];
    [super viewWillDisappear:animated];
}

-(void)dismissKeyboard
{
    [self.textField resignFirstResponder];
    [self becomeFirstResponder];
}

- (IBAction)done:(id)sender {
    
    //UIDevice *device = [UIDevice currentDevice];
    //NSString *uniqueIdentifier = [device uniqueIdentifier];
    
    NSString *code = self.textField.text;
    if (code.length <2)
        return;
    NSString *formattedCode = [NSString stringWithFormat:@"http://311api.cityofchicago.org/open311/v2/requests/%@.json", code];
    NSURL *url = [NSURL URLWithString:formattedCode];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    self.myConnection = [NSURLConnection connectionWithRequest:req delegate:self];
    if(self.myConnection)
    {
        self.buffer = [NSMutableData data];
        [self.myConnection start];
    } else {
        NSLog(@"Failed");
    }
    [self dismissKeyboard];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self done:nil];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.text.length == 2) {
        textField.text = [textField.text stringByAppendingString:@"-"];
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
    self.buffer     = nil;
    
    // Inform the user, most likely in a UIAlert
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Succeeded!");
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
                self.testArray = [[NSMutableArray alloc] initWithCapacity:50];
                for (NSDictionary *tempDictionary in jsonString) {                    // Extract each dictionary’s username & put it into our array
                    self.dict = tempDictionary.mutableCopy;
                }
                if ([[[self.dict valueForKey:@"code"] stringValue] isEqualToString:@"404"])
                {
                    _show = NO;
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Service Request Not Found!" message:[self.dict valueForKey:@"description"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alertView show];
                    NSLog(@"ERROR %@", [self.dict valueForKey:@"description"]);
                }else{
                    //success
                    _show = YES;
                    [self.tableView reloadData];
                }
            }else{
                NSLog(@"ERROR %@", [error localizedDescription]);
            }
            
            //Stop animating the spinner
            [self.spinner stopAnimating];
            
            // Do cleanup
            self.myConnection = nil;
            self.buffer     = nil;
        });
        
    });
}

# pragma Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *titles;
    if (_show)
    {
        switch (indexPath.row) {
            case 10:
                cell.textLabel.text = @"Lat:";
                titles = [NSString stringWithFormat:@"%@", [[self.dict allValues] objectAtIndex:indexPath.row]];
                cell.detailTextLabel.text = titles;
                break;
            case 5:
                cell.textLabel.text = @"Long:";
                titles = [NSString stringWithFormat:@"%@", [[self.dict allValues] objectAtIndex:indexPath.row]];
                cell.detailTextLabel.text = titles;
                break;
            default:
                cell.textLabel.text = [[self.dict allKeys] objectAtIndex:indexPath.row];
                cell.detailTextLabel.text =[[self.dict allValues] objectAtIndex:indexPath.row];
                break;
        }
    }
    return cell;
}

@end
