//
//  PSPDFOutlineParser.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFOutlineElement, PSPDFDocumentProvider;

#define kPSPDFOutlineParserErrorDomain @"kPSPDFOutlineParserErrorDomain"

/// Parses the Outline/Table of Contents of a pdf.
@interface PSPDFOutlineParser : NSObject

/// Init outline parser with document.
- (id)initWithDocumentProvider:(PSPDFDocumentProvider *)documentProvider;

/// Parse (partial) document, returns and sets outline (PSDFOutlineElements)
/// Only parses outline once. Thread safe.
- (NSArray *)parseOutline;

/// Returns single outline element for specific page.
/// if exactPageOnly is set, the outline will only be returned if it's from the specific page.
/// else the last active set outline will be returned.
- (PSPDFOutlineElement *)outlineElementForPage:(NSUInteger)page exactPageOnly:(BOOL)exactPageOnly;

/// Returns cached outline. starts parsing if outline is not yet created.
@property(nonatomic, strong, readonly) PSPDFOutlineElement *outline;

/// Static helper, resolves named destination entries, returns dict with name -> page NSNumber
+ (NSDictionary *)resolveDestNames:(NSSet *)destNames documentRef:(CGPDFDocumentRef)documentRef;

/// Remembers the first visible outline element.
/// Used to remember the position in PSPDFOutlineViewController.
@property(nonatomic, assign) NSUInteger firstVisibleElement;

@end
