//
//  DLog.h
//  NetWorking
//
//  Created by 李泽宇 on 2018/3/28.
//  Copyright © 2018年 丶信步沧桑. All rights reserved.
//

#ifndef DLog_h
#define DLog_h


#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"方法名%s [第%d行] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
//#define DLog(fmt, ...) NSLog((@"方法名%s [第%d行] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define DLog(...)
#endif


#endif /* DLog_h */
