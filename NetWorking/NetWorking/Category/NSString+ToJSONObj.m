//
//  NSString+ToJSONObj.m
//  NetWorking
//
//  Created by 李泽宇 on 2018/3/27.
//  Copyright © 2018年 丶信步沧桑. All rights reserved.
//

#import "NSString+ToJSONObj.h"

@implementation NSString (ToJSONObj)

- (id)JSONValue {
    
    NSString *jsonString = [NSString stringWithCString:[self UTF8String] encoding:NSUTF8StringEncoding];
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
//    __autoreleasing
    NSError *error = nil;
    
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    return error == nil ? result : nil;
}



@end
