//
//  PotholeDetails.m
//  Holy Pothole
//
//  Created by Guest Account on 4/28/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "PotholeDetails.h"

@implementation PotholeDetails

-(NSString *)getAddress
{
    return [self.details objectForKey:@"address"];
}

-(NSDictionary *)getArray
{
    return _details.copy;
}

@end
