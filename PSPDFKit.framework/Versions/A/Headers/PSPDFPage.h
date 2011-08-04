//
//  PSPDFPDFPageView.h
//  PSPDFKit
//
//  Created by Peter Steinberger on 7/20/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

@class PSPDFTilingView, PSPDFDocument;

// container for a PDF page.
@interface PSPDFPage : NSObject {
    PSPDFDocument   *document_;
    NSUInteger       page_;
    
    CGPDFDocumentRef pdfDocument_;
    CGPDFPageRef     pdfPage_;
    PSPDFTilingView *pdfView_;
    
    CGFloat          pdfScale_;
    
    // A low res image of the PDF page that is displayed until the PSPDFPDFTilingView renders its content.
    BOOL             backgroundImageCached_; 
    BOOL             destroyed_;
    UIImageView     *backgroundImageView_;
}

// init page container with data
- (id)initWithDocument:(PSPDFDocument *)document page:(NSUInteger)page pageRect:(CGRect)pageRect scale:(CGFloat)scale;

// readonly properties. recreate page to re-set
@property(assign, readonly) NSUInteger page;
@property(retain, readonly) PSPDFDocument *document;
@property(nonatomic, assign, readonly) CGFloat pdfScale;
@property(nonatomic, retain, readonly) PSPDFTilingView *pdfView;
@property(nonatomic, retain, readonly) UIImageView *backgroundImageView;

// if page is no longer used, mark it as destroyed. (even if blocks hold onto it)
@property(nonatomic, getter=isDestroyed) BOOL destroyed;

@end
