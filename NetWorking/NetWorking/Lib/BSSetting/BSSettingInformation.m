//
//  BSSettingInformation.m
//  EHaiTao-Master
//
//  Created by JiaLei on 15/5/6.
//  Copyright (c) 2015年 北京启能万维科技有限公司. All rights reserved.
//

#import "BSSettingInformation.h"
#import "BSSettingInfomationDefine.h"
#import "NSDictionary(TS_Value).h"
//#import "TSDatabase.h"
#import "DLog.h"

@implementation BSSettingInformation

+ (BSSettingInformation *)sharedInstance {
    static BSSettingInformation *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BSSettingInformation alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _testModeEnable = NO;
        _settingModeChanged = NO;
    }
    
    return self;
}

- (void)resetSettingInfoIfNeeded:(BSResetSettingInfoBlock)resetBlock {
    //加载本App在"设置"App里的配置信息
    [[BSSettingInformation sharedInstance] loadSettingInfoFormDefaults];
    
    if ([BSSettingInformation sharedInstance].settingModeChanged && !!resetBlock) {
        resetBlock();
    }
}

#pragma mark - Private

- (void)loadSettingInfoFormDefaults {
    [self loadInfoFromSettingsBundle];
    BOOL testMode = [[NSUserDefaults standardUserDefaults] boolForKey:kHGSettingKeyTestModeEnabled];
    self.testModeEnable = testMode;
    
    BOOL lastTestModeEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:kHGSettingKeyLastTestModeEnabled];
    
    if (self.testModeEnable != lastTestModeEnabled) {
        self.settingModeChanged = YES;
        [[NSUserDefaults standardUserDefaults] setBool:self.testModeEnable forKey:kHGSettingKeyLastTestModeEnabled];
    }
}

/*
 *获取setting.boundle 修改信息
 *初始化设置信息从setting。boundle中读取，更改设置信息需要从userDefault读取
 *参考http://ijure.org/wp/archives/179
 */
- (void)loadInfoFromSettingsBundle {
    DLog(@"从settingbundle注册信息");
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    
    if (!settingsBundle) {
        DLog(@"无法找到Settings.bundle");
        return;
    }
    
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferenceSpecifiers = [settings objectForKey:@"PreferenceSpecifiers"];
    
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferenceSpecifiers count]];
    
    for (NSDictionary *prefSpecification in preferenceSpecifiers) {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        
        if (key) {
            id currentObject = [userDefaults objectForKey:key];
            
            if (currentObject == nil) {
                // not readable: set value from Settings.bundle
                id objectToSet = [prefSpecification objectForKey:@"DefaultValue"];
                [defaultsToRegister setObject:objectToSet forKey:key];
                DLog(@"Setting object %@ for key %@", objectToSet, key);
            } else {
                DLog(@"Key %@ is readable (value: %@), nothing written to defaults.", key, currentObject);
            }
        }
    }
    
    [userDefaults registerDefaults:defaultsToRegister];
    [userDefaults synchronize];
}

@end
