//
//  Game.h
//  ConnectFour
//
//  Created by Guest Account on 5/10/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "ConnectFourModel.h"

@interface Game : NSObject

@property (strong, nonatomic) ConnectFourModel *board;
@property (strong, nonatomic) PFUser *player1;
@property (strong, nonatomic) PFUser *player2;
@property (strong, nonatomic) NSNumber *turn;
@property (strong, nonatomic) NSString *iD;
@property (strong, nonatomic) NSNumber *available;

@end
