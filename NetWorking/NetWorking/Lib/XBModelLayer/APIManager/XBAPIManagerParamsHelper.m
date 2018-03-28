//
//  XBAPIManagerParamsHelper.m
//  NetWorking
//
//  Created by 李泽宇 on 2018/3/28.
//  Copyright © 2018年 丶信步沧桑. All rights reserved.
//

#import "XBAPIManagerParamsHelper.h"
#import "XBAPIManagerDefine.h"
#import "NSDictionary(TS_Sort).h"
#import "NSDictionary(TS_Value).h"

#define kDevicePrivateKeyFirst              (2)
#define kDevicePrivateKeySecond             (7)
#define kDevicePrivateKeyThird              (3)
#define kDevicePrivateKeyFourth             (6)

#define kSecurityCodePrivateKey             (@"NetWorking987")


@implementation XBAPIManagerParamsHelper


+ (NSDictionary *)appendDeviceParamsInto:(NSDictionary *)businessParams {
    NSMutableDictionary *allParams = [[NSMutableDictionary alloc] init];
    
    if (businessParams.count > 0) {
        [allParams setValuesForKeysWithDictionary:businessParams];
    }
    
    //设备ID
    NSString *deviceIDParam = [allParams stringValueForKey:kAPIDevParam_DeviceID defaultValue:@""];
    if (deviceIDParam.length <= 0) {
        NSString *deviceID = [FCUUID uuidForDevice];
        allParams[kAPIDevParam_DeviceID] = deviceID.length > 0 ? deviceID : @"";
        deviceIDParam = allParams[kAPIDevParam_DeviceID];
    }
    
    //DeviceID校验码
    //    if (deviceIDParam.length > 0) {
    //        NSString *checkStr = [[self class] makeDeviceIdCheckString:deviceIDParam];
    //        NSString *md5CheckStr = [checkStr toMD5EncodedString];
    //        NSString *md5DevID = allParams[kAPIDevParam_DeviceIdCheckCode];
    
    //        if (md5DevID.length <= 0 && md5CheckStr.length > 0) {
    ////            allParams[kAPIDevParam_DeviceIdCheckCode] = md5CheckStr;
    //        }
    //    }
    
    //marketCode
    NSString *marketCodeParam = [allParams stringValueForKey:kAPIDevParam_MargketCode defaultValue:@""];
    if (marketCodeParam.length <= 0) {
        NSString *marketCode = [BSMarketCodeHelper marketCode];
        allParams[kAPIDevParam_MargketCode] = marketCode.length > 0 ? marketCode : @"";
    }
    
    //appVersion
    NSString *appVersionParam = [allParams stringValueForKey:kAPIDevParam_AppVersion defaultValue:@""];
    if (appVersionParam.length <= 0) {
        NSDictionary *infoDictionary = [[NSBundle bundleForClass:self.class] infoDictionary];
        NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        
        if (appVersion.length <= 0) {
            appVersion = @"";
        }
        allParams[kAPIDevParam_AppVersion] = appVersion;
    }
    
    //osVersion
    NSString *osVersionParam = [allParams stringValueForKey:kAPIDevParam_OSVersion defaultValue:@""];
    if (osVersionParam.length <= 0) {
        NSString *iOSVersion = [[UIDevice currentDevice] systemVersion];
        allParams[kAPIDevParam_OSVersion] = iOSVersion.length > 0 ? iOSVersion : @"";
    }
    
    //model
    NSString *modelParam = [allParams stringValueForKey:kAPIDevParam_Model defaultValue:@""];
    if (modelParam.length <= 0) {
        NSString *deviceModel = [[UIDevice currentDevice] hardwareDescription];
        allParams[kAPIDevParam_Model] = deviceModel.length > 0 ? deviceModel : @"";
    }
    
    //deviceType
    NSString *deviceTypeParam = [allParams stringValueForKey:kAPIDevParam_DeviceType defaultValue:@""];
    if (deviceTypeParam.length <= 0) {
        allParams[kAPIDevParam_DeviceType] = [@(0) stringValue];//0表示iOS平台
    }
    
    //IDFA
    NSString *idfaParam = [allParams stringValueForKey:kAPIDevParam_IDFA defaultValue:@""];
    if (idfaParam.length <= 0) {
        NSString *idfa = nil;
        
        if ([ASIdentifierManager sharedManager].isAdvertisingTrackingEnabled) {
            idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        } else {
            idfa = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        }
        idfa = idfa.length > 0 ? idfa : @"";
        allParams[kAPIDevParam_IDFA] = idfa;
    }
    
    NSString *push_Token = [[NSUserDefaults standardUserDefaults] objectForKey:kUploadPushTokenParam_PushToken];
    
#if TARGET_IPHONE_SIMULATOR
    DLog(@"run on simulator");
    if (push_Token.length <= 0) {
        push_Token = @"asdfsd";
    }
#define SIMULATOR_TEST
#else
    //不定义SIMULATOR_TEST这个宏
    DLog(@"run on device");
#endif
    
    allParams[kUploadPushTokenParam_PushToken] = push_Token;
    
    
    
    return allParams;
}

+ (NSDictionary *)appendTokenInto:(NSDictionary *)params {
    NSMutableDictionary *allParams = [[NSMutableDictionary alloc] init];
    
    if (params.count > 0) {
        [allParams setValuesForKeysWithDictionary:params];
    }
    
    [allParams removeObjectForKey:kAPITokenParam];
    //    BBTUserInfoModel *userInfoModel = BBTUserInfoModelHelper.userInfoModel;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:kToken];
    
    allParams[kAPITokenParam] = token > 0 ? token : @"";
    
    return allParams;
}

+ (NSDictionary *)appendPostRequestSecurityCodeInto:(NSDictionary *)params {
    NSMutableDictionary *allParams = [[NSMutableDictionary alloc] init];
    
    if (params.count > 0) {
        [allParams setValuesForKeysWithDictionary:params];
    }
    
    //Post request security code
    NSString *postRequestCheckCode = [self getPostRequestSecurityCodeWithOriginalParams:allParams];
    
    if (!!postRequestCheckCode) {
        //        allParams[kAPIDevParam_PostRequestSecurityCode] = postRequestCheckCode;
    }
    
    return allParams;
}

#pragma mark - private methods

+ (NSString *)makeDeviceIdCheckString:(NSString *)deviceId {
    NSString *privateKey = @"";
    NSRange range;
    
    if (deviceId.length > kDevicePrivateKeyFirst) {
        range = NSMakeRange(kDevicePrivateKeyFirst, 1);
        privateKey = [privateKey stringByAppendingString:[deviceId substringWithRange:range]];
    }
    if (deviceId.length > kDevicePrivateKeySecond) {
        range = NSMakeRange(kDevicePrivateKeySecond, 1);
        privateKey = [privateKey stringByAppendingString:[deviceId substringWithRange:range]];
    }
    if (deviceId.length > kDevicePrivateKeyThird) {
        range = NSMakeRange(kDevicePrivateKeyThird, 1);
        privateKey = [privateKey stringByAppendingString:[deviceId substringWithRange:range]];
    }
    if (deviceId.length > kDevicePrivateKeyFourth) {
        range = NSMakeRange(kDevicePrivateKeyFourth, 1);
        privateKey = [privateKey stringByAppendingString:[deviceId substringWithRange:range]];
    }
    
    NSString *checkString = [NSString stringWithFormat:@"%@%@", deviceId, privateKey];
    
    return checkString;
}

+ (NSString *)getPostRequestSecurityCodeWithOriginalParams:(NSDictionary *)orginalParam {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (orginalParam.count > 0) {
        [params setValuesForKeysWithDictionary:orginalParam];
    }
    
    //    if ([params stringValueForKey:kAPIDevParam_PostRequestSecurityCode defaultValue:@""].length > 0) {
    //        [params removeObjectForKey:kAPIDevParam_PostRequestSecurityCode];
    //    }
    
    NSString *joinedComponents = [params componentsSortedByKeyOrder:NSOrderedAscending andJoinedByString:@"&"];
    joinedComponents = [joinedComponents stringByAppendingString:kSecurityCodePrivateKey];
    NSData *data = [joinedComponents dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Param = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    return [base64Param toMD5EncodedString];
}


@end
