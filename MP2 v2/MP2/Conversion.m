//
//  Conversion.m
//  MP2
//
//  Created by Guest Account on 4/8/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import "Conversion.h"

@interface Conversion () {
    NSDictionary *_baseTypes;
    NSDictionary *_conversions;
}
@end

@implementation Conversion

-(id)initWithDictionary:(NSDictionary *)conversionsDict andCategory:(NSString *)category andBaseTypes:(NSDictionary *)baseTypes
{
    self = [super init];
    if (self)
    {
        self.conversionsDict = conversionsDict;
        self.category = category;
        _baseTypes = baseTypes;
        _conversions = [self.conversionsDict objectForKey:self.category];
    }
    return self;
}

-(NSArray *)convertWithValue:(double)inputVal andUnit:(NSString *)unit
{
    double base = [self convertToBase:inputVal withUnit:unit];
    return [self convertAll:base];
}

- (double)convertToBase:(double)inputVal withUnit:(NSString *)unit
{
    double baseValue = 0.0;
    if ([[_baseTypes valueForKey:self.category] isEqualToString:unit])
    {
        baseValue = inputVal;
    }
    else
    {
        if ([self.category isEqualToString:@"Temperature"])
        {
            NSArray *tempArr = [self.conversionsDict valueForKey:unit];
            double m = ((NSNumber*)[tempArr objectAtIndex:0]).doubleValue;
            double b = ((NSNumber*)[tempArr objectAtIndex:1]).doubleValue;
            baseValue = inputVal * m + b;
            
        }else{
            baseValue = inputVal * ((NSNumber *)[self.conversionsDict valueForKey:unit]).doubleValue;
        }
    }
    return baseValue;
}


- (NSArray *)convertAll:(double)baseValue
{
    NSMutableArray *myArray = [[NSMutableArray alloc] init];
    //[myArray addObjectsFromArray:[_conversions2 allValues]];
    if ([self.category isEqualToString:@"Temperature"])
    {
        //add C conversion to array
        NSNumber *newVal = [self getNewValForKey:@"Celcius" WithBaseValue:baseValue];
        [myArray addObject:newVal];
        
        //add F conversion to array
        newVal = [self getNewValForKey:@"Fahrenheit" WithBaseValue:baseValue];
        [myArray addObject:newVal];
        
        //add K to array
        newVal = (NSNumber *)[NSNumber numberWithDouble:baseValue];
        [myArray addObject:newVal];
    }else{
        [myArray addObjectsFromArray:[self.conversionsDict allValues]];
        for(NSUInteger i = 0; i < myArray.count; i++)
        {
            NSNumber *numb = (NSNumber *)[myArray objectAtIndex:i];
            double convVal = baseValue/(numb.doubleValue);
            NSNumber *newVal = (NSNumber *)[NSNumber numberWithDouble:convVal];
            [myArray replaceObjectAtIndex:i withObject:newVal];
        }
    }
    return [myArray copy];
}

- (NSNumber *)getNewValForKey:(NSString *)key WithBaseValue:(double)baseValue
{
    NSArray *tempArr = [self.conversionsDict valueForKey:key];
    double m = ((NSNumber*)[tempArr objectAtIndex:0]).doubleValue;
    double b = ((NSNumber*)[tempArr objectAtIndex:1]).doubleValue;
    double convVal = (baseValue - b) / m;
    NSNumber *newVal = (NSNumber *)[NSNumber numberWithDouble:convVal];
    return newVal;
}

@end
