//
//  XBHttpPostRequest.h
//  NetWorking
//
//  Created by 李泽宇 on 2018/3/27.
//  Copyright © 2018年 丶信步沧桑. All rights reserved.
//

#import "XBHttpRequest.h"

@interface XBHttpPostRequest : XBHttpRequest

@property (nonatomic, strong) NSArray *formDataArray;

@end
