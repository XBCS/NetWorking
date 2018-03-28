//
//  TestHomeDataCenter.m
//  NetWorking
//
//  Created by 李泽宇 on 2018/3/28.
//  Copyright © 2018年 丶信步沧桑. All rights reserved.
//

#import "TestHomeDataCenter.h"

@interface TestHomeDataCenter ()
@property (nonatomic, strong) TestHomeAPIManager *apiManager;
@end


@implementation TestHomeDataCenter

- (void)requestTestList {
    [self.apiManager cancelRequest];
    [self.apiManager requestAsynchrously];
}

- (void)apiManager:(XBBaseAPIManager *)apiManager succeededToLoadModel:(id)model {
    if (apiManager == self.apiManager) {
        TestHomeBaseModel *listModel = (TestHomeBaseModel *)model;
        
        if (listModel.code == kJSONModelStatusOk) {
            if ([self.delegate respondsToSelector:@selector(requestTestListSucceed:)]) {
                [self.delegate requestTestListSucceed:listModel];
            }
        } else {
            [self requestTestListFailedWithMsg:listModel.message];
        }
    }
}

- (void)apiManager:(XBBaseAPIManager *)apiManager failedToLoadDataWithError:(NSError *)error {
    if (apiManager == self.apiManager) {
        [self requestTestListFailedWithMsg:NSLocalizedString(@"app_network_not_reachable", nil)];
    }
}

#pragma mark ####################### Private #######################

- (void)requestTestListFailedWithMsg:(NSString *)msg {
    if ([self.delegate respondsToSelector:@selector(requestTestListFailed:)]) {
        [self.delegate requestTestListFailed:msg];
    }
}


- (TestHomeAPIManager *)apiManager {
    if (!_apiManager) {
        _apiManager = [[TestHomeAPIManager alloc] initWithDelegate:self params:nil];
    }
    return _apiManager;
    
}

@end
