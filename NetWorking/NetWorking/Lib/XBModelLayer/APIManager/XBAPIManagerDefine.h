//
//  XBAPIManagerDefine.h
//  NetWorking
//
//  Created by 李泽宇 on 2018/3/28.
//  Copyright © 2018年 丶信步沧桑. All rights reserved.
//

#ifndef XBAPIManagerDefine_h
#define XBAPIManagerDefine_h

#pragma mark - ################## API服务器地址 ##################

#define kXBDistributionHost                                                  (@"http://123.56.84.63:9012/")         //正式服务器地址
#define kXBDevelopmentHost                                                  (@"http://123.56.84.63:9012/")         //测试服务器地址

#pragma mark - ################## API通用参数列表 ##################


#define kAPIDevParam_DeviceID                                               (@"device_id")
#define kAPIDevParam_OSVersion                                              (@"os")
#define kAPIDevParam_MargketCode                                            (@"market")
#define kAPIDevParam_Model                                                  (@"model")
#define kAPIDevParam_PushToken                                              (@"push_token")
#define kAPIDevParam_AppVersion                                             (@"version")
#define kAPIDevParam_DeviceType                                             (@"device_type")
#define kAPIDevParam_IDFA                                                   (@"imei")
#define kAPITokenParam                                                      (@"token")

#define kAPIResponseParam_status                                            (@"status")
#define kAPIResponseParam_user_phone                                        (@"phone")
#define kAPIResponseParam_user                                              (@"user")
#define kAPIResponseParam_msg                                               (@"msg")

#define kAPITokenInvalidStatus                                              (@"10000")
#define kAPIParameterFailed                                                 (10002)
#define kAPIUserInfoNotExistStatus                                          (@"10006")
#define kAPIUserInfoHasExistStatus                                          (@"10007")
#define kAPIUserAccountIsChecking                                           (10011)

#define kAPIUserAccountIsCheckingFailed                                     (10015)
#define kAPIUserAccountIsCheckingFailed2                                    (10017)

#define kAPIRegisterIncompleteCarInformation                                (10031)
#define kAPIRegisterIncompleteUserInformation                               (10034)

#define kAPIRegisterWasReject                                               (20004)



#pragma mark - ################## API名称列表 ##################

#define kAPINameMeta                                                      (@"meta")
#define kAPINameAppUpgrade                                                  (@"app_version")
#define kAPINameUserLogin                                                   (@"login")
#define kAPINameUserRegister                                                (@"register")
#define kAPINameUploadPushToken                                             (@"dev_login")



#endif /* XBAPIManagerDefine_h */
