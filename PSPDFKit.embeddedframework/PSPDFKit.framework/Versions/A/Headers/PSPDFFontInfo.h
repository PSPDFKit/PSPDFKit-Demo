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

@class PSPDFCMap, PSPDFFontFileDescriptor;

typedef NS_ENUM(NSUInteger, PSPDFFontInfoType) {
    PSPDFFontInfoTypeSimple    = 1 << (1-1),
    PSPDFFontInfoTypeComposite = 1 << (2-1)
};

/// Encapsulates formatting and encoding data of a  PDF font.
/// This is a class cluster and part of the text parser engine.
@interface PSPDFFontInfo : NSObject <NSCopying, NSCoding> {
@public
    CGFloat _ascent;
    CGFloat _descent;
    NSArray *_encodingArray;
    NSUInteger _encodingArrayCount;
    PSPDFCMap *_toUnicodeMap;
    PSPDFCMap *_fontCMap;
    PSPDFCMap *_ucsCMap;
    PSPDFFontFileDescriptor *_fontFileDescriptor;
    CGFloat *_widths;
    CGFloat _defaultWidth;
    size_t _widthSize;
    PSPDFFontInfoType _type;
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

/// CMap that is optionally provided for converting text strings to unicode
@property (nonatomic, strong, readonly) PSPDFCMap *toUnicodeMap;

/// Characters encoded in the Font File Descriptor.
@property (nonatomic, strong, readonly) PSPDFFontFileDescriptor *fontFileDescriptor;

/// CMap for the given encoding name
@property (nonatomic, strong, readonly) PSPDFCMap *fontCMap;

/// CMap formed from the registery and ordering information of the font,
/// used for unicode conversion when toUnicodeMap is not present
@property (nonatomic, strong, readonly) PSPDFCMap *ucsCMap;

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

/// Convert a character into unicode
- (NSString *)unicodeStringForCharacter:(uint16_t)character;

@end

// Normalize strings into KC form.
extern NSString *PSPDFNormalizeString(__unsafe_unretained NSString *string);
