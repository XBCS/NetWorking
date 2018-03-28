//
//  XBErrorHelper.m
//  NetWorking
//
//  Created by 李泽宇 on 2018/3/28.
//  Copyright © 2018年 丶信步沧桑. All rights reserved.
//

#import "XBErrorHelper.h"

#define kXBAPIManagerParseModelErrorDomain      (@"com.business.error.apimanager.parsemodel")

@implementation XBErrorHelper


+ (NSError *)XBParseModelError {
    
    NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey : @"解析Model数据失败"};
    NSError *error = [[NSError alloc] initWithDomain:kXBAPIManagerParseModelErrorDomain code:NSURLErrorCannotParseResponse userInfo:userInfo];
    
    return error;
}


@end
