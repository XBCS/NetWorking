//
//  NSString(TS_EncodingAndDecoding).h
//  HGShopAssistant
//
//  Created by XiaoShan on 10/11/15.
//  Copyright © 2015 Higegou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(TS_EncodingAndDecoding)

- (NSString *)toURLEncodedString;

- (NSString *)toURLDecodedString;

- (NSString *)toMD5EncodedString;

@end
