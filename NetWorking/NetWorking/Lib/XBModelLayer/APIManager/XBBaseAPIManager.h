//
//  XBBaseAPIManager.h
//  
//
//  Created by 李泽宇 on 2018/3/28.
//

#import <Foundation/Foundation.h>
#import "XBAPIManagerDelegate.h"
#import "XBAPIManagerDefine.h"
#import "XBHttpRequest.h"
#import "XBHttpGetRequest.h"
#import "XBHttpPostRequest.h"


@interface XBBaseAPIManager : NSObject

@property (nonatomic, weak) id<XBAPIManagerDelegate> delegate;

@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, strong) NSArray *formDataArray;
@property (nonatomic, assign) BOOL needSecurePostRequest;
@property (nonatomic, assign) BOOL isLoading;


- (instancetype)initWithDelegate:(id<XBAPIManagerDelegate>)delegate params:(NSDictionary *)params;

- (void)requestAsynchrously;
- (void)requestAsynchrouslyWithTaskType:(HttpSessionTaskType)taskType;
- (void)cancelRequest;

// 返回BaseURL
- (NSString *)apiURL;


@end
