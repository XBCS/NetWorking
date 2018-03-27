//
//  NSObject+ToJSONString.m
//  NetWorking
//
//  Created by 李泽宇 on 2018/3/27.
//  Copyright © 2018年 丶信步沧桑. All rights reserved.
//

#import "NSObject+ToJSONString.h"

@implementation NSObject (ToJSONString)

- (NSString *)JSONString {
    
    NSError *error = nil;
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    
    return error == nil ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : nil;
    
}

@end
