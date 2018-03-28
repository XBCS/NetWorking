//
//  NSDictionary(TS_Sort).m
//  HGShopAssistant
//
//  Created by XiaoShan on 10/10/15.
//  Copyright © 2015 Higegou. All rights reserved.
//

#import "NSDictionary(TS_Sort).h"

@implementation NSDictionary(TS_Sort)

- (NSString *)componentsSortedByKeyOrder:(NSComparisonResult)order andJoinedByString:(NSString *)separator {
    
    __block NSMutableArray *keyValueArray = [NSMutableArray array];
    __block NSString *keyValueStr = @"";
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *keyStr = (NSString *)key;
        NSString *objStr = (NSString *)obj;
        
        keyValueStr = [NSString stringWithFormat:@"%@=%@", keyStr, objStr];
        
        if (keyValueStr.length > 0) {
            [keyValueArray addObject:keyValueStr];
        }
    }];
    
    //按首字母升序对参数排序
    NSArray *sortArray = [keyValueArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *str1 = (NSString *)obj1;
        NSString *str2 = (NSString *)obj2;
        NSComparisonResult result = [str1 compare:str2];
        
        return result == -order;
    }];
    
    NSString *sortedAndJoinedStr = @"";
    if (sortArray.count > 0 && separator.length > 0) {
        sortedAndJoinedStr = [sortArray componentsJoinedByString:separator];
    }
    
    return sortedAndJoinedStr;
}

@end
