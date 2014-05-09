//
//  Reports.h
//  Pothole Chicago
//
//  Created by Guest User on 4/10/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reports : NSObject

@property (nonatomic, assign) NSMutableArray *reports;
@property (nonatomic, assign) NSMutableArray *report;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *time;

@end
