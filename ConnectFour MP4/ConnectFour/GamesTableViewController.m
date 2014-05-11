//
//  GamesTableViewController.m
//  ConnectFour
//
//  Created by Guest Account on 5/10/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "GamesTableViewController.h"
#import "ViewController.h"
#import "ConnectFourModel.h"
#import <Parse/Parse.h>
#import "Game.h"

@interface GamesTableViewController ()
{
    int _section;
    int _row;
    BOOL logout;
}

@end

@implementation GamesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _allGames = [[NSMutableArray alloc] init];
    NSMutableArray *gamesForSection = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i++) {
        [self.allGames addObject:gamesForSection.mutableCopy];
    }
    PFQuery *mainQuery = [PFQuery queryWithClassName:@"Games"];
    //PFObject *idk = [[gameObj objectForKey:@"player1"] fetchIfNeeded];
    [mainQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        for (int i = 0; i < objects.count; i++) {
            PFObject *object = [objects objectAtIndex:i];
            PFObject *idk = [[object objectForKey:@"player1"] fetchIfNeeded];
            Game *game = [self pFObjToGame:[objects objectAtIndex:i]];
            if ([game.player1.username isEqualToString:[PFUser currentUser].username]) {
                if ([game.turn isEqualToNumber:@1]) {
                    [[self.allGames objectAtIndex:0] addObject:game];
                }else{
                    [[self.allGames objectAtIndex:1] addObject:game];
                }
            }else{
                if ([[object objectForKey:@"available"] isEqualToNumber:@1]) {
                    [[self.allGames objectAtIndex:2] addObject:game];
                }
            }
        }
        [self.tableView reloadData];
    }];
//    PFQuery *userGames = [PFQuery queryWithClassName:@"Games"];
//    [userGames whereKey:@"player1" equalTo:[PFUser currentUser]];
//    [userGames whereKey:@"turn" equalTo:@1];
//    [userGames findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
//        for (int i = 0; i < objects.count; i++) {
//            Game *game = [self pFObjToGame:[objects objectAtIndex:i]];
//            [[self.allGames objectAtIndex:0] addObject:game];
//        }
//        [self.tableView reloadData];
//    }];
//    PFQuery *otherGames = [PFQuery queryWithClassName:@"Games"];
//    [otherGames whereKey:@"player1" equalTo:[PFUser currentUser]];
//    [otherGames whereKey:@"turn" equalTo:@2];
//    [userGames findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
//        for (int i = 0; i < objects.count; i++) {
//            Game *game = [self pFObjToGame:[objects objectAtIndex:i]];
//            [[self.allGames objectAtIndex:1] addObject:game];
//        }
//        [self.tableView reloadData];
//    }];
//    PFQuery *query = [PFQuery queryWithClassName:@"Games"];
//    [query whereKey:@"player1" notEqualTo:[PFUser currentUser]];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
//        for (int i = 0; i < objects.count; i++) {
//            PFObject *object = [objects objectAtIndex:i];
//            Game *game = [self pFObjToGame:[objects objectAtIndex:i]];
//            if ([[object objectForKey:@"available"] isEqualToNumber:@1] && (![game.player1 isEqual:[PFUser currentUser]])) {
//                [[self.allGames objectAtIndex:2] addObject:game];
//            }
//        }
//        [self.tableView reloadData];
//    }];
}

-(Game *)pFObjToGame:(PFObject *)gameObj
{
    Game *game = [[Game alloc] init];
    game.iD = gameObj.objectId;
    PFObject *idk = [[gameObj objectForKey:@"player1"] fetchIfNeeded];
    game.player1 = [gameObj objectForKey:@"player1"];
    game.board = [[ConnectFourModel alloc] init];
    game.board.board = [gameObj objectForKey:@"gameBoard"];
    game.available = [gameObj objectForKey:@"available"];
    game.turn = [gameObj objectForKey:@"turn"];
    return game;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (!logout)
    {
        ViewController *vc = (ViewController *)[self.navigationController topViewController];
        Game *game = [[self.allGames objectAtIndex:_section] objectAtIndex:_row];
        [vc setGameModel:game.board];
        [vc setTurn:game.turn];
        if (_section%2 == 0) {
            [vc setTurnOver:NO];
        }else
            [vc setTurnOver:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"YOUR TURN";
            break;
        case 1:
            return @"THEIR TURN";
            break;
        case 2:
            return @"AVAILABLE GAMES";
            break;
        case 3:
            return @"FINISHED GAMES";
            break;
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.allGames objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILabel *userName = (UILabel *)[cell.contentView viewWithTag:1];
    UILabel *opponentName = (UILabel *)[cell.contentView viewWithTag:2];
    Game *game = [[self.allGames objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([game.player1.objectId isEqualToString:[PFUser currentUser].objectId]) {
        userName.text = [[PFUser currentUser] username];
    }else{
        userName.text = game.player1.username;
    }
    opponentName.text = game.player2.username;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _section = indexPath.section;
    _row = indexPath.row;
    
}

- (IBAction)logout:(id)sender {
    logout = YES;
    [PFUser logOut];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)newGame:(id)sender {
    Game *game = [[Game alloc] init];
    game.player1 = [PFUser currentUser];
    [game.player2 setUsername:@"No Opponent Yet"];
    ConnectFourModel *gameBoard = [[ConnectFourModel alloc] init];
    [gameBoard initializeBoard];
    game.board = gameBoard;
    game.turn = @1;
    [[self.allGames objectAtIndex:0] addObject:game];
    PFObject *cloudGame = [PFObject objectWithClassName:@"Games"];
    cloudGame[@"player1"] = [PFUser currentUser];
    cloudGame[@"available"] = [NSNumber numberWithBool:NO];
    cloudGame[@"gameBoard"] = gameBoard.board;
    cloudGame[@"turn"] = @1;
    cloudGame[@"gameOver"] = @0;
    [cloudGame saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        game.iD = cloudGame.objectId;
        [self.tableView reloadData];
    }];
    [self.tableView reloadData];
}

-(void)moveMade
{
    if (_section%2 == 0) {
    NSMutableArray *myGames = [self.allGames objectAtIndex:_section];
    Game *game = [myGames objectAtIndex:_row];
    if(_section == 0)
    {
        game.available = [NSNumber numberWithBool:YES];
        game.turn = @2;
    }
    if(_section == 2)
    {
        game.available = [NSNumber numberWithBool:NO];
        game.turn = @1;
    }
        //game.available = [NSNumber numberWithBool:NO];
        //game.turn = @2;
    [myGames removeObject:game];
    [[self.allGames objectAtIndex:1] addObject:game];
    PFQuery *query = [PFQuery queryWithClassName:@"Games"];
    [query getObjectInBackgroundWithId:game.iD block:^(PFObject *cloudGame, NSError *error){
        if (game.available) {
            cloudGame[@"available"] = [NSNumber numberWithBool:YES];
        }else{
            cloudGame[@"available"] = [NSNumber numberWithBool:NO];
            cloudGame[@"player2"] = [PFUser currentUser];
        }
        cloudGame[@"gameBoard"] = game.board.board;
        cloudGame[@"turn"] = game.turn;
        [cloudGame saveInBackground];
    }];
    [self.tableView reloadData];
    }
}
@end
