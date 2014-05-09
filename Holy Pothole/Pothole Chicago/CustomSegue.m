//
//  CustomSegue.m
//  Pothole Chicago
//
//  Created by Guest Account on 4/8/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "CustomSegue.h"

@implementation CustomSegue

-(void)perform
{
    if (self.unwinding){
        [self.destinationViewController dismissViewControllerAnimated:NO completion:nil];
    } else {
        [self.sourceViewController presentViewController:self.destinationViewController animated:NO completion:nil];
    }
}

@end
