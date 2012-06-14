//
//  PSPDFPageInfo.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSPDFKitGlobal.h"

@class PSPDFDocument;

/// Represents a PDF page. Managed within PSPDFDocument.
@interface PSPDFPageInfo : NSObject

/// init object with page and rotation.
- (id)initWithPage:(NSUInteger)page rect:(CGRect)pageRect rotation:(NSInteger)rotation document:(PSPDFDocument *)document;

/// saved aspect ratio of current page.
@property(nonatomic, assign, readonly) CGRect pageRect;

/// returns corrected, rotated bounds of pageRect.
@property(nonatomic, assign, readonly) CGRect rotatedPageRect;

/// saved page rotation of current page. Value between 0 and 270.
@property(nonatomic, assign, readonly) NSUInteger pageRotation;

/// Page transform matrix.
@property(nonatomic, assign, readonly) CGAffineTransform pageRotationTransform;

/// referenced page.
@property(nonatomic, assign, readonly) NSUInteger page;

/// referenced document, weak.
@property(nonatomic, ps_weak, readonly) PSPDFDocument *document;

@end


/// saves various page coordinates.
@interface PSPDFPageCoordinates : NSObject

/// initializes coordinate class, autoreleased.
+ (id)pageCoordinatesWithpdfPoint:(CGPoint)pdfPoint screenPoint:(CGPoint)screenPoint viewPoint:(CGPoint)viewPoint pageSize:(CGSize)pageSize zoomScale:(CGFloat)zoomScale;

/// initializes coordinate class, autoreleased.
- (id)initCoordinatesWithpdfPoint:(CGPoint)pdfPoint screenPoint:(CGPoint)screenPoint viewPoint:(CGPoint)viewPoint pageSize:(CGSize)pageSize zoomScale:(CGFloat)zoomScale;

/// point relative to pdf coordinates.
@property(nonatomic, assign, readonly) CGPoint pdfPoint;

/// point relative to screen.
@property(nonatomic, assign, readonly) CGPoint screenPoint;

/// point realtive to view where pdf is displayed.
@property(nonatomic, assign, readonly) CGPoint viewPoint;

/// page size. (pdf may be upscaled AND zoomd via the scrollview)
@property(nonatomic, assign, readonly) CGSize pageSize;

/// current active zoomScale.
@property(nonatomic, assign, readonly) CGFloat zoomScale;

@end
