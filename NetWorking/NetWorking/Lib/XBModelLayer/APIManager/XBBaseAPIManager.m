//
//  XBBaseAPIManager.m
//  
//
//  Created by 李泽宇 on 2018/3/28.
//

#import "XBBaseAPIManager.h"

@interface XBBaseAPIManager () {
    NSDictionary *_params;
}
//@property (nonatomic, weak) id<BSAPIManagerOverideMethods> childAPIManager;
@property (nonatomic, strong) XBHttpRequest *request;

@end


@implementation XBBaseAPIManager

//- (instancetype)init {
//    
//    if (self = [super init]) {
//        
//    }
//    
//}



- (NSString *)apiURL {
    
    return nil;
}


@end
