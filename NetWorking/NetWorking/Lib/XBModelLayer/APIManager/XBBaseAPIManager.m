//
//  XBBaseAPIManager.m
//  
//
//  Created by 李泽宇 on 2018/3/28.
//

#import "XBBaseAPIManager.h"
#import "XBAPIManagerDefine.h"
#import "XBAPIManagerOverideMethods.h"
#import "XBAPIManagerParamsHelper.h"
#import "BSSettingInformation.h"
#import "BSSettingInfomationDefine.h"

@interface XBBaseAPIManager ()

@property (nonatomic, weak) id<XBAPIManagerOverideMethods> childAPIManager;
@property (nonatomic, strong) XBHttpRequest *request;

@end



@implementation XBBaseAPIManager

- (instancetype)init {
    
    if (self = [super init]) {
        
        if ([self conformsToProtocol:@protocol(XBAPIManagerOverideMethods)]) {
            self.childAPIManager = (id<XBAPIManagerOverideMethods>)self;
        } else {
            NSAssert(NO, @"BSBaseAPIManager的子类必须要实现BSAPIManagerOverideMethods protocol。");
        }
    }
    return self;
    
}

- (instancetype)initWithDelegate:(id<XBAPIManagerDelegate>)delegate params:(NSDictionary *)params {
    
    if ([self init]) {
        self.delegate = delegate;
        self.params = params;
    }
    return self;
    
}

- (void)requestAsynchrously {
    self.isLoading = YES;
    [self requestAsynchrouslyWithTaskType:HttpSessionTaskType_Normal];
}

- (void)requestAsynchrouslyWithTaskType:(HttpSessionTaskType)taskType {
    self.isLoading = YES;
    [self prepareRequestWithTaskType:taskType];
    [self doSessionRequestAsynchrously];
}

- (void)cancelRequest {
    [_request cancel];
    _request = nil;
}


#pragma mark - private - API request 相关

- (void)prepareRequestWithTaskType:(HttpSessionTaskType)taskType {
    _request = [XBHttpRequest requestWithMethodType:[self apiMethodType]];
    _request.action = [self apiURL];
    _request.params = _params;
    _request.taskType = taskType;
    //如果需要上传则在APIManager的formDataArray添加TSHttpPostRequestMultipartForm类型的数据
    if ([_request isKindOfClass:[XBHttpPostRequest class]] && self.formDataArray.count > 0) {
        XBHttpPostRequest *postRequest = (XBHttpPostRequest *)_request;
        postRequest.formDataArray = self.formDataArray;
    }
}

- (void)doSessionRequestAsynchrously {
    _params = [XBAPIManagerParamsHelper appendTokenInto:_params];
    if (self.needSecurePostRequest &&  self.request.methodType == RequestMethodTypePost) {
        _params = [XBAPIManagerParamsHelper appendPostRequestSecurityCodeInto:_params];
    }
    _request.params = _params;
    _request.userInfo = self.userInfo;
    
    [_request sendSessionWithSucceedBlock:^(XBHttpRequest *request, NSDictionary *result) {
        _isLoading = NO;
        [self request:request didSucceedToLoadData:result];
        
    } failedBlock:^(XBHttpRequest *request, NSError *error) {
        _isLoading = NO;
        [self request:request didFailToLoadWithError:error];
    }];
}

- (RequestMethodType)apiMethodType {
    return RequestMethodTypeGet;
}


- (NSString *)apiURL {
    NSString *host = nil;
    
    BOOL testMode = [BSSettingInformation sharedInstance].testModeEnable;
    if (testMode) {
        host = kXBDevelopmentHost;
    } else {
        host = kXBDistributionHost;
    }
    NSString *apiURL = [host stringByAppendingPathComponent:[self apiMethodName]];
    
    return apiURL;
}

- (NSString *)apiMethodName {
    return nil;
}

#pragma mark - private - API response 相关

- (void)request:(XBHttpRequest *)request didSucceedToLoadData:(NSDictionary *)data {
    [self.childAPIManager request:request succeededToLoadData:data];
}

- (void)request:(XBHttpRequest *)request didFailToLoadWithError:(NSError *)error {
    [self.childAPIManager request:request failedToLoadWithError:error];
}



@end
