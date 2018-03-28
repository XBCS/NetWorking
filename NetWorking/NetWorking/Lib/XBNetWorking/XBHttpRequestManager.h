//
//  XBHttpRequestManager.h
//  NetWorking
//
//  Created by 李泽宇 on 2018/3/27.
//  Copyright © 2018年 丶信步沧桑. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBHttpRequest.h"

@interface XBHttpRequestManager : NSObject

+ (instancetype)sharedInstance;

//- (AFHTTPRequestOperation *)sendRequestAsyncrously:(XBHttpRequest *)request
//                                      succeedBlock:(XBHttpRequestSucceedBlock)successBlock
//                                         failedBlock:(XBHttpRequestFailedBlock)failedBlock;

- (NSURLSessionTask *)sendSessionRequestAsyncrously:(XBHttpRequest *)httpRequest
                                       succeedBlock:(XBHttpRequestSucceedBlock)succeedBlock
                                        failedBlock:(XBHttpRequestFailedBlock)faiedlBlock;



@end
