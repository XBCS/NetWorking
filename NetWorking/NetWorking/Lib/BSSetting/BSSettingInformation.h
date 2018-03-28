//
//  BSSettingInformation.h
//  EHaiTao-Master
//
//  Created by JiaLei on 15/5/6.
//  Copyright (c) 2015年 北京启能万维科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ BSResetSettingInfoBlock)();

@interface BSSettingInformation : NSObject

+ (BSSettingInformation *)sharedInstance;

- (void)resetSettingInfoIfNeeded:(BSResetSettingInfoBlock)resetBlock;

@property (nonatomic, assign) BOOL testModeEnable;
@property (nonatomic, assign) BOOL settingModeChanged;

@end
