//
//  PSPDFPDFPageView.h
//  PSPDFKit
//
//  Created by Peter Steinberger on 7/20/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

@class PSPDFTilingView, PSPDFDocument;

/// container for a PDF page.
@interface PSPDFPage : NSObject {
    PSPDFDocument   *document_;
    NSUInteger       page_;
    CGPDFDocumentRef pdfDocument_;
    CGPDFPageRef     pdfPage_;
    PSPDFTilingView *pdfView_;
    CGFloat          pdfScale_;    
    BOOL             destroyed_;
    UIImageView     *backgroundImageView_;
}

/// configure page container with data
- (void)displayDocument:(PSPDFDocument *)document page:(NSUInteger)page pageRect:(CGRect)pageRect scale:(CGFloat)scale;

/// recycle page, removes all set properties, prepare for reuse
//- (void)prepareForReuse;

/// destroys and removes CATiledLayer. Call prior deallocating
- (void)destroyPage;

/// removes background, saves memory
- (void)removeBackgroundView;

/// set background image to custom image. used in PSPDFTiledLayer.
- (void)setBackgroundImage:(UIImage *)image animated:(BOOL)animated;

/// readonly properties. recreate page to re-set
@property(nonatomic, assign, readonly) NSUInteger page;
@property(nonatomic, retain, readonly) PSPDFDocument *document;
@property(nonatomic, assign, readonly) CGFloat pdfScale;
@property(nonatomic, retain, readonly) PSPDFTilingView *pdfView;
@property(nonatomic, retain, readonly) UIImageView *backgroundImageView;

@end
