//
//  XBAPIManagerInterceptorModel.m
//  NetWorking
//
//  Created by 李泽宇 on 2018/4/9.
//  Copyright © 2018年 丶信步沧桑. All rights reserved.
//

#import "XBAPIManagerInterceptorModel.h"

@implementation XBAPIManagerInterceptorModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{@"InterceptorClassName" : @"interceptorClassName"}];
}

@end
