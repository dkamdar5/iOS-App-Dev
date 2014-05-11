//
//  BoardView.h
//  ConnectFour
//
//  Created by Guest Account on 4/18/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BoardViewDelegate;

@interface BoardView : UIView

@property (readonly) double gridWidth;
@property (readonly) double gridHeight;
@property (assign, nonatomic) double cutoutDiameter;
@property (strong) id<BoardViewDelegate> delegate;

@end

@protocol BoardViewDelegate <NSObject>
- (void)boardView:(BoardView *)boardView columnSelected:(int)column;
@end
