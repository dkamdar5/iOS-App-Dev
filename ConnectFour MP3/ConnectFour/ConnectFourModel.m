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
    NSNumber *_turn;
    NSString *_gameOverString;
    NSMutableArray *_numPiecesLeftInCol;
}

-(void)initializeBoard
{
    self.numRows = 6;
    self.numColumns = 7;
    NSMutableArray *row = [[NSMutableArray alloc] initWithCapacity:_numRows];
    for (int i = 0; i < _numRows; i++)
    {
        NSNumber *num = @0;
        [row insertObject:num atIndex:i];
    }
    NSMutableArray *col = [[NSMutableArray alloc] initWithCapacity:_numColumns];
    for (int i = 0; i < _numColumns; i++)
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

-(NSNumber *)turn
{
    return _turn;
}

-(int)userTappedColumn:(int)column
{
    NSMutableArray *row = [_board objectAtIndex:column-1];
    NSNumber *numb = [_numPiecesLeftInCol objectAtIndex:column-1];
    if (![numb isEqual:@(-1)]) {
        if ([[row objectAtIndex:numb.intValue] isEqualToNumber:@0]) {
            [row replaceObjectAtIndex:numb.intValue withObject:_turn];
            [_numPiecesLeftInCol replaceObjectAtIndex:column-1 withObject:@(numb.intValue -1)];
            //detect win or ties
            [self detectTie];
            [self detectVerticalWin];
            [self detectHorizontalWin];
            //change turn
            [self changeColor];
            [self changeTurn];
            return numb.intValue+1;
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
    for (int i = 0; i < _numColumns; i++)
    {
        NSArray *row = [self.board objectAtIndex:i];
        int count = 0;
        NSNumber *lastPlayer = @0;
        for (int j = 0; j < _numRows; j++)
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
    for (int i = 0; i < _numRows; i++){
        for (int j = 0; j < _numColumns; j++){
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
    }else{
        _turn = @1;
    }
}

-(void)changeColor
{
    if ([_color isEqual:[UIColor yellowColor]])
    {
        _color = [UIColor redColor];
    }else{
        _color = [UIColor yellowColor];
    }
}

@end
