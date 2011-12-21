//
//  PSPDFDocumentProvider.h
//  PSPDFKit
//
//  Copyright (c) 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

/// Encapsulates the CoreGraphics-calls to the CGPDF* data providers.
/// We need to keep around the document when accessing a CGPDFPage. Retaining the page alone is not enough.
@interface PSPDFDocumentProvider : NSObject

/// Initializes provider with a document reference.
- (id)initWithDocumentRef:(CGPDFDocumentRef)documentRef URL:(NSURL *)URL;

/// Get access to document reference.
- (CGPDFDocumentRef)requestDocumentRef;

/// Return the document reference back to the provider
- (void)releaseDocumentRef:(CGPDFDocumentRef)documentRef;

/// Requests a page for the current loaded document. Needs to be returned in releasePageRef.
- (CGPDFPageRef)requestPageRefForPage:(NSUInteger)page;

/// Releases a page reference. 
- (void)releasePageRef:(CGPDFPageRef)pageRef;

/// URL of the managed document
@property(nonatomic, strong, readonly) NSURL *URL;

@end
