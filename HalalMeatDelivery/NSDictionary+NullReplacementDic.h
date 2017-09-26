//
//  NSDictionary+NullReplacementDic.h
//  nulldic
//
//  Created by Kaushik on 26/09/17.
//  Copyright © 2017 BacancyMac-i7. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NullReplacementDic)
- (NSDictionary *)dictionaryByReplacingNullsWithBlanks;

@end
