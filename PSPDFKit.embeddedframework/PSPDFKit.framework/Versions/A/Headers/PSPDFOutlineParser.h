//
//  PSPDFOutlineParser.h
//  PSPDFKit
//
//  Copyright 2011-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFOutlineElement, PSPDFDocumentProvider;

/// Parses the Outline/Table of Contents of a PDF.
@interface PSPDFOutlineParser : NSObject

/// Initialize outline parser with the documentProvider.
- (id)initWithDocumentProvider:(PSPDFDocumentProvider *)documentProvider;

/**
 Returns a single outline element for the specified page.
 
 If exactPageOnly is set, the outline will only be returned if it's from the specific page.
 Else the last active set outline will be returned.
*/
- (PSPDFOutlineElement *)outlineElementForPage:(NSUInteger)page exactPageOnly:(BOOL)exactPageOnly;

/// Returns cached outline. starts parsing if outline is not yet created.
/// Not readonly, because this could also be set programmatically.
@property (nonatomic, strong) PSPDFOutlineElement *outline;

/// Returns YES if outline is already parsed. Might be an expensive operation.
@property (nonatomic, assign, readonly, getter=isOutlineParsed) BOOL outlineParsed;

/// Returns YES if there is an outline in the document and we parsed it (outline.children > 0)
/// Will return NO if outline is not yet parsed.
@property (nonatomic, assign, readonly, getter=isOutlineAvailable) BOOL outlineAvailable;

/// Attached document provider.
@property (nonatomic, weak, readonly) PSPDFDocumentProvider *documentProvider;

/// Static helper, resolves named destination entries, returns dict with name -> page NSNumber
+ (NSDictionary *)resolveDestNames:(NSSet *)destNames documentRef:(CGPDFDocumentRef)documentRef;

/// Remembers the first visible outline element.
/// Used to remember the position in PSPDFOutlineViewController.
@property (nonatomic, assign) NSUInteger firstVisibleElement;

@end
