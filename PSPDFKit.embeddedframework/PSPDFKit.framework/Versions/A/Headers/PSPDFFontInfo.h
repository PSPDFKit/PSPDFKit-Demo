//
//  PSPDFFontInfo.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

///
/// Encapsulates formatting and encoding data of a  PDF font.
/// Part of the text parser engine.
///
@interface PSPDFFontInfo : NSObject <NSCopying, NSCoding> {
    CGFloat _ascent;
    CGFloat _descent;
}

@property (nonatomic, copy,   readonly) NSString *name;
@property (nonatomic, assign, readonly) CGFloat ascent;
@property (nonatomic, assign, readonly) CGFloat descent;
@property (nonatomic, copy,   readonly) NSArray *encodingArray;
@property (nonatomic, copy,   readonly) NSDictionary *toUnicodeMap;

/// Designated initializer
- (id)initWithFontDictionary:(CGPDFDictionaryRef)font;

- (CGFloat)widthForCharacter:(uint16_t)c;
- (BOOL)isMultiByteFont;
- (void)parseToUnicodeMapWithString:(NSString *)cmapString;

/// Default glyph dictionaries. Loaded lazily.
+ (NSDictionary *)glyphNames;
+ (NSDictionary *)standardFontWidths;

/// Compare.
- (BOOL)isEqualToFontInfo:(PSPDFFontInfo *)otherFontInfo;

@end
