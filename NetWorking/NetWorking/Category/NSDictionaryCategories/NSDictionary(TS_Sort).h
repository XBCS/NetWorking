//
//  NSDictionary(TS_Sort).h
//  HGShopAssistant
//
//  Created by XiaoShan on 10/10/15.
//  Copyright © 2015 Higegou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(TS_Sort)

- (NSString *)componentsSortedByKeyOrder:(NSComparisonResult)order andJoinedByString:(NSString *)separator;

@end
