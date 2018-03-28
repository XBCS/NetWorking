//
//  XBBaseAPIManager.m
//  
//
//  Created by 李泽宇 on 2018/3/28.
//

#import "XBBaseAPIManager.h"
#import "XBAPIManagerOverideMethods.h"


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
    _params = [BSAPIManagerParamsHelper appendTokenInto:_params];
    if (self.needSecurePostRequest &&  self.request.methodType == TSHttpRequestMethodTypePost) {
        _params = [BSAPIManagerParamsHelper appendPostRequestSecurityCodeInto:_params];
    }
    _request.params = _params;
    _request.userInfo = self.userInfo;
    
    [_request sendSessionWithSuccessBlock:^(TSHttpRequest *request, NSDictionary *result) {
        _isLoading = NO;
        [self request:request didSucceedToLoadData:result];
        
    } failBlock:^(TSHttpRequest *request, NSError *error) {
        _isLoading = NO;
        [self request:request didFailToLoadWithError:error];
    }];
}




- (NSString *)apiURL {
    
    return nil;
}


@end
