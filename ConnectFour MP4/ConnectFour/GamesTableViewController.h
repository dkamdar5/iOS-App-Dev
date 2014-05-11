//
//  GamesTableViewController.h
//  ConnectFour
//
//  Created by Guest Account on 5/10/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectFourModel.h"

@interface GamesTableViewController : UITableViewController

- (IBAction)logout:(id)sender;
- (IBAction)newGame:(id)sender;

@property NSMutableArray *allGames;

-(void)moveMade;

@end
