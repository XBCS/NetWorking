//
//  NSString(TS_Compare).m
//  HGShopAssistant
//
//  Created by XiaoShan on 10/10/15.
//  Copyright © 2015 Higegou. All rights reserved.
//

#import "NSString(TS_Compare).h"

#define spacePlaceHolderChar (@" ")

@implementation NSString(Utilities)

- (BOOL)startWith:(NSString *)s1 {
    if (!s1 || [@"" isEqualToString:s1] || !self || [@"" isEqualToString:self]) {
        return NO;
    }
    if ([self isEqualToString:s1]) {
        return YES;
    }
    NSRange _range = [self rangeOfString:s1];
    return (_range.location == 0 && _range.length > 0);
}

- (BOOL)endWith:(NSString *)s1 {
    if (!s1 || [@"" isEqualToString:s1] || !self || [@"" isEqualToString:self]) {
        return NO;
    }
    if ([self isEqualToString:s1]) {
        return YES;
    }
    NSRange _range = [self rangeOfString:s1];
    return (_range.location == (self.length-s1.length) && _range.length > 0);
}


- (NSString *)trim {
	NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	return str;
}

- (BOOL)isEqualToStringIgnoreCase:(NSString *)aString {
    return [[self lowercaseString] isEqualToString:[aString lowercaseString]];
}

@end