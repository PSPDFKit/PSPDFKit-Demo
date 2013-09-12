//
//  PSPDFFontInfo.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"

/// Encapsulates formatting and encoding data of a  PDF font.
/// This is a class cluster and part of the text parser engine.
@interface PSPDFFontInfo : NSObject <NSCopying, NSCoding> {
@public
    CGFloat _ascent;
    CGFloat _descent;
    NSArray *_encodingArray;
    NSUInteger _encodingArrayCount;
    NSDictionary *_toUnicodeMap;
    CGFloat *_widths;
    CGFloat _defaultWidth;
    size_t _widthSize;
    BOOL _isMultiByteFont;
}

/// The font name as defined in the PDF dictionary.
@property (nonatomic, copy, readonly) NSString *name;

/// The `fontKey` is a document-global identifier for the fontKey.
@property (nonatomic, copy, readonly) NSString *fontKey;

/// Font ascent parameter.
/// @note This parameter is normalized (divided by 1000 vs the PDF spec)
@property (nonatomic, assign, readonly) CGFloat ascent;

/// Font descent parameter.
/// @note This parameter is normalized (divided by 1000 vs the PDF spec)
@property (nonatomic, assign, readonly) CGFloat descent;

/// A font can have either an encodingArray or a unicode map.
@property (nonatomic, strong, readonly) NSArray *encodingArray;

/// Specialized dictionary that uses raw values as key pointers (use CFDictionaryGetValue)
@property (nonatomic, strong, readonly) NSDictionary *toUnicodeMap;

/// Version that boxes the keys at runtime. Slower, will be recreated on every access.
@property (nonatomic, copy, readonly) NSDictionary *boxedToUnicodeMap;

/// Designated initializer. fontKey is optional.
- (id)initWithFontDictionary:(CGPDFDictionaryRef)font fontKey:(NSString *)fontKey;

/// Returns the width for the specific character.
/// @note This parameter is normalized (divided by 1000 vs the PDF spec)
- (CGFloat)widthForCharacter:(uint16_t)character;

/// Returns YES if font is a composite/multibyte font.
@property (nonatomic, assign, readonly) BOOL isMultiByteFont;

/// Default glyph dictionaries. Loaded lazily.
+ (NSDictionary *)glyphNames;
+ (NSDictionary *)standardFontWidths;

/// Compare two fonts.
- (BOOL)isEqualToFontInfo:(PSPDFFontInfo *)otherFontInfo;

@end

// Normalize strings into KC form.
extern NSString *PSPDFNormalizeString(__unsafe_unretained NSString *string);
