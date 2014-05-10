//
//  ViewController.h
//  ConnectFour
//
//  Created by Guest Account on 4/18/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardView.h"
#import "ConnectFourModel.h"

@interface ViewController : UIViewController <BoardViewDelegate, UICollisionBehaviorDelegate>

@property (strong, nonatomic) IBOutlet BoardView *boardView;
@property (strong, nonatomic) ConnectFourModel *gameModel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@end
