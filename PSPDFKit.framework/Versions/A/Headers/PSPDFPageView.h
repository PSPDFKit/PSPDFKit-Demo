//
//  PSPDFPDFPageView.h
//  PSPDFKit
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PSPDFKitGlobal.h"

@class PSPDFScrollView, PSPDFTilingView, PSPDFDocument;

/// Compound view for a single pdf page. Will not be re-used for different pages.
/// You can add your own views on top of the UIView (e.g. custom annotations)
@interface PSPDFPageView : UIView 

/// configure page container with data.
- (void)displayDocument:(PSPDFDocument *)document page:(NSUInteger)page pageRect:(CGRect)pageRect scale:(CGFloat)scale;

/// destroys and removes CATiledLayer. Call prior deallocating.
/// Don't set removeFromView to YES if destroy is *not* on the main thread.
- (void)destroyPageAndRemoveFromView:(BOOL)removeFromView callDelegate:(BOOL)callDelegate;

/// set background image to custom image. used in PSPDFTiledLayer.
- (void)setBackgroundImage:(UIImage *)image animated:(BOOL)animated;

/// Access parent PSPDFScrollView if available. (zoom controller)
@property(nonatomic, ps_weak, readonly) PSPDFScrollView *scrollView;

/// Page that is displayed. Readonly.
@property(nonatomic, assign, readonly) NSUInteger page;

/// Document that is displayed. Readonly.
@property(nonatomic, strong, readonly) PSPDFDocument *document;

/// Calculated scale. Readonly.
@property(nonatomic, assign, readonly) CGFloat pdfScale;

/// CATiledLayer subview. Not visible while rotation. Readonly.
@property(nonatomic, strong, readonly) PSPDFTilingView *pdfView;

/// UIImageView subview. Beneath the PSPDFTilingView. Readonly.
@property(nonatomic, strong, readonly) UIImageView *backgroundImageView;

/// If YES, there is no thumbnail flickering if they are available in mem/disk.
/// This looks nicer, but is a bit slower as we decompress in main thread.
/// Defaults to NO. (behavior in PSPPDFKit < 1.8.2 was YES)
@property(nonatomic, assign) BOOL loadThumbnailsOnMainThread;

@end
