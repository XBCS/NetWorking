//
//  XBHttpRequest.m
//  NetWorking
//
//  Created by 李泽宇 on 2018/3/27.
//  Copyright © 2018年 丶信步沧桑. All rights reserved.
//

#import "XBHttpRequest.h"
#import "XBHttpGetRequest.h"
#import "XBHttpPostRequest.h"
#import "XBHttpPostRequestMultipartForm.h"
#import "XBNetWorkingDefine.h"
#import "XBHttpRequestManager.h"

@interface XBHttpRequest() {
//    AFHTTPRequestOperation *_requestOperation;
}

@property (nonatomic, strong) NSURLSessionTask *task;

@end


@implementation XBHttpRequest

- (instancetype)init {
    if (self == [super init]) {
        self.timeoutInterval = kXBHttpRequestTimeOutInterval;
    }
    return self;
}

+ (XBHttpRequest *)requestWithMethodType:(RequestMethodType)methodType {
    return [self requestWithMethodType:methodType timeOutInterval:0];
}

+ (XBHttpRequest *)requestWithMethodType:(RequestMethodType)methodType timeOutInterval:(NSTimeInterval)interval {
    
    XBHttpRequest *request = nil;
    
    switch (methodType) {
        case RequestMethodTypeUnKonw:
            break;
        case RequestMethodTypeGet:
            request = [[XBHttpGetRequest alloc] init];
            break;
        case RequestMethodTypePost:
            request = [[XBHttpPostRequest alloc] init];
            break;
            
        default:
            break;
    }
    request.methodType = methodType;
    request.timeoutInterval = interval == 0 ? kXBHttpRequestTimeOutInterval : interval;
    
    return request;
}

- (void)sendWithSucceedBlock:(XBHttpRequestSucceedBlock)succeedBlock failed:(XBHttpRequestFailedBlock)failedBlock {
    
//    _requestOperation = [[XBHttpRequestManager sharedInstance]
//                         sendRequestAsyncrously:self successBlock:succeedBlock failBlock:failedBlock];
    
}

- (void)sendSessionWithSucceedBlock:(XBHttpRequestSucceedBlock)succeedBlock failedBlock:(XBHttpRequestFailedBlock)failedBlock {
    
    self.task = [[XBHttpRequestManager sharedInstance] sendSessionRequestAsyncrously:self succeedBlock:succeedBlock failedBlock:failedBlock];
    
}


- (void)cancel {
    
//    [_requestOperation cancel];
//    _requestOperation = nil;
    [self.task cancel];
}


@end
