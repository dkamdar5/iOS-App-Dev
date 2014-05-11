//
//  ViewController.m
//  ConnectFour
//
//  Created by Guest Account on 4/18/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "ViewController.h"
#import "ConnectFourModel.h"
#import "GamesTableViewController.h"

@interface ViewController ()
{
    BOOL animating;
    NSMutableArray *pieces;
    NSTimer *timer;
    int timerCount;
    int bounceCount;
    int bounceRow;
    UIDynamicAnimator *animator;
    UIGravityBehavior *gravity;
    UIDynamicItemBehavior *bounce;
}

@end

@implementation ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.boardView.delegate = self;
    pieces = [[NSMutableArray alloc] init];
    bounceCount = 0;
    animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    gravity = [[UIGravityBehavior alloc] init];
    bounce = [[UIDynamicItemBehavior alloc] init];
    bounce.elasticity = 0.6;
    [animator addBehavior:bounce];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(increment) userInfo:nil repeats:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.boardView.cutoutDiameter = 40;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self resetCounter];
    [timer fire];
    if (_turnOver)
        [self simulateDrops];
    animating = YES;
    [self simulateDrops];
    animating = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    GamesTableViewController *parent = (GamesTableViewController *)[self.navigationController topViewController];
    if (_turnOver)
        [parent moveMade];
}

-(void)setTurn:(NSNumber *)aTurn
{
    self.gameModel.turn = aTurn;
}

-(void)resetCounter
{
    timerCount = 20;
    self.timerLabel.text = [NSString stringWithFormat:@"%i",timerCount];
}

-(void)callWithRaondom
{
    int random = (arc4random()%7)+1;
    [self boardView:self.boardView columnSelected:random];
}

-(void)increment
{
    if (!_turnOver){
        timerCount = [self.timerLabel.text intValue];
        timerCount--;
        self.timerLabel.text = [NSString stringWithFormat:@"%i",timerCount];
        if (timerCount < 1) {
            self.timerLabel.text = @"0";
            [self callWithRaondom];
        }
    }
}

-(void)resetGame
{
    _turnOver = NO;
    [self.gameModel initializeBoard];
    for (UIView *circlePiece in pieces)
    {
        [circlePiece removeFromSuperview];
    }
    [pieces removeAllObjects];
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    //to make sure user can't drop another token before current animation is done
    bounceCount++;
    switch (bounceRow) {
        case 1:
            if (bounceCount > 3)
            {
                animating = NO;
                [self resetCounter];
                [self checkGameOver];
            }
            break;
        case 2:
            if (bounceCount > 4)
            {
                animating = NO;
                [self resetCounter];
                [self checkGameOver];
            }
            break;
        case 3:
        case 4:
        case 5:
        case 6:
            if (bounceCount > 5)
            {
                animating = NO;
                [self resetCounter];
                [self checkGameOver];
            }
            break;
        default:
            break;
    }
}

-(void)checkGameOver
{
    if (self.gameModel.gameOver){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Game Over"
                                                            message:self.gameModel.gameOverString
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        [self resetGame];
    }
}

-(void)simulateDrops
{
    for (int i = 0; i < 7; i++) {
        NSArray *row = [self.gameModel.board objectAtIndex:i];
        for (int j = 5; j > 0; j--) {
            if ([[row objectAtIndex:j] isEqualToNumber:@0]) {
                //
            }else{
            CGRect rectangle = CGRectMake(i*self.boardView.gridWidth-(self.boardView.cutoutDiameter/2), -self.boardView.cutoutDiameter, self.boardView.cutoutDiameter, self.boardView.cutoutDiameter);
            UIView *circlePeice = [[UIView alloc] initWithFrame:rectangle];
            [pieces addObject:circlePeice];
            if ([[row objectAtIndex:j] isEqualToNumber:@1]) {
                circlePeice.backgroundColor = [UIColor yellowColor];
            }else{
                circlePeice.backgroundColor = [UIColor redColor];
            }
            circlePeice.layer.cornerRadius = self.boardView.cutoutDiameter/2;
            circlePeice.center = CGPointMake((i+1)*self.boardView.gridWidth, 0);
            [self.view insertSubview:circlePeice belowSubview:self.boardView];
            animating = YES;
            [gravity addItem:circlePeice];
            [animator addBehavior:gravity];
            UICollisionBehavior* collision = [[UICollisionBehavior alloc] initWithItems:@[circlePeice]];
            collision.collisionDelegate = self;
            [collision addBoundaryWithIdentifier:@"bottom"
                                       fromPoint:CGPointMake(0, (j+1)*self.boardView.gridHeight+20)
                                         toPoint:CGPointMake(self.view.bounds.size.width, (j+1)*self.boardView.gridHeight+20)];
            collision.translatesReferenceBoundsIntoBoundary = YES;
            [animator addBehavior:collision];
            [bounce addItem:circlePeice];
            }
        }
    }
}


-(void)boardView:(BoardView *)boardView columnSelected:(int)column
{
    if (!_turnOver){
    if (animating)
        return;
    int row = [self.gameModel userTappedColumn:column];
    bounceRow = row;
    bounceCount = 0;
    if (row < 0 && timerCount < 1)
        [self callWithRaondom];
    if (row < 0)
        return; //incorrect user tap
    CGRect rectangle = CGRectMake(column*self.boardView.gridWidth-(self.boardView.cutoutDiameter/2), -self.boardView.cutoutDiameter, self.boardView.cutoutDiameter, self.boardView.cutoutDiameter);
    UIView *circlePeice = [[UIView alloc] initWithFrame:rectangle];
    [pieces addObject:circlePeice];
    circlePeice.backgroundColor = self.gameModel.color;
    circlePeice.layer.cornerRadius = self.boardView.cutoutDiameter/2;
    circlePeice.center = CGPointMake(column*self.boardView.gridWidth, 0);
    [self.view insertSubview:circlePeice belowSubview:self.boardView];
        //_turnOver = YES;
    //start animation
    animating = YES;
    [gravity addItem:circlePeice];
    [animator addBehavior:gravity];
    UICollisionBehavior* collision = [[UICollisionBehavior alloc] initWithItems:@[circlePeice]];
    collision.collisionDelegate = self;
    [collision addBoundaryWithIdentifier:@"bottom"
                               fromPoint:CGPointMake(0, (row+1)*self.boardView.gridHeight+20)
                                 toPoint:CGPointMake(self.view.bounds.size.width, (row+1)*self.boardView.gridHeight+20)];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    [animator addBehavior:collision];
    [bounce addItem:circlePeice];
        _turnOver = YES;
    }
}


@end
