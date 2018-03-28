//
//  NSString(TS_Compare).h
//  HGShopAssistant
//
//  Created by XiaoShan on 10/10/15.
//  Copyright © 2015 Higegou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(TS_Compare)

- (BOOL)startWith:(NSString *)s1;

- (BOOL)endWith:(NSString *)s1;

- (NSString *)trim;

- (BOOL)isEqualToStringIgnoreCase:(NSString *)aString;

@end