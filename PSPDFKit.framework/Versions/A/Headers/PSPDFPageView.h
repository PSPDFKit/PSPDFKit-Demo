//
//  PSPDFPDFPageView.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PSPDFKitGlobal.h"
#import "PSPDFRenderer.h"

@class PSPDFPageInfo, PSPDFScrollView, PSPDFDocument, PSPDFViewController, PSPDFTextParser, PSPDFSelectionView, PSPDFAnnotation;

/// Compound view for a single pdf page. Will not be re-used for different pages.
/// You can add your own views on top of the UIView (e.g. custom annotations)
@interface PSPDFPageView : UIView <UIScrollViewDelegate, PSPDFRenderDelegate>

/// @name Show / Destroy a document

/// configure page container with data.
- (void)displayDocument:(PSPDFDocument *)document page:(NSUInteger)page pageRect:(CGRect)pageRect scale:(CGFloat)scale delayPageAnnotations:(BOOL)delayPageAnnotations pdfController:(PSPDFViewController *)pdfController;

/// Prepares the PSPDFPageView for reuse. Removes all unknown internal UIViews.
- (void)prepareForReuse;

/// @name Coordinate calculations

/// Convert a view point to the corresponding pdf point.
/// pageBounds usually is PSPDFPageView bounds.
- (CGPoint)convertViewPointToPDFPoint:(CGPoint)viewPoint;

/// Convert a pdf point to the corresponding view point.
/// pageBounds usually is PSPDFPageView bounds.
- (CGPoint)convertPDFPointToViewPoint:(CGPoint)pdfPoint;

/// Convert a view rect to the corresponding pdf rect.
- (CGRect)convertViewRectToPDFRect:(CGRect)viewRect;

/// Convert a pdf rect to the corresponding view rect
- (CGRect)convertPDFRectToViewRect:(CGRect)pdfRect;


/// @name Accessors

/// Access parent PSPDFScrollView if available. (zoom controller)
/// Note: this only lets you access the scrollView if it's in the view hiararchy.
/// If we use pageCurl mode, we have a global scrollView which can be accessed with pdfController.pagingScrollView
- (PSPDFScrollView *)scrollView;

/// Returns an array of UIView <PSPDFAnnotationView> objects currently in the view hierarchy.
- (NSArray *)visibleAnnotationViews;

/// Access pdfController
@property(nonatomic, ps_weak, readonly) PSPDFViewController *pdfController;

/// Page that is displayed. Readonly.
@property(nonatomic, assign, readonly) NSUInteger page;

/// Document that is displayed. Readonly.
@property(nonatomic, strong, readonly) PSPDFDocument *document;

/// Calculated scale. Readonly.
@property(nonatomic, assign, readonly) CGFloat pdfScale;

/// UIImageView subview showing the whole document. Readonly.
@property(nonatomic, strong, readonly) UIImageView *contentView;

/// UIImageView for the zoomed in state. Readonly.
@property(nonatomic, strong, readonly) UIImageView *renderView;

/// Size used for the zoomed-in part. Should always be bigger than the screen.
@property(nonatomic, assign) CGSize renderSize;

/// Temporarily suspend rendering updates to the renderView. 
@property(nonatomic, assign) BOOL suspendUpdate;

/// Access the selectionView.
@property(nonatomic, strong, readonly) PSPDFSelectionView *selectionView;

/// Shortcut to access the textParser corresponding to the current page.
@property(nonatomic, strong, readonly) PSPDFTextParser *textParser;

/// Shortcut to access the current boxRect of the set page.
@property(nonatomic, assign, readonly) PSPDFPageInfo *pageInfo;


/// @name Advanced Settings and Methods

/// set background image to custom image. used in PSPDFTiledLayer.
- (void)setBackgroundImage:(UIImage *)image animated:(BOOL)animated;


/// @name Shadow settings

/// Enables shadow for a single page. Only useful in combination with pageCurl.
@property(nonatomic, assign, getter=isShadowEnabled) BOOL shadowEnabled;

/// Set default shadowOpacity. Defaults to 0.7.
@property(nonatomic, assign) float shadowOpacity;

/// Subclass to change shadow behavior.
- (void)updateShadow;

// Redraw the renderView
- (void)updateRenderView;

// Redraw renderView and contentView
- (void)updateView;

/// Set block that is executed within updateShadow when isShadowEnabled = YES.
@property(nonatomic, copy) void(^updateShadowBlock)(PSPDFPageView *pageView);

@end

@interface PSPDFPageView (PSPDFAnnotationMenu)

@property(nonatomic, strong, readonly) PSPDFAnnotation *selectedAnnotation;

// Process a tap, we might have an annotation underneath.
// Returns YES if the tap has been handled, NO if not.
- (BOOL)singleTap:(UITapGestureRecognizer *)recognizer;

// Handle long press, potentially relay to subviews
- (BOOL)longPress:(UILongPressGestureRecognizer *)recognizer;

// Returns available UIMenuItem for the current annotation.
// To extend this, selectors for UIMenuItem need to be implemented in a subclass.
- (NSArray *)menuItemsForAnnotation:(PSPDFAnnotation *)annotation;

// Called when a annotation was found ad the tapped location.
// This will call menuItemsForAnnotation to show a UIMenuController.
- (void)showMenuForAnnotation:(PSPDFAnnotation *)annotation;

@end

@interface PSPDFPageView (PSPDFScrollViewDelegateExtensions)

- (void)pspdf_scrollView:(UIScrollView *)scrollView willZoomToScale:(float)scale animated:(BOOL)animated;

@end
