//
//  PSPDFPDFPageView.h
//  PSPDFKit
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

@class PSPDFScrollView, PSPDFTilingView, PSPDFDocument;

/// Compound view for a single pdf page. Will not be re-used for different pages.
/// You can add your own views on top of the UIView (e.g. custom annotations)
@interface PSPDFPageView : UIView 

/// configure page container with data.
- (void)displayDocument:(PSPDFDocument *)document page:(NSUInteger)page pageRect:(CGRect)pageRect scale:(CGFloat)scale;

/// destroys and removes CATiledLayer. Call prior deallocating.
/// Don't set removeFromView to YES if destroy is *not* on the main thread.
- (void)destroyPageAndRemoveFromView:(BOOL)removeFromView;

/// set background image to custom image. used in PSPDFTiledLayer.
- (void)setBackgroundImage:(UIImage *)image animated:(BOOL)animated;

// ** readonly properties. recreate page to re-set **

/// Access parent PSPDFScrollView. (zoom controller)
@property(nonatomic, assign) PSPDFScrollView *scrollView;

/// Page that is displayed. Readonly.
@property(nonatomic, assign, readonly) NSUInteger page;

/// Document that is displayed. Readonly.
@property(nonatomic, retain, readonly) PSPDFDocument *document;

/// Calculated scale. Readonly.
@property(nonatomic, assign, readonly) CGFloat pdfScale;

/// CATiledLayer subview. Not visible while rotation.
@property(nonatomic, retain, readonly) PSPDFTilingView *pdfView;

/// UIImageView subview. Beneath the PSPDFTilingView.
@property(nonatomic, retain, readonly) UIImageView *backgroundImageView;

@end
