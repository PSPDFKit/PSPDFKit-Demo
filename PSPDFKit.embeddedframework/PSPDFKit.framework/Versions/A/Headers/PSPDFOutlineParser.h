//
//  PSPDFOutlineParser.h
//  PSPDFKit
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
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

/// Remembers the first visible outline element.
/// Used to remember the position in PSPDFOutlineViewController.
@property (nonatomic, assign) NSUInteger firstVisibleElement;

/// Named destinations can be slow to resolve. By default, the outline parser will resolve up to 500 destinations. If more than 500 destinations are set, resolving is delayed to when the PSPDFOutlineElement is first used.
/// @warning Change this before you first call outline. Future changes won't have any effect.
@property (nonatomic, assign) NSUInteger namedDestinationResolveThreshold;

@end

@interface PSPDFOutlineParser (Deprecated)

/// Resolve the destinationName of an outline element.
/// Will return NO if destinationName is nil or couldn't be resolved.
- (BOOL)resolveDestinationNameForOutlineElement:(PSPDFOutlineElement *)outlineElement __attribute__ ((deprecated("Use [action resolveNamedDestionationWithDocumentProvider]")));

@end
