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

@property (nonatomic, readonly) CGPDFPageRef page;
@property (nonatomic, strong) NSMutableDictionary *fonts;
@property (nonatomic, strong) NSMutableArray *glyphs;
@property (nonatomic, strong) NSMutableArray *words;
@property(nonatomic, strong, readonly) NSArray *textBlocks;
@property (nonatomic, strong) NSString *text;
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

void printDictionaryKeys (const char *key, CGPDFObjectRef value, void *info);

void parseXObjectResources (const char *key, CGPDFObjectRef value, void *info);

void findXObject (const char *key, CGPDFObjectRef value, void *info);

void parseFont (const char *key, CGPDFObjectRef value, void *info);
void AddBoundingBoxForCharacter(PSPDFTextParser *parser, uint16_t character);
void AddString(PSPDFTextParser *parser, CGPDFStringRef pdfString);
