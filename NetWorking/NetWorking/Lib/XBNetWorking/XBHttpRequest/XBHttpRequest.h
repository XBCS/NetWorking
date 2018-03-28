//
//  XBHttpRequest.h
//  NetWorking
//
//  Created by 李泽宇 on 2018/3/27.
//  Copyright © 2018年 丶信步沧桑. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AFHTTPRequestOperation.h"
//#import <AFURLSessionManager.h>

@class XBHttpRequest;



typedef NS_ENUM(NSInteger, RequestMethodType) {
    RequestMethodTypeUnKonw = 0,
    RequestMethodTypeGet = 1,
    RequestMethodTypePost = 2
};
typedef NS_ENUM(NSUInteger, HttpSessionTaskType) {
    HttpSessionTaskType_Normal   = 0,
    HttpSessionTaskType_DownLoad = 1,
    HttpSessionTaskType_UpLoad   = 2,
};

typedef void (^XBHttpRequestSucceedBlock) (XBHttpRequest *request, NSDictionary *result);
typedef void (^XBHttpRequestFailedBlock) (XBHttpRequest *request, NSError *error);


@interface XBHttpRequest : NSObject

@property (nonatomic, assign) RequestMethodType methodType;
@property (nonatomic, assign) HttpSessionTaskType taskType;

@property (nonatomic, copy) NSString *action;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

+ (XBHttpRequest *)requestWithMethodType:(RequestMethodType)methodType;
+ (XBHttpRequest *)requestWithMethodType:(RequestMethodType)methodType timeOutInterval:(NSTimeInterval)interval;
- (void)sendWithSucceedBlock:(XBHttpRequestSucceedBlock)succeedBlock failed:(XBHttpRequestFailedBlock)failedBlock;
- (void)cancel;

- (void)sendSessionWithSucceedBlock:(XBHttpRequestSucceedBlock)succeedBlock
                          failedBlock:(XBHttpRequestFailedBlock)failedBlock;



@end
