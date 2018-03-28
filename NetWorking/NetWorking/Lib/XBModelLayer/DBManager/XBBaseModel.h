//
//  XBBaseModel.h
//  NetWorking
//
//  Created by 李泽宇 on 2018/3/28.
//  Copyright © 2018年 丶信步沧桑. All rights reserved.
//

#import "JSONModel.h"

#define kJSONModelStatusOk    (0)
#define kBaseDataCenterDefaultIndex (@"0")

@interface XBBaseModel : JSONModel

@property (nonatomic, assign) int status;
@property (nonatomic, copy) NSString<Optional> *msg;

@end
