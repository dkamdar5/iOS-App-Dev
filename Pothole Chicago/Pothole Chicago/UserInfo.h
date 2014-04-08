//
//  UserInfo.h
//  Pothole Chicago
//
//  Created by Guest Account on 4/2/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic, assign) NSMutableDictionary *dictionary;
@property (nonatomic, copy) NSString *pathToPlist;
@property (nonatomic, copy) NSString *subtitle;

@end
