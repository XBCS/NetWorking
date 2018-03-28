//
//  NSDictionary(TS_Value).h
//  HGShopAssistant
//
//  Created by XiaoShan on 10/10/15.
//  Copyright © 2015 Higegou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(TS_Value)

- (id)objectForKey:(NSString *)key defalutObj:(id)defaultObj;

- (id)objectForKey:(id)aKey ofClass:(Class)aClass defaultObj:(id)defaultObj;

- (int)intValueForKey:(NSString *)key defaultValue:(int)defaultValue;

- (float)floatValueForKey:(NSString *)key defaultValue:(float)defaultValue;

- (double)doubleValueForKey:(NSString *)key defaultValue:(double)defaultValue;

- (long)longValueForKey:(NSString *)key defaultValue:(long)defaultValue;

- (long long)longlongValueForKey:(NSString *)key defaultValue:(long long)defaultValue;

- (NSString *)stringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue;

- (NSArray *)arrayValueForKey:(NSString *)key defaultValue:(NSArray *)defaultValue;

- (NSDictionary *)dictionaryValueForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue;

@end
