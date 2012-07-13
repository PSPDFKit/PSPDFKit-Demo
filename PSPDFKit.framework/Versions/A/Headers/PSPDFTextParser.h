//
//  PSPDFTextParser.h
//  PSPDFKit
//
//  Copyright 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFFontInfo, PSPDFGraphicsState, PSPDFHighlightAnnotation, PDFPage;

/// Parses the text of a PDF page.
@interface PSPDFTextParser : NSObject

/// Complete page text.
@property (nonatomic, strong) NSString *text;

/// Complete list of PSPDFGlyph objects. Corresponds to the text.
@property (nonatomic, strong) NSMutableArray *glyphs;

/// List of detected words.
@property (nonatomic, strong) NSMutableArray *words;

/// List of detected text blocks.
@property(nonatomic, strong, readonly) NSArray *textBlocks;

// Referenced page
@property (nonatomic, readonly) CGPDFPageRef page;


@property (nonatomic, strong) NSMutableDictionary *fonts;

@property (nonatomic, readonly) BOOL parsed;

@property (nonatomic, strong) NSMutableArray *graphicsStateStack;

@property (nonatomic, strong) PSPDFGraphicsState *graphicsState;

@property (nonatomic, assign) int formXObjectRecursionDepth;

- (id)initWithPDFPage:(CGPDFPageRef)p;

- (CGPDFOperatorTableRef)operatorTable;

- (void)parse;
- (void)parseWithPage:(PDFPage *)pdfPage;

- (NSString *)textForHighlightAnnotation:(PSPDFHighlightAnnotation *)annotation;

@end

@interface PDFXObjectStream : NSObject

@property (nonatomic, assign) CGPDFStreamRef stream;
@property (nonatomic, strong) NSString *name;

@end
