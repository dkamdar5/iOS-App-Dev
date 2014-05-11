//
//  BoardView.m
//  ConnectFour
//
//  Created by Guest Account on 4/18/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "BoardView.h"

@implementation BoardView
{
    NSMutableArray *_columnViews;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _gridHeight = self.bounds.size.height / 7;
    _gridWidth = self.bounds.size.width / 8;
    
    _columnViews = [NSMutableArray array];
    
    for (int i = 1; i <= 7; i++)
    {
        UIView *columnView = [[UIView alloc] initWithFrame:CGRectMake(_gridWidth*i-12.5, 0, 25.0, self.bounds.size.height)];
        columnView.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(columnTapped:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        
        [columnView addGestureRecognizer:tap];
        
        [_columnViews addObject:columnView];
        [self addSubview:columnView];
    }
}

-(void)columnTapped:(UIGestureRecognizer *)gestureRecognizer
{
    int idx = [_columnViews indexOfObject:gestureRecognizer.view];
    [self.delegate boardView:self columnSelected:idx+1];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextAddRect(context, self.bounds);
    for (int i=1; i < 8; i++){
        for (int j=1; j < 7; j++)
        {
            //CGContextAddRect(context, CGRectMake(i*_gridWidth-5, j*_gridHeight-5, 10, 10));
            CGContextAddEllipseInRect(context, CGRectMake(i*_gridWidth-_cutoutDiameter/2.0,
                                                          j*_gridHeight-_cutoutDiameter/2.0,
                                                          _cutoutDiameter,
                                                          _cutoutDiameter));
        }
    }
    CGContextEOFillPath(context);
}

@end
