//
//  XBBaseAPIManager+InterceptorDispatcher.m
//  NetWorking
//
//  Created by 李泽宇 on 2018/4/9.
//  Copyright © 2018年 丶信步沧桑. All rights reserved.
//

#import "XBBaseAPIManager+InterceptorDispatcher.h"
#import <Aspects.h>
#import "XBAPIManagerInterceptorModel.h"
#import "XBAPIManagerInterceptorProtocol.h"


#define kXBAPIManagerInterceptorsConfigFileName     (@"XBAPIManagerInterceptors")

static NSMutableDictionary *apiManagerInterceptors = nil;

@implementation XBBaseAPIManager (InterceptorDispatcher)

+ (void)load {
    
    apiManagerInterceptors = [NSMutableDictionary dictionary];
    NSArray *apiManagerInterceptorModels = [self interceptorModels];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

    //拦截BaseAPIManager的doRequestAsynchrously方法
    NSError *apiMgrRequestWillStartInterceptionError = nil;
    [XBBaseAPIManager aspect_hookSelector:@selector(doSessionRequestAsynchrously)
                              withOptions:AspectPositionInstead
                               usingBlock:^(id<AspectInfo> aspectInfo) {
                                   if ([aspectInfo.instance isKindOfClass:[XBBaseAPIManager class]]) {
                                       XBBaseAPIManager *apiManager = (XBBaseAPIManager *)(aspectInfo.instance);
                                       [self dipatchAPIMgrRequestWillStartInterceptionInfo:aspectInfo
                                                                     withInterceptorModels:apiManagerInterceptorModels
                                                                             andAPIManager:apiManager];
                                   }
                                   
                               } error:&apiMgrRequestWillStartInterceptionError];
    
    //拦截BaseAPIManager请求方法成功后
    NSError *apiMgrRequestDidSucceedInterceptionError = nil;
    [XBBaseAPIManager aspect_hookSelector:@selector(request:didSucceedToLoadData:)
                              withOptions:AspectPositionInstead
                               usingBlock:^(id<AspectInfo> aspectInfo, XBHttpRequest *request,
                                            NSDictionary *data) {
                                   
                                   if ([aspectInfo.instance isKindOfClass:[XBBaseAPIManager class]]) {
                                       XBBaseAPIManager *apiManager = (XBBaseAPIManager *)(aspectInfo.instance);
                                       [self dispatchAPIMgrRequestDidSucceedInterception:aspectInfo
                                                                     toInterceptorModels:apiManagerInterceptorModels
                                                                              apiManager:apiManager
                                                                                 request:request
                                                                            responseData:data];
                                   }
                                   
                               } error:&apiMgrRequestDidSucceedInterceptionError];
    
    //拦截BaseAPIManager请求方法失败后
    NSError *dispatchAPIMgrRequestDidFailInterceptionError = nil;
    [XBBaseAPIManager aspect_hookSelector:@selector(request:didFailedToLoadWithError:)
                              withOptions:AspectPositionInstead
                               usingBlock:^(id<AspectInfo> aspectInfo, XBHttpRequest *request,
                                            NSError *error) {
                                   
                                   if ([aspectInfo.instance isKindOfClass:[XBBaseAPIManager class]]) {
                                       XBBaseAPIManager *apiManager = (XBBaseAPIManager *)(aspectInfo.instance);
                                       [self dispatchAPIMgrRequestDidFailInterception:aspectInfo
                                                                  toInterceptorModels:apiManagerInterceptorModels
                                                                           apiManager:apiManager
                                                                              request:request
                                                                        responseError:error];
                                   }
                                   
                               } error:&dispatchAPIMgrRequestDidFailInterceptionError];
#pragma clang diagnostic pop
}


#pragma mark - private methods - 读取已配置的Interceptor集合

+ (NSArray *)interceptorModels {
    
    NSMutableArray *interceptors = nil;
    NSString *interceptorsConfigFilePath = [[NSBundle mainBundle]
                                            pathForResource:kXBAPIManagerInterceptorsConfigFileName
                                            ofType:@"plist"];
    NSFileManager *fm = [[NSFileManager alloc] init];
    
    
    if ([fm fileExistsAtPath:interceptorsConfigFilePath isDirectory:nil]) {
        NSArray *rawInterceptors = [[NSArray alloc] initWithContentsOfFile:interceptorsConfigFilePath];
        
        if (rawInterceptors.count > 0) {
            interceptors = [NSMutableArray array];
        }
        
        for (id rawInterceptor in rawInterceptors) {
            if ([rawInterceptor isKindOfClass:[NSDictionary class]]) {
                NSError *parseError = nil;
                XBAPIManagerInterceptorModel *interceptorModel = [[XBAPIManagerInterceptorModel alloc]
                                                                  initWithDictionary:rawInterceptor error:&parseError];
                
                if (!!interceptorModel) {
                    [interceptors addObject:interceptorModel];
                }
            }
        }
    }
 
    return interceptors;
}


#pragma mark - private methods - dispatch inteceptions to corresponding interceptors

+ (void)dipatchAPIMgrRequestWillStartInterceptionInfo:(id<AspectInfo>) aspectInfo
                                withInterceptorModels:(NSArray *)interceptorModels
                                        andAPIManager:(XBBaseAPIManager *)apiManager {
    for (XBAPIManagerInterceptorModel *interceptorModel in interceptorModels) {
        interceptorModel.interceptedAPIManager = apiManager;
        interceptorModel.interceptedInfo = (id<AspectInfo, Ignore>)aspectInfo;
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        [self sendMessageToInterceptor:interceptorModel
               withDispatchingSelector:@selector(requestWillStart:)];
#pragma clang diagnostic pop
    }
}

+ (void)dispatchAPIMgrRequestDidSucceedInterception:(id<AspectInfo>) aspectInfo
                                toInterceptorModels:(NSArray *)interceptorModels
                                         apiManager:(XBBaseAPIManager *)apiManager
                                            request:(XBHttpRequest *)request
                                       responseData:(NSDictionary *)responseData {
    
    for (XBAPIManagerInterceptorModel *interceptorModel in interceptorModels) {
        interceptorModel.request = request;
        interceptorModel.responseData = responseData;
        interceptorModel.interceptedAPIManager = apiManager;
        interceptorModel.interceptedInfo = (id<AspectInfo, Ignore>)aspectInfo;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        [self sendMessageToInterceptor:interceptorModel
               withDispatchingSelector:@selector(requestDidSucceed:)];
#pragma clang diagnostic pop
    }
}

+ (void)dispatchAPIMgrRequestDidFailInterception:(id<AspectInfo>) aspectInfo
                             toInterceptorModels:(NSArray *)interceptorModels
                                      apiManager:(XBBaseAPIManager *)apiManager
                                         request:(XBHttpRequest *)request
                                   responseError:(NSError *)responseError {
    
    for (XBAPIManagerInterceptorModel *interceptorModel in interceptorModels) {
        interceptorModel.request = request;
        interceptorModel.responseError = responseError;
        interceptorModel.interceptedAPIManager = apiManager;
        interceptorModel.interceptedInfo = (id<AspectInfo, Ignore>)aspectInfo;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        [self sendMessageToInterceptor:interceptorModel
               withDispatchingSelector:@selector(requestDidFail:)];
#pragma clang diagnostic pop
    }
}

#pragma mark - private methods - 通用Invocation调用方法

+ (void)sendMessageToInterceptor:(XBAPIManagerInterceptorModel *)interceptorModel
         withDispatchingSelector:(SEL)selector {
    
    if (interceptorModel.interceptorClassName.length > 0) {
        Class targetClass = NSClassFromString(interceptorModel.interceptorClassName);
        id<XBAPIManagerInterceptorProtocol> target = nil;
        id cachedInterceptor = [apiManagerInterceptors objectForKey:interceptorModel.interceptorClassName];
        
        if (!!cachedInterceptor && [cachedInterceptor conformsToProtocol:@protocol(XBAPIManagerInterceptorProtocol)]) {
            target = (id<XBAPIManagerInterceptorProtocol>)cachedInterceptor;
        } else {
            id tempTarget = [[targetClass alloc] init];
            
            if (![tempTarget conformsToProtocol:@protocol(XBAPIManagerInterceptorProtocol)]) {
                // 不遵守这个protocol的就让他crash，防止派生类乱来。
                NSAssert(NO, @"HGAPIManager的Interceptor-%@必须要实现BSAPIManagerInterceptorProtocol protocol。",
                         NSStringFromClass(targetClass));
                return;
            }
            target = (id<XBAPIManagerInterceptorProtocol>)tempTarget;
            
            if (!!target) {
                apiManagerInterceptors[interceptorModel.interceptorClassName] = target;
            }
        }
        
        NSMethodSignature *methodSignature = [targetClass instanceMethodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setTarget:target];
        [invocation setSelector:selector];
        [invocation setArgument:&interceptorModel atIndex:2];
        [invocation retainArguments];
        [invocation invoke];
    }
}



@end
