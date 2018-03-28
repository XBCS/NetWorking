//
//  NSString(TS_Attributed).m
//  HGShopAssistant
//
//  Created by JiaLei on 15/10/13.
//  Copyright © 2015年 Higegou. All rights reserved.
//

#import "NSString(TS_Attributed).h"

@implementation NSString(TS_Attributed)

- (void)prepareAttrStr:(UIFont *)font
                 space:(CGFloat)lineSpace
             breakMode:(NSLineBreakMode)lineBreakMode
             alignment:(NSTextAlignment) textAlignment
                render:(NSAttributedString **)attrStrForRender
                  size:(NSAttributedString **)attrStrForSize
            attributes:(NSMutableDictionary *)newAttrs {
    
    if (self.length > 0) {
        NSMutableParagraphStyle *paragraphStyleForRender = [[NSMutableParagraphStyle alloc] init];
        paragraphStyleForRender.maximumLineHeight = font.lineHeight;
        paragraphStyleForRender.minimumLineHeight = font.lineHeight;
        paragraphStyleForRender.lineSpacing = lineSpace;//行间距
        paragraphStyleForRender.lineBreakMode = lineBreakMode;
        paragraphStyleForRender.alignment = textAlignment;
        NSMutableDictionary *attrsForRender = [newAttrs mutableCopy];
        attrsForRender[NSParagraphStyleAttributeName] = paragraphStyleForRender;
        *attrStrForRender = [[NSAttributedString alloc] initWithString:self attributes:attrsForRender];
        
        NSMutableParagraphStyle *paragraphStyleForSize = [paragraphStyleForRender mutableCopy];
        paragraphStyleForSize.lineBreakMode = NSLineBreakByWordWrapping;
        NSMutableDictionary *attrsForSize = [newAttrs mutableCopy];
        attrsForSize[NSParagraphStyleAttributeName] = paragraphStyleForSize;
        *attrStrForSize = [[NSAttributedString alloc] initWithString:self attributes:attrsForSize];
    }
}

- (CGSize)getAttrTextSizeWithConstrainedSize:(NSAttributedString *)text
                             constrainedSize:(CGSize)constrainedSize {
    
    
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    
    CGSize size = [text boundingRectWithSize:CGSizeMake(constrainedSize.width, constrainedSize.height)
                                     options:options
                                     context:nil].size;
    
    return size;
}



- (NSAttributedString *)getAttributedStringAndItsSize:(NSDictionary *)attributes
                                            lineSpace:(CGFloat)lineSpace
                                            breakMode:(NSLineBreakMode)lineBreakMode
                                            alignment:(NSTextAlignment)textAlignment
                                      constrainedSize:(CGSize)constrainedSize
                                             textSize:(CGSize *)textSize {
    
    return [self getAttributedStringAndItsSize:attributes lineSpace:lineSpace breakMode:lineBreakMode alignment:textAlignment constrainedSize:constrainedSize textSize:textSize numberOfLine:99];
}




- (NSAttributedString *)getAttributedStringAndItsSize:(NSDictionary *)attributes
                                            lineSpace:(CGFloat)lineSpace
                                            breakMode:(NSLineBreakMode)lineBreakMode
                                            alignment:(NSTextAlignment)textAlignment
                                      constrainedSize:(CGSize)constrainedSize
                                             textSize:(CGSize *)textSize
                                         numberOfLine:(NSInteger)numberOfLine {

    
//    CGFloat font = attributes[@""]
//    
    CGFloat maxHeight = CGFLOAT_MAX;
    

    
    NSMutableDictionary *newAttrs = [NSMutableDictionary dictionary];
    
    if (attributes.count > 0) {
        [newAttrs setValuesForKeysWithDictionary:attributes];
    }
    UIFont *font = newAttrs[NSFontAttributeName];
    
    if (!font) {
        font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
        newAttrs[NSFontAttributeName] = font;
    }
    

    if (numberOfLine <= 20) {
        
        maxHeight = (font.pointSize + 8) * numberOfLine + lineSpace * (numberOfLine - 1);
        
    }
    
    CGSize maxSize = CGSizeZero;
    maxSize.width = constrainedSize.width;
    maxSize.height = maxHeight;
    
    
    NSAttributedString *attrStrForRender = [[NSAttributedString alloc] initWithString:@""];
    NSAttributedString *attrStrForSize = attrStrForRender;
    
    //单行或多行
    [self prepareAttrStr:font
                   space:lineSpace
               breakMode:lineBreakMode
               alignment:textAlignment
                  render:&attrStrForRender
                    size:&attrStrForSize
              attributes:newAttrs];
    
    *textSize = [self getAttrTextSizeWithConstrainedSize:attrStrForSize
                                         constrainedSize:maxSize];
    
    
    
    //单行
    if ((*textSize).height <= (font.lineHeight+lineSpace)) {
        lineSpace = 0;
        [self prepareAttrStr:font
                       space:lineSpace
                   breakMode:lineBreakMode
                   alignment:textAlignment
                      render:&attrStrForRender
                        size:&attrStrForSize
                  attributes:newAttrs];
        *textSize = [self getAttrTextSizeWithConstrainedSize:attrStrForSize
                                             constrainedSize:maxSize];
    }
    
    return attrStrForRender;


}



@end
