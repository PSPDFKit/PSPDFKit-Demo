//
//  PSPDFOutlineParser.h
//  PSPDFKit
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PSPDFOutlineElement;

#define kPSPDFOutlineParserErrorDomain @"kPSPDFOutlineParserErrorDomain"

/// Parses the Outline/Table of Contents of a pdf.
@interface PSPDFOutlineParser : NSObject

/// Init outline parser with document.
- (id)initWithDocument:(PSPDFDocument *)document;

/// Parse document, returns outline (PSDFOutlineElements)
- (NSArray *)parseDocument;

/// Returns single outline element for specific page.
/// if exactPageOnly is set, the outline will only be returned if it's from the specific page.
/// else the last active set outline will be returned.
- (PSPDFOutlineElement *)outlineElementForPage:(NSUInteger)page exactPageOnly:(BOOL)exactPageOnly;

/// Returns cached outline. starts parsing if outline is not yet created.
@property(nonatomic, strong, readonly) NSArray *outline;

/// Static helper, resolves named destination entries, returns dict with name -> page NSNumber
+ (NSDictionary *)resolveDestNames:(NSSet *)destNames documentRef:(CGPDFDocumentRef)documentRef;

@end
