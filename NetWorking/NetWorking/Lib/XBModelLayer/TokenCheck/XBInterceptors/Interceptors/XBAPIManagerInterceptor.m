//
//  XBAPIManagerInterceptor.m
//  NetWorking
//
//  Created by 李泽宇 on 2018/4/9.
//  Copyright © 2018年 丶信步沧桑. All rights reserved.
//

#import "XBAPIManagerInterceptor.h"
#import "NSDictionary(TS_Value).h"


@interface XBAPIManagerInterceptor () {
    BOOL _isDevLoginAPIManagerLoading;
    NSMutableArray *_interceptedInvocations;

}
@end


@implementation XBAPIManagerInterceptor

#pragma mark - public - init

- (instancetype)init {
    self = [super init];
    if (self) {
        _interceptedInvocations = [NSMutableArray array];
    }
    return self;
}

#pragma mark - public - interceptor methods
- (void)requestWillStart:(XBAPIManagerInterceptorModel *)interceptorModel {
    [interceptorModel.interceptedInfo.originalInvocation invoke];
}

- (void)requestDidSucceed:(XBAPIManagerInterceptorModel *)interceptorModel {
    NSMutableDictionary *apiResponseData = [interceptorModel.responseData mutableCopy];
    NSString *statusCode = [apiResponseData stringValueForKey:kAPIResponseParam_status
                                                 defaultValue:@""];
    
    NSString *msg = [apiResponseData stringValueForKey:kAPIResponseParam_msg defaultValue:@""];
    
    NSString *token = [apiResponseData stringValueForKey:@"token" defaultValue:@""];
    
    if (token.length > 0) {
        
        [[NSUserDefaults standardUserDefaults] setValue:token forKey:kUserToken];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //Token无效
    if ([statusCode isEqualToString:kAPITokenInvalidStatus]) {
        
        NSString *localToken = [[NSUserDefaults standardUserDefaults] objectForKey:kUserToken];
        
        //当前是未登录状态，则直接跳转到登录页面
        if ([msg isEqualToString:@"账号已在其他设备上登录，请重新登录后操作。"]) {
            
            // 弹框...
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserToken];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        } else if (localToken.length <= 0) {
            
            // 弹出登录页面..
            
        } else {
            //当前是已登录状态，则先提示再跳转到登录页面
            
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserToken];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        [apiResponseData removeObjectForKey:kAPIResponseParam_msg];
        
    } else if (statusCode.intValue == kAPIUserAccountIsChecking) {
        //账号处于审核中
        
        //跳转审核页面
        
        
    } else if (statusCode.intValue == kAPIUserAccountIsCheckingFailed || statusCode.intValue == kAPIUserAccountIsCheckingFailed2) {
        
        //    账号审核不通过
        // 相关逻辑..
        
    } //else if ...
    
    NSInvocation *originalInvocation = interceptorModel.interceptedInfo.originalInvocation;
    if (!!apiResponseData) {
        
        if (![NSStringFromSelector(originalInvocation.selector) isEqualToString:@"aspects__doSessionRequestAsynchrously"]) {
            
            [originalInvocation setArgument:&apiResponseData atIndex:3];
            [originalInvocation retainArguments];
        }
        
    }
    
    [interceptorModel.interceptedInfo.originalInvocation invoke];
}

- (void)requestDidFail:(XBAPIManagerInterceptorModel *)interceptorModel {
    [interceptorModel.interceptedInfo.originalInvocation invoke];
}

#pragma mark - ################## Private methods ##################

- (NSString *)apiMethodNameOfInterceptedAPIManager:(XBBaseAPIManager *)apiManager {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    NSString *apiMethodName = nil;
    NSMethodSignature *apiMethodNameMethodSignature = [[XBBaseAPIManager class]
                                                       instanceMethodSignatureForSelector:@selector(apiMethodName)];
    NSInvocation * apiMethodNameMethodInvocation = [NSInvocation invocationWithMethodSignature:apiMethodNameMethodSignature];
    [apiMethodNameMethodInvocation setTarget:apiManager];
    [apiMethodNameMethodInvocation setSelector:@selector(apiMethodName)];
    [apiMethodNameMethodInvocation invoke];
    [apiMethodNameMethodInvocation getReturnValue:&apiMethodName];
    
    return apiMethodName;
    
#pragma clang diagnostic pop
}





@end
