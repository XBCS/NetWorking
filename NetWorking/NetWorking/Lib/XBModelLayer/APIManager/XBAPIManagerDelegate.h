//
//  XBAPIManagerDelegate.h
//  NetWorking
//
//  Created by 李泽宇 on 2018/3/28.
//  Copyright © 2018年 丶信步沧桑. All rights reserved.
//


#import <Foundation/Foundation.h>

@class XBBaseAPIManager;

@protocol XBAPIManagerDelegate <NSObject>

- (void)apiManager:(XBBaseAPIManager *)apiManager succeededToLoadModel:(id)model;

- (void)apiManager:(XBBaseAPIManager *)apiManager failedToLoadDataWithError:(NSError *)error;

@end
