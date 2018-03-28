//
//  NSString(TS_EncodingAndDecoding).m
//  HGShopAssistant
//
//  Created by XiaoShan on 10/11/15.
//  Copyright © 2015 Higegou. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "NSString(TS_EncodingAndDecoding).h"

@implementation NSString(TS_EncodingAndDecoding)

- (NSString *)toURLEncodedString {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8));
    
    return result;
}

- (NSString*)toURLDecodedString {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)self, CFSTR(""), kCFStringEncodingUTF8));
    NSString *resultWithoutPlus = [result stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    
    return resultWithoutPlus;
}

- (NSString *)toMD5EncodedString {
    if(self == nil || [self length] == 0) {
        return nil;
    }
    
    const char *value = [self UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (unsigned int)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return outputString;
}

@end