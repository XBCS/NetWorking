//
//  XBHttpRequestManager.m
//  NetWorking
//
//  Created by 李泽宇 on 2018/3/27.
//  Copyright © 2018年 丶信步沧桑. All rights reserved.
//

#import "XBHttpRequestManager.h"
#import "XBHttpGetRequest.h"
#import "XBHttpPostRequest.h"
#import "XBHttpPostRequestMultipartForm.h"
#import "XBNetWorkingDefine.h"
#import <AFNetworking.h>
#import "AFURLResponseSerialization.h"
#import "NSString+ToJSONObj.h"

@interface XBHttpRequestManager () {
//    AFHTTPRequestOperationManager *_operationManager;
}

@property (nonatomic, assign) HttpSessionTaskType tastType;
@property (nonatomic, strong) AFURLSessionManager *sessionManager;

@end

@implementation XBHttpRequestManager

+ (instancetype)sharedInstance {
    static XBHttpRequestManager *manager = nil;
    
    static dispatch_once_t count;
    
    dispatch_once(&count, ^{
        manager = [[XBHttpRequestManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    
    if (self == [super init]) {
//        _operationManager = [AFHTTPRequestOperationManager manager];
//        _operationManager.responseSerializer.acceptableContentTypes = nil;
        self.tastType = HttpSessionTaskType_Normal;
        self.sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
        serializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
        self.sessionManager.responseSerializer = serializer;
        
        NSURLCache *cache = [NSURLCache sharedURLCache];
        [cache setMemoryCapacity:kURLCacheMemoryCapacity];
        [NSURLCache setSharedURLCache:cache];
    }
    
    return self;
}

//- (AFHTTPRequestOperation *)sendRequestAsyncrously:(XBHttpRequest *)request
//                                      succeedBlock:(XBHttpRequestSucceedBlock)succeedBlock
//                                         failedBlock:(XBHttpRequestFailedBlock)failedBlock {
//
//    NSMutableURLRequest *urlRequest = [self getNSURLRequestWithXBHttpRequest:httpRequest];
//
//    void (^requestSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject) {
//        [self logWithOperation:operation andXBHttpRequest:httpRequest];
//
//        if (succeedBlock) {
//            succeedBlock(httpRequest, [self dictionaryWithData:responseObject]);
//        }
//    };
//
//    void (^requestFailureBlock)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self logWithOperation:operation andXBHttpRequest:httpRequest];
//
//        if (failedBlock) {
//            failedBlock(httpRequest, error);
//        }
//    };
//
//    AFHTTPRequestOperation *operation = nil;
//    operation = [_operationManager HTTPRequestOperationWithRequest:urlRequest success:requestSuccessBlock failure:requestFailureBlock];
//
//    [_operationManager.operationQueue addOperation:operation];
//
//    return operation;
//
//}

- (NSURLSessionTask *)sendSessionRequestAsyncrously:(XBHttpRequest *)httpRequest succeedBlock:(XBHttpRequestSucceedBlock)succeedBlock failedBlock:(XBHttpRequestFailedBlock)failedBlock {
    
    NSMutableURLRequest *request = [self getNSURLRequest:httpRequest];
    NSURLSessionTask *task = nil;
    
    switch (self.tastType) {
        case HttpSessionTaskType_Normal:
            task = [self requestWithNormalTask:httpRequest urlRequest:request succeed:succeedBlock failedBlock:failedBlock];
            break;
            
        case HttpSessionTaskType_UpLoad:
            
            task = [self requestWithUpLoadTask:httpRequest urlRequest:request succeed:succeedBlock failedBlock:failedBlock];
            break;
            
        case HttpSessionTaskType_DownLoad:

            task = [self requestWithDownLoadTask:httpRequest urlRequest:request succeed:succeedBlock failedBlock:failedBlock];
            break;
            
        default:
            break;
    }
    
    [task resume];
    
    
    return task;
}

- (NSURLSessionDataTask *)requestWithNormalTask:(XBHttpRequest *)httpRequest  urlRequest:(NSURLRequest *)urlRequest succeed:(XBHttpRequestSucceedBlock)succeedBlock failedBlock:(XBHttpRequestFailedBlock)failedBlock {
    
// 过时接口
//    NSURLSessionDataTask *dataTask = [self.sessionManager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        // todo 打印log
//        //       [self logWithOperation:operation andXBHttpRequest:httpRequest];
//
//        if (!error) {
//            if (succeedBlock) {
//                succeedBlock(httpRequest, [self dictionaryWithData:responseObject]);
//            }
//        } else {
//
//            if (failedBlock) {
//                failedBlock(httpRequest, error);
//            }
//        }
//
//    }];

    NSURLSessionDataTask *dataTask = [self.sessionManager dataTaskWithRequest:urlRequest uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        // TODO
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        // TODO
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
                // TODO 打印log
        
                if (!error) {
                    if (succeedBlock) {
                        succeedBlock(httpRequest, [self dictionaryWithData:responseObject]);
                    }
                } else {
        
                    if (failedBlock) {
                        failedBlock(httpRequest, error);
                    }
                }
    }];
    
    return dataTask;
    
}

- (NSURLSessionUploadTask *)requestWithUpLoadTask:(XBHttpRequest *)httpRequest urlRequest:(NSURLRequest *)urlRequest succeed:(XBHttpRequestSucceedBlock)succeedBlock failedBlock:(XBHttpRequestFailedBlock)failedBlock {
    
    
    NSURLSessionUploadTask *dataTask = [self.sessionManager uploadTaskWithStreamedRequest:urlRequest progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (!error) {
            if (succeedBlock) {
                succeedBlock(httpRequest, [self dictionaryWithData:responseObject]);
            }
        } else {
            
            if (failedBlock) {
                failedBlock(httpRequest, error);
            }
        }
        
    }];
    
    return dataTask;
    
}


#warning   TODO: 未完成逻辑
- (NSURLSessionDownloadTask *)requestWithDownLoadTask:(XBHttpRequest *)httpRequest urlRequest:(NSURLRequest *)urlRequest succeed:(XBHttpRequestSucceedBlock)succeedBlock failedBlock:(XBHttpRequestFailedBlock)failedBlock {
    
      // todo: 未完成逻辑
    
//    NSURLSessionDownloadTask *dataTask = [self.sessionManager downloadTaskWithRequest:urlRequest progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//
//        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//
//        //在此之前先删除本地文件夹里面相同的文件夹
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        NSArray *contents = [fileManager contentsOfDirectoryAtPath:cachesPath error:NULL];
//        NSEnumerator *e = [contents objectEnumerator];
//        NSString *filename;
//        NSString *extension = @"zip";
//        while ((filename = [e nextObject])) {
//
//            if ([[filename pathExtension] isEqualToString:extension]) {
//
//                [fileManager removeItemAtPath:[cachesPath stringByAppendingPathComponent:filename] error:NULL];
//            }
//        }
//        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
//        return [NSURL fileURLWithPath:path];
//
//    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//

//        if (!error) {
////            if (!!succeedBlock) {
////                succeedBlock(httpRequest, [self dictionaryWithData:[filePath path]]);
////            }
//
//
//            //设置下载完成操作
//            // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
//            NSString *htmlFilePath = [filePath path];// 将NSURL转成NSString
//            NSArray *documentArray =  NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//            NSString *path = [[documentArray lastObject] stringByAppendingPathComponent:@"Preferences"];
//            NSFileManager *fileManager = [NSFileManager defaultManager];
//            [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/driver",path] error:nil];
//            [self releaseZipFilesWithUnzipFileAtPath:htmlFilePath Destination:path];
//
//            // 结束后移除掉这个progress
//            [progress removeObserver:self
//                          forKeyPath:@"fractionCompleted"
//                             context:NULL];
//
//            AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
//
//            UIView *view = del.navController.topViewController.view;
//
//            if (view) {
//
////                [MBProgressHUD hideHUDForView:view animated:YES];
////                [self.hud hide:YES];
//            }
//
//
//        } else {
//
////            if (!!failBlock) {
////                failBlock(httpRequest, error);
////            }
//        }
    
//    }];
    
//    // 设置这个progress的唯一标示符
//    [progress setUserInfoObject:@"someThing" forKey:@"Y.X."];
//
//    // 给这个progress添加监听任务
//    [progress addObserver:self
//               forKeyPath:@"fractionCompleted"
//                  options:NSKeyValueObservingOptionNew
//                  context:NULL];

    
    NSURLSessionDownloadTask *dataTask = nil;
    return dataTask;
    
}

#pragma mark - private

- (NSMutableURLRequest *)getNSURLRequest:(XBHttpRequest *)httpRequest {
    
    NSString *methodStr = ([httpRequest isKindOfClass:[XBHttpGetRequest class]]) ? @"GET" : @"POST";
    
    httpRequest.params = [[[self class] getRequestBodyWithParams:httpRequest.params] copy];
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    
    NSMutableURLRequest *request = nil;
    
    self.tastType = httpRequest.taskType;
    
    
    //当且仅当是POST请求且需上传文件数据时采用multipartFormRequestWithMethod，因为它采用的是"multipart/form-data"格式
    if ([httpRequest isKindOfClass:[XBHttpPostRequestMultipartForm class]] && ((XBHttpPostRequest *)httpRequest).formDataArray.count > 0) {
        
        self.tastType = HttpSessionTaskType_UpLoad;
        
        XBHttpPostRequest *postRequest = (XBHttpPostRequest *)httpRequest;
        
        request = [serializer multipartFormRequestWithMethod:methodStr URLString:postRequest.action parameters:postRequest.params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            for (id formDataObj in postRequest.formDataArray) {
                
                if (formDataObj && [formDataObj isKindOfClass:[XBHttpPostRequestMultipartForm class]]) {
                    
                    XBHttpPostRequestMultipartForm *newFormData =(XBHttpPostRequestMultipartForm *)formDataObj;
                    
                    if (newFormData.fileData && newFormData.name.length > 0 &&
                        newFormData.fileName.length > 0) {
                        [formData appendPartWithFileData:newFormData.fileData
                                                      name:newFormData.name
                                                  fileName:newFormData.fileName
                                                  mimeType:@"multipart/form-data"];
                    }
                }
            }
            
        } error:nil];
        
    } else {
        //没有文件需要上传的请求采用requestWithMethod。如果是POST请求，则采用“application/x-www-form-urlencoded”格式
        request = [serializer requestWithMethod:methodStr
                                      URLString:httpRequest.action
                                     parameters:httpRequest.params
                                          error:nil];
        
    }
    
    if (httpRequest.timeoutInterval > 0) {
        [request setTimeoutInterval:httpRequest.timeoutInterval];
    } else {
        [request setTimeoutInterval:kXBHttpRequestTimeOutInterval];
    }
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    return request;
}

//- (void)logWithOperation:(AFHTTPRequestOperation *)operation andXBHttpRequest:(XBHttpRequest *)httpRequest {
//    NSString *methodStr = ([httpRequest isKindOfClass:[XBHttpPostRequest class]]) ? @"POST" : @"GET";
//
//    if ([httpRequest isKindOfClass:[XBHttpGetRequest class]]) {
//        DLog(@"===========GET request url:  %@  \n", operation.request.URL.absoluteString);
//    } else {
//        DLog(@"===========POST request url:  %@  \n", operation.request.URL.absoluteString);
//    }
//
//    if (operation.error) {
//        DLog(@"===========%@ error :  %@", [methodStr lowercaseString], operation.error);
//    } else {
//        id jsonValue = [operation.responseString JSONValue];
//        id response = !!jsonValue ? jsonValue : operation.responseString;
//        DLog(@"===========请求的URL=%@请求到的数据==%@", operation.request.URL.absoluteString, response);
//    }
//}

+ (NSMutableDictionary *)getRequestBodyWithParams:(NSDictionary *)params {
    
    NSMutableDictionary *requestBody = params ? [params mutableCopy] : [[NSMutableDictionary alloc] init];
    
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
       
        if ([obj isKindOfClass:[NSDate class]]) {
            [requestBody setValue:@([obj timeIntervalSince1970] * 1000) forKey:key];
        }
        
        if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSArray class]]) {
            [requestBody setValue:[obj JSONValue] forKey:key];
        }
        
        if ([obj isKindOfClass:[NSString class]]) {
            [requestBody setValue:obj forKey:key];
        }
    }];
    
    return requestBody;
}

- (id)dictionaryWithData:(id)data {
    NSDictionary *object = data;
    
    if ([data isKindOfClass:[NSData class]]) {
        object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    }
    
    if ([data isKindOfClass:[NSString class]]) {
        object = [data object];
    }
    
    return object? : data;
}

@end
