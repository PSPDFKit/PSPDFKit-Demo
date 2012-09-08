//
//  PSPDFTextParser.h
//  PSPDFKit
//
//  Copyright 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFFontInfo, PSPDFGraphicsState, PSPDFHighlightAnnotation;

// Enable to log state while parsing.
extern BOOL kPSPDFTextParserDebugLogEnabled;

/// Parses the text of a PDF page.
@interface PSPDFTextParser : NSObject

/// Complete page text.
@property (nonatomic, strong) NSString *text;

/// Complete list of PSPDFGlyph objects. Corresponds to the text.
@property (nonatomic, strong) NSMutableArray *glyphs;

/// List of detected words (PSPDFWord)
@property (nonatomic, strong) NSMutableArray *words;

/// List of detected text blocks (PSPDFTextBlock)
@property(nonatomic, strong, readonly) NSArray *textBlocks;

- (id)initWithPDFPage:(CGPDFPageRef)p;

@end
