//
//  PSPDFTextParser.h
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

@class PSPDFFontInfo, PSPDFGraphicsState, PSPDFDocumentProvider;

// Defaults to 5. Increase for certain documents.
extern NSUInteger PSPDFMaxShadowGlyphSearchDepth;

/// Parses the text of a PDF page.
@interface PSPDFTextParser : NSObject <NSSecureCoding>

/// Designated initializer.
/// `fontCache` is optional, share only between one `PSPDFDocumentProvider`.
/// `page` is absolute to `PSPDFDocument`.
- (instancetype)initWithPDFPage:(CGPDFPageRef)pageRef page:(NSUInteger)page documentProvider:(PSPDFDocumentProvider *)documentProvider fontCache:(NSMutableDictionary *)fontCache hideGlyphsOutsidePageRect:(BOOL)hideGlyphsOutsidePageRect PDFBox:(CGPDFBox)PDFBox;

/// Directly parse a specific stream.
/// @return Either an `PSPDFTextParser` object or nil if `streamRef` is nil.
- (instancetype)initWithStreamRef:(CGPDFStreamRef)streamRef;

/// The complete page text, including extrapolated spaces and newline characters.
@property (nonatomic, copy, readonly) NSString *text;

/// Complete list of `PSPDFGlyph` objects. Corresponds to the text.
@property (nonatomic, copy, readonly) NSArray *glyphs;

/// List of detected words (`PSPDFWord`)
@property (nonatomic, copy, readonly) NSArray *words;

/// List of detected lines (`PSPDFTextLine`)
@property (nonatomic, copy, readonly) NSArray *lines;

/// List of detected images (`PSPDFImageInfo`)
@property (nonatomic, copy, readonly) NSArray *images;

/// List of detected text blocks (`PSPDFTextBlock`)
@property (nonatomic, copy, readonly) NSArray *textBlocks;

/// Associated document provider.
@property (nonatomic, weak, readonly) PSPDFDocumentProvider *documentProvider;

/// Uses glyphs to return the corresponding page text, including newlines and spaces.
- (NSString *)textWithGlyphs:(NSArray *)glyphs;

@end

@interface PSPDFTextParser (SubclassingHooks)

// Will be called on each character, allows to cancel individual characters.
// The default implementation will simply return YES.
- (BOOL)shouldParseCharacter:(uint16_t)character;

// Exposes the current marked content stack.
@property (nonatomic, copy, readonly) NSArray *markedContentStack;

// Access the internal lock.
@property (nonatomic, readonly) dispatch_queue_t parsingQueue;

@end
