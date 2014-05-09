//
//  SignUpViewController.m
//  Pothole Chicago
//
//  Created by Guest Account on 4/7/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "SignUpViewController.h"

#import <Parse/Parse.h>
#import "ActivityView.h"
#import "WelcomeScreenViewController.h"
#import "AppDelegate.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputChanged:) name:UITextFieldTextDidChangeNotification object:self.textField];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputChanged:) name:UITextFieldTextDidChangeNotification object:self.password1];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputChanged:) name:UITextFieldTextDidChangeNotification object:self.password2];
    
	self.doneButton.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated {
	[self.textField becomeFirstResponder];
	[super viewWillAppear:animated];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.textField) {
		[self.password1 becomeFirstResponder];
	}
	if (textField == self.password1) {
		[self.password2 becomeFirstResponder];
	}
	if (textField == self.password2) {
		[self.password2 resignFirstResponder];
		[self processFieldEntries];
	}
    
	return YES;
}

- (BOOL)shouldEnableDoneButton {
	BOOL enableDoneButton = NO;
	if (self.textField.text != nil &&
		self.textField.text.length > 0 &&
		self.password1.text != nil &&
		self.password1.text.length > 0 &&
		self.password2.text != nil &&
		self.password2.text.length > 0) {
		enableDoneButton = YES;
	}
	return enableDoneButton;
}

- (void)textInputChanged:(NSNotification *)note {
	self.doneButton.enabled = [self shouldEnableDoneButton];
}

- (IBAction)done:(id)sender {
    [self.textField resignFirstResponder];
	[self.password1 resignFirstResponder];
	[self.password2 resignFirstResponder];
	[self processFieldEntries];
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)processFieldEntries {
	// Check that we have a non-zero username and passwords.
	// Compare password and passwordAgain for equality
	// Throw up a dialog that tells them what they did wrong if they did it wrong.
    
	NSString *username = self.textField.text;
	NSString *password = self.password1.text;
	NSString *passwordAgain = self.password2.text;
	NSString *errorText = @"Please ";
	NSString *usernameBlankText = @"enter a username";
	NSString *passwordBlankText = @"enter a password";
	NSString *joinText = @", and ";
	NSString *passwordMismatchText = @"enter the same password twice";
    
	BOOL textError = NO;
    
	// Messaging nil will return 0, so these checks implicitly check for nil text.
	if (username.length == 0 || password.length == 0 || passwordAgain.length == 0) {
		textError = YES;
        
		// Set up the keyboard for the first field missing input:
		if (passwordAgain.length == 0) {
			[self.password2 becomeFirstResponder];
		}
		if (password.length == 0) {
			[self.password1 becomeFirstResponder];
		}
		if (username.length == 0) {
			[self.textField becomeFirstResponder];
		}
        
		if (username.length == 0) {
			errorText = [errorText stringByAppendingString:usernameBlankText];
		}
        
		if (password.length == 0 || passwordAgain.length == 0) {
			if (username.length == 0) { // We need some joining text in the error:
				errorText = [errorText stringByAppendingString:joinText];
			}
			errorText = [errorText stringByAppendingString:passwordBlankText];
		}
	} else if ([password compare:passwordAgain] != NSOrderedSame) {
		// We have non-zero strings.
		// Check for equal password strings.
		textError = YES;
		errorText = [errorText stringByAppendingString:passwordMismatchText];
		[self.password1 becomeFirstResponder];
	}
    
	if (textError) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorText message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
		[alertView show];
		return;
	}
    
	// Everything looks good; try to log in.
	// Disable the done button for now.
	self.doneButton.enabled = NO;
	ActivityView *activityView = [[ActivityView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
	UILabel *label = activityView.label;
	label.text = @"Signing You Up";
	label.font = [UIFont boldSystemFontOfSize:20.f];
	[activityView.activityIndicator startAnimating];
	[activityView layoutSubviews];
    
	[self.view addSubview:activityView];
    
	// Call into an object somewhere that has code for setting up a user.
	// The app delegate cares about this, but so do a lot of other objects.
	// For now, do this inline.
    
	PFUser *user = [PFUser user];
	user.username = username;
	user.password = password;
	[user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		if (error) {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[[error userInfo] objectForKey:@"error"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
			[alertView show];
			self.doneButton.enabled = [self shouldEnableDoneButton];
			[activityView.activityIndicator stopAnimating];
			[activityView removeFromSuperview];
			// Bring the keyboard back up, because they'll probably need to change something.
			[self.textField becomeFirstResponder];
			return;
		}
        
		// Success!
		[activityView.activityIndicator stopAnimating];
		[activityView removeFromSuperview];
        
        [self performSuccess];
        //[self performSegueWithIdentifier:@"unwindFromSignUp" sender:self];
        //[self dismissViewControllerAnimated:YES completion:nil];
        //[self performSegueWithIdentifier:@"goToMain" sender:self];
	}];
}

-(void)performSuccess
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.guest = NO;
    UINavigationController *myNavi = (UINavigationController *)self.presentingViewController;
    WelcomeScreenViewController *wel = (WelcomeScreenViewController *)myNavi.topViewController;
    wel.success = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
