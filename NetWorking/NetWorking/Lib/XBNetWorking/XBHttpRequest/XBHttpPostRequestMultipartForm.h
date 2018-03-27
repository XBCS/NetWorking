//
//  XBHttpPostRequestMultipartForm.h
//  NetWorking
//
//  Created by 李泽宇 on 2018/3/27.
//  Copyright © 2018年 丶信步沧桑. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol XBMultipartFormDataProtocol <NSObject>
@end

@interface XBHttpPostRequestMultipartForm : NSObject <XBMultipartFormDataProtocol>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, strong) NSData *fileData;

@end
