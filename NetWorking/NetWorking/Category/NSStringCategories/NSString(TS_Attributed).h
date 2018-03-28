//
//  NSString(TS_Attributed).h
//  HGShopAssistant
//
//  Created by JiaLei on 15/10/13.
//  Copyright © 2015年 Higegou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString(TS_Attributed)

- (NSAttributedString *)getAttributedStringAndItsSize:(NSDictionary *)attributes
                                            lineSpace:(CGFloat)lineSpace
                                            breakMode:(NSLineBreakMode)lineBreakMode
                                            alignment:(NSTextAlignment)textAlignment
                                      constrainedSize:(CGSize)constrainedSize
                                             textSize:(CGSize *)textSize;

- (NSAttributedString *)getAttributedStringAndItsSize:(NSDictionary *)attributes
                                            lineSpace:(CGFloat)lineSpace
                                            breakMode:(NSLineBreakMode)lineBreakMode
                                            alignment:(NSTextAlignment)textAlignment
                                      constrainedSize:(CGSize)constrainedSize
                                             textSize:(CGSize *)textSize
                                         numberOfLine:(NSInteger)numberOfLine;


@end
