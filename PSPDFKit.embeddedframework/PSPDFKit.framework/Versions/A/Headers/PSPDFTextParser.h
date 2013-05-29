//
//  PSPDFTextParser.h
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

@class PSPDFFontInfo, PSPDFGraphicsState, PSPDFHighlightAnnotation, PSPDFDocument;

/// Parses the text of a PDF page.
@interface PSPDFTextParser : NSObject

/// Designated initializer.
/// `fontCache` is optional, share only between one PSPDFDocumentProvider.
/// `page` is absolute to PSPDFDocument.
- (id)initWithPDFPage:(CGPDFPageRef)pageRef page:(NSUInteger)page document:(PSPDFDocument *)document fontCache:(NSMutableDictionary *)fontCache hideGlyphsOutsidePageRect:(BOOL)hideGlyphsOutsidePageRect PDFBox:(CGPDFBox)PDFBox;

/// Directly parse a specific stream.
- (id)initWithStream:(CGPDFStreamRef)stream;

/// The complete page text, including extrapolated spaces and newline characters.
@property (nonatomic, strong) NSString *text;

/// Complete list of PSPDFGlyph objects. Corresponds to the text.
@property (nonatomic, strong, readonly) NSArray *glyphs;

/// List of detected words (PSPDFWord)
@property (nonatomic, strong, readonly) NSArray *words;

/// List of detected lines (PSPDFTextLine)
@property (nonatomic, strong, readonly) NSArray *lines;

/// List of detected images (PSPDFImageInfo)
@property (nonatomic, strong, readonly) NSArray *images;

/// List of detected text blocks (PSPDFTextBlock)
@property (nonatomic, strong, readonly) NSArray *textBlocks;

/// Associated document.
@property (atomic, weak) PSPDFDocument *document;

/// Uses glyphs to return the corresponding page text, including newlines and spaces.
- (NSString *)textWithGlyphs:(NSArray *)glyphs;

@end

@interface PSPDFTextParser (SubclassingHooks)

// Performance.
@property (atomic, strong) NSString *transformedText;

@end
