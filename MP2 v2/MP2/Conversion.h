//
//  Conversion.h
//  MP2
//
//  Created by Guest Account on 4/8/14.
//  Copyright (c) 2014 DK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Conversion : NSObject

@property NSDictionary *conversionsDict;
@property NSString *category;

- (id)initWithDictionary:(NSDictionary *)conversionsDict andCategory:(NSString *)category andBaseTypes:(NSDictionary *)baseTypes;
-(NSArray *)convertWithValue:(double)inputVal andUnit:(NSString *)unit;

@end
