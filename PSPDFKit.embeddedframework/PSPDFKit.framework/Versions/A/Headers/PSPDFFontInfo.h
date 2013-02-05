//
//  PSPDFFontInfo.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

///
/// Encapsulates formatting and encoding data of a  PDF font.
/// This is a class cluster and part of the text parser engine.
///
@interface PSPDFFontInfo : NSObject <NSCopying, NSCoding> {
@public
    CGFloat _ascent;
    CGFloat _descent;
    NSArray *_encodingArray;
    NSDictionary *_toUnicodeMap;
}

/// The font name as defined in the PDF dictionary.
@property (nonatomic, copy,   readonly) NSString *name;

// Since PSPDFKit 2.8, ascend, descend and width are normalized (divided by 1000 vs the PDF spec)
// This has been done for performance reasons.
/// Font ascent parameter.
@property (nonatomic, assign, readonly) CGFloat ascent;

/// Font descent parameter.
@property (nonatomic, assign, readonly) CGFloat descent;

/// A font can have either an encodingArray or a unicode map.
@property (nonatomic, copy,   readonly) NSArray *encodingArray;

/// Specialized dictionary that uses raw values as key pointers (use CFDictionaryGetValue)
@property (nonatomic, copy,   readonly) NSDictionary *toUnicodeMap;

/// Version that boxes the keys at runtime. Slower, will be recreated on every access.
@property (nonatomic, copy,   readonly) NSDictionary *boxedToUnicodeMap;

/// Designated initializer
- (id)initWithFontDictionary:(CGPDFDictionaryRef)font;

/// Returns the width for the specific character.
- (CGFloat)widthForCharacter:(uint16_t)character;

/// Returns YES if font is a composite/multibyte font.
- (BOOL)isMultiByteFont;

- (void)parseToUnicodeMapWithString:(NSString *)cmapString;

/// Default glyph dictionaries. Loaded lazily.
+ (NSDictionary *)glyphNames;
+ (NSDictionary *)standardFontWidths;

/// Compare two fonts.
- (BOOL)isEqualToFontInfo:(PSPDFFontInfo *)otherFontInfo;

@end

// Normalize strings into KC form.
extern NSString *PSPDFNormalizeString(__unsafe_unretained NSString *string);
