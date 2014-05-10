//
//  ConnectFourModel.h
//  ConnectFour
//
//  Created by Guest Account on 4/23/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectFourModel : NSObject

@property (assign) int numRows;
@property (assign) int numColumns;
@property (assign) UIColor *color;
@property (strong, nonatomic) NSMutableArray *board;
@property (assign) BOOL gameOver;

-(void)initializeBoard;
-(int)userTappedColumn:(int)column;
-(NSString *)gameOverString;


@end