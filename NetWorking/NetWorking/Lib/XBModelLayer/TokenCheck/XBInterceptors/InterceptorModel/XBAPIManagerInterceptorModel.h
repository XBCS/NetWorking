//
//  XBAPIManagerInterceptorModel.h
//  NetWorking
//
//  Created by 李泽宇 on 2018/4/9.
//  Copyright © 2018年 丶信步沧桑. All rights reserved.
//

#import "JSONModel.h"
#import <Aspects.h>
#import "XBBaseAPIManager.h"
#import "XBHttpRequest.h"

@interface XBAPIManagerInterceptorModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *interceptorClassName;
@property (nonatomic, strong) XBBaseAPIManager<Ignore> *interceptedAPIManager;
@property (nonatomic, strong) id<AspectInfo, Ignore> interceptedInfo;
@property (nonatomic, strong) XBHttpRequest<Ignore> *request;
@property (nonatomic, strong) NSDictionary<Ignore> *responseData;
@property (nonatomic, strong) NSError<Ignore> *responseError;

@end
