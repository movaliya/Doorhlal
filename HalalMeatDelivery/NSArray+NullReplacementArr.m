//
//  NSArray+NullReplacementArr.m
//  nulldic
//
//  Created by Kaushik on 26/09/17.
//  Copyright © 2017 BacancyMac-i7. All rights reserved.
//

#import "NSArray+NullReplacementArr.h"
#import "NSDictionary+NullReplacementDic.h"
@implementation NSArray (NullReplacementArr)
- (NSArray *)arrayByReplacingNullsWithBlanks  {
    NSMutableArray *replaced = [self mutableCopy];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    for (int idx = 0; idx < [replaced count]; idx++) {
        id object = [replaced objectAtIndex:idx];
        if (object == nul) [replaced replaceObjectAtIndex:idx withObject:blank];
        else if ([object isKindOfClass:[NSDictionary class]]) [replaced replaceObjectAtIndex:idx withObject:[object dictionaryByReplacingNullsWithBlanks]];
        else if ([object isKindOfClass:[NSArray class]]) [replaced replaceObjectAtIndex:idx withObject:[object arrayByReplacingNullsWithBlanks]];
    }
    return [replaced copy];
}
@end
