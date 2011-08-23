//
//  PSPDFPageInfo.h
//  PSPDFKit
//
//  Created by Peter Steinberger on 8/6/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

@class PSPDFDocument;

/// saves various data of a page. Managed within PSPDFDocument.
@interface PSPDFPageInfo : NSObject {
    CGRect pageRect_;
    NSUInteger pageRotation_;
    NSUInteger page_;
    PSPDFDocument *document_;
}

/// autoreleased object with page and rotation
+ (id)pageInfoWithRect:(CGRect)rect rotation:(NSUInteger)rotation;

/// init object with page and rotation
- (id)initWithRect:(CGRect)rect rotation:(NSUInteger)rotation;

/// saved aspect ratio of current page
@property(nonatomic, assign) CGRect pageRect;

/// returns corrected, rotated bounds of pageRect
@property(nonatomic, assign, readonly) CGRect rotatedPageRect;

/// saved page rotation of current page
@property(nonatomic, assign) NSUInteger pageRotation;

/// referenced page
@property(nonatomic, assign) NSUInteger page;

/// referenced document, weak
@property(nonatomic, assign) PSPDFDocument *document;

@end


/// saves various coordinates in delegate
@interface PSPDFPageCoordinates : NSObject {
    CGPoint pdfPoint_;
    CGPoint screenPoint_;
    CGPoint viewPoint_;
    CGSize  pageSize_;
    CGFloat zoomScale_;
}

/// initializes coordinate class, autoreleased
+ (id)pageCoordinatesWithpdfPoint:(CGPoint)pdfPoint screenPoint:(CGPoint)screenPoint viewPoint:(CGPoint)viewPoint pageSize:(CGSize)pageSize zoomScale:(CGFloat)zoomScale;

/// initializes coordinate class, autoreleased
- (id)initCoordinatesWithpdfPoint:(CGPoint)pdfPoint screenPoint:(CGPoint)screenPoint viewPoint:(CGPoint)viewPoint pageSize:(CGSize)pageSize zoomScale:(CGFloat)zoomScale;

/// point relative to pdf coordinates
@property(nonatomic, assign, readonly) CGPoint pdfPoint;

/// point relative to screen
@property(nonatomic, assign, readonly) CGPoint screenPoint;

/// point realtive to view where pdf is displayed
@property(nonatomic, assign, readonly) CGPoint viewPoint;

/// page size (pdf may be upscaled AND zoomd via the scrollview)
@property(nonatomic, assign, readonly) CGSize pageSize;

/// current active zoomScale
@property(nonatomic, assign, readonly) CGFloat zoomScale;

@end
