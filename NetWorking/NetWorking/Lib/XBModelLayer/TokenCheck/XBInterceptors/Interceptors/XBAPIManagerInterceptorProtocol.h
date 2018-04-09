//
//  XBAPIManagerInterceptorProtocol.h
//  NetWorking
//
//  Created by 李泽宇 on 2018/4/9.
//  Copyright © 2018年 丶信步沧桑. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBAPIManagerInterceptorModel.h"

@protocol XBAPIManagerInterceptorProtocol <NSObject>

- (void)requestWillStart:(XBAPIManagerInterceptorModel *)interceptorModel;
- (void)requestDidSucceed:(XBAPIManagerInterceptorModel *)interceptorModel;
- (void)requestDidFail:(XBAPIManagerInterceptorModel *)interceptorModel;

@end
