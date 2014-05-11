//
//  ConnectFourModel.m
//  ConnectFour
//
//  Created by Guest Account on 4/23/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "ConnectFourModel.h"

@implementation ConnectFourModel
{
    NSString *_gameOverString;
    NSMutableArray *_numPiecesLeftInCol;
}

-(void)initializeBoard
{
    NSMutableArray *row = [[NSMutableArray alloc] initWithCapacity:6];
    for (int i = 0; i < 6; i++)
    {
        NSNumber *num = @0;
        [row insertObject:num atIndex:i];
    }
    NSMutableArray *col = [[NSMutableArray alloc] initWithCapacity:7];
    for (int i = 0; i < 7; i++)
    {
        [col insertObject:row.mutableCopy atIndex:i];
    }
    _turn = @1;
    _numPiecesLeftInCol = [[NSMutableArray alloc] init];
    for (int i=0; i<7; i++)
    {
        [_numPiecesLeftInCol addObject:@5];
    }
    self.gameOver = NO;
    self.color = [UIColor yellowColor];
    self.board = col;
}

-(int)userTappedColumn:(int)column
{
    int numPeices=5;
    NSMutableArray *row = [_board objectAtIndex:column-1];
    for (int i = 0; i < 6; i++) {
        if (![[row objectAtIndex:i] isEqualToNumber:@0]) {
            numPeices--;
        }
    }
    if (!(numPeices == -1)) {
        if ([[row objectAtIndex:numPeices] isEqualToNumber:@0]) {
            [row replaceObjectAtIndex:numPeices withObject:_turn];
            numPeices--;
            //detect win or ties
            [self detectTie];
            [self detectVerticalWin];
            [self detectHorizontalWin];
            //change turn
            [self changeTurn];
            return numPeices+1;
        }
    }
    return -1;
}

-(NSString *)gameOverString
{
    return _gameOverString;
}

-(void)detectTie
{
    for (int i = 0; i < _numPiecesLeftInCol.count; i++) {
        if ([[_numPiecesLeftInCol objectAtIndex:i] isEqualToNumber:@0])
        {
            if (i == 6) {
                //tie detected
                self.gameOver = YES;
                _gameOverString = @"Game Ended In a Tie";
            }
        }else{
            return;
        }
    }
}

-(void)detectVerticalWin
{
    for (int i = 0; i < 7; i++)
    {
        NSArray *row = [self.board objectAtIndex:i];
        int count = 0;
        NSNumber *lastPlayer = @0;
        for (int j = 0; j < 6; j++)
        {
            NSNumber *player = [row objectAtIndex:j];
            if ([player isEqualToNumber:_turn])
            {
                count++;
            }else{
                count = 0;
            }
            lastPlayer = player;
        }
        if (count == 4) {
            [self declareWinner];
        }
    }
}

-(void)detectHorizontalWin
{
    int count = 0;
    NSNumber *lastPlayer = @0;
    for (int i = 0; i < 6; i++){
        for (int j = 0; j < 7; j++){
            NSArray *row = [self.board objectAtIndex:j];
            NSNumber *player = [row objectAtIndex:i];
            if ([player isEqualToNumber:_turn])
            {
                count++;
            }else{
                count = 0;
            }
            lastPlayer = player;
            if (count == 4) {
                [self declareWinner];
            }
        }
    }
}

-(void)declareWinner
{
    self.gameOver = YES;
    _gameOverString = [NSString stringWithFormat: @"Player %@ won",_turn];
}

-(void)changeTurn
{
    if ([_turn intValue] == 1) {
        _turn = @2;
        _color = [UIColor yellowColor];
    }else{
        _turn = @1;
        _color = [UIColor redColor];
    }
}

@end
