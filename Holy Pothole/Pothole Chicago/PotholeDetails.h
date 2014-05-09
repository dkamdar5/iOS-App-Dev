//
//  PotholeDetails.h
//  Holy Pothole
//
//  Created by Guest Account on 4/28/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PotholeDetails : NSObject

@property (strong, nonatomic) NSDictionary *details;

-(NSString *)getAddress;
-(NSDictionary *)getArray;

@end
