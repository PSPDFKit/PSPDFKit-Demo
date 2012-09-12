//
//  PSPDFPageInfo.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFDocument;

/// Represents a PDF page. Managed within PSPDFDocument.
/// With NSCopying, PSPDFDocument is not serialized.
@interface PSPDFPageInfo : NSObject <NSCopying, NSCoding>

/// Init object with page and rotation.
- (id)initWithPage:(NSUInteger)page rect:(CGRect)pageRect rotation:(NSInteger)rotation document:(PSPDFDocument *)document;

/// Saved aspect ratio of current page.
@property(nonatomic, assign, readonly) CGRect pageRect;

/// Returns corrected, rotated bounds of pageRect.
@property(nonatomic, assign, readonly) CGRect rotatedPageRect;

/// Saved page rotation of current page. Value between 0 and 270.
/// Can be used to manually rotate pages (but needs a cache clearing and a reload)
@property(nonatomic, assign) NSUInteger pageRotation;

/// Page transform matrix.
@property(nonatomic, assign, readonly) CGAffineTransform pageRotationTransform;

/// Referenced page.
@property(nonatomic, assign, readonly) NSUInteger page;

/// Referenced document, weak.
@property(nonatomic, ps_weak, readonly) PSPDFDocument *document;

@end
