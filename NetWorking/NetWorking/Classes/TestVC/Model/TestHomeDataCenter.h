//
//  TestHomeDataCenter.h
//  NetWorking
//
//  Created by 李泽宇 on 2018/3/28.
//  Copyright © 2018年 丶信步沧桑. All rights reserved.
//

#import "XBBaseDataCenter.h"
#import "TestHomeAPIManager.h"

@protocol TestHomeDataCenterDelegate <NSObject>

- (void)requestTestListSucceed:(TestHomeBaseModel *)baseModel;
- (void)requestTestListFailed:(NSString *)msg;

@end

@interface TestHomeDataCenter : XBBaseDataCenter <XBAPIManagerDelegate>

@property (nonatomic, weak) id<TestHomeDataCenterDelegate> delegate;


- (void)requestTestList;


@end
