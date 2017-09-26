//
//  NSDictionary+NullReplacementDic.m
//  nulldic
//
//  Created by Kaushik on 26/09/17.
//  Copyright © 2017 BacancyMac-i7. All rights reserved.
//

#import "NSDictionary+NullReplacementDic.h"
#import "NSArray+NullReplacementArr.h"

@implementation NSDictionary (NullReplacementDic)
- (NSDictionary *)dictionaryByReplacingNullsWithBlanks {
    const NSMutableDictionary *replaced = [self mutableCopy];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for (NSString *key in self) {
        id object = [self objectForKey:key];
        if (object == nul) [replaced setObject:blank forKey:key];
        else if ([object isKindOfClass:[NSDictionary class]]) [replaced setObject:[object dictionaryByReplacingNullsWithBlanks] forKey:key];
        else if ([object isKindOfClass:[NSArray class]]) [replaced setObject:[object arrayByReplacingNullsWithBlanks] forKey:key];
    }
    return [NSDictionary dictionaryWithDictionary:[replaced copy]];
}
@end
