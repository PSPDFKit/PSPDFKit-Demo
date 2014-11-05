//
//  PSPDFFontInfo.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import "PSPDFMacros.h"

@class PSPDFCMap, PSPDFFontFileDescriptor;

typedef NS_ENUM(NSUInteger, PSPDFFontInfoType) {
    PSPDFFontInfoTypeSimple    = 1 << (1-1),
    PSPDFFontInfoTypeComposite = 1 << (2-1)
};

/// Encapsulates formatting and encoding data of a  PDF font.
/// This is a class cluster and part of the text parser engine.
@interface PSPDFFontInfo : NSObject <NSCopying, NSSecureCoding>

/// The font name as defined in the PDF dictionary.
@property (nonatomic, copy, readonly) NSString *name;

/// The `fontKey` is a document-global identifier for the fontKey.
@property (nonatomic, copy, readonly) NSString *fontKey;

/// The font type. (simple or composite)
@property (nonatomic, assign, readonly) PSPDFFontInfoType type;

/// Font ascent parameter.
/// @note This parameter is normalized (divided by 1000 vs the PDF spec)
@property (nonatomic, assign, readonly) CGFloat ascent;

/// Font descent parameter.
/// @note This parameter is normalized (divided by 1000 vs the PDF spec)
@property (nonatomic, assign, readonly) CGFloat descent;

/// A font can have either an `encodingArray` or a unicode map.
/// A encoding array contains `NSString` objects.
@property (nonatomic, copy, readonly) NSArray *encodingArray;

/// CMap that is optionally provided for converting text strings to unicode
@property (nonatomic, strong, readonly) PSPDFCMap *toUnicodeMap;

/// Characters encoded in the Font File Descriptor.
@property (nonatomic, strong, readonly) PSPDFFontFileDescriptor *fontFileDescriptor;

/// CMap for the given encoding name
@property (nonatomic, strong, readonly) PSPDFCMap *fontCMap;

/// CMap formed from the registry and ordering information of the font,
/// used for unicode conversion when `toUnicodeMap` is not present
@property (nonatomic, strong, readonly) PSPDFCMap *ucsCMap;

/// Designated initializer. `fontKey` is optional.
- (instancetype)initWithFontDictionary:(CGPDFDictionaryRef)font fontKey:(NSString *)fontKey;

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

/// Convert a character into unicode
- (NSString *)unicodeStringForCharacter:(uint16_t)character;

@end

PSPDFKIT_EXTERN_C_BEGIN

// Normalize strings into KC form.
extern NSString *PSPDFNormalizeString(__unsafe_unretained NSString *string);

PSPDFKIT_EXTERN_C_END
