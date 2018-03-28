//
//  TestHomeAPIManager.m
//  NetWorking
//
//  Created by 李泽宇 on 2018/3/28.
//  Copyright © 2018年 丶信步沧桑. All rights reserved.
//

#import "TestHomeAPIManager.h"
#import "XBErrorHelper.h"

@implementation TestHomeAPIManager


- (NSString *)apiMethodName {
    return kAPINameTestHome;
}

- (RequestMethodType)apiMethodType {
    
    return RequestMethodTypeGet;
}

- (void)request:(XBHttpRequest *)request succeededToLoadData:(NSDictionary *)data {
    
    if ([self.delegate respondsToSelector:@selector(apiManager:succeededToLoadModel:)]) {
        NSError *parseError = nil;
        TestHomeBaseModel *model = [[TestHomeBaseModel alloc] initWithDictionary:data error:&parseError];
        
        
        if (!parseError) {
            [self.delegate apiManager:self succeededToLoadModel:model];
        } else {
            [self.delegate apiManager:self failedToLoadDataWithError:[XBErrorHelper XBParseModelError]];
        }
    }
    
}

- (void)request:(XBHttpRequest *)request failedToLoadWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(apiManager:failedToLoadDataWithError:)]) {
        [self.delegate apiManager:self failedToLoadDataWithError:error];
    }
}



@end
