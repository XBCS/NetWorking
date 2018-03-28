//
//  XBAPIManagerOverideMethods.h
//  NetWorking
//
//  Created by 李泽宇 on 2018/3/28.
//  Copyright © 2018年 丶信步沧桑. All rights reserved.
//

#import "XBHttpRequest.h"

@protocol XBAPIManagerOverideMethods <NSObject>

@required

- (NSString *)apiMethodName;

- (RequestMethodType)apiMethodType;

- (void)request:(XBHttpRequest *)request succeededToLoadData:(NSDictionary *)data;

- (void)request:(XBHttpRequest *)request failedToLoadWithError:(NSError *)error;


@end
