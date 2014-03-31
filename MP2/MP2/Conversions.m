//
//  Conversions.m
//  MP2
//
//  Created by Guest Account on 3/14/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "Conversions.h"

@implementation Conversions

- (id)init
{
    self = [super init];
    if (self)
    {
        NSString *pathToPlist2 = [[NSBundle mainBundle] pathForResource:@"conversion" ofType:@"plist"];
        //NSDictionary *dictFromPlist = [NSDictionary dictionaryWithContentsOfFile:pathToPlist];
        self.conversionFactors = [NSDictionary dictionaryWithContentsOfFile:pathToPlist2];
    }
    return self;
}

- (NSArray *)categoryNames
{
    return [self.conversionFactors objectForKey:@"Categories"];
}

- (NSArray *)conversionList:(NSString *)currentConversion
{
    return [self.conversionFactors objectForKey:currentConversion];
}

- (NSArray *)baseTypes
{
    return [self.conversionFactors objectForKey:@"Base_Types"];
}

@end
