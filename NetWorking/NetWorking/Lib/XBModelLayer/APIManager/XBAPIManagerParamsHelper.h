//
//  XBAPIManagerParamsHelper.h
//  NetWorking
//
//  Created by 李泽宇 on 2018/3/28.
//  Copyright © 2018年 丶信步沧桑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBAPIManagerParamsHelper : NSObject

+ (NSDictionary *)appendDeviceParamsInto:(NSDictionary *)businessParams;

+ (NSDictionary *)appendTokenInto:(NSDictionary *)params;

+ (NSDictionary *)appendPostRequestSecurityCodeInto:(NSDictionary *)params;

@end
