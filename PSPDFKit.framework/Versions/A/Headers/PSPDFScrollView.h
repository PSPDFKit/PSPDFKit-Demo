//
//  PSPDFScrollView.h
//  PSPDFKit
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PSPDFKitGlobal.h"

@protocol PSPDFAnnotationView;
@class PSPDFDocument, PSPDFTilingView, PSPDFPageView, PSPDFViewController;

enum {
    PSPDFShadowStyleFlat,   // new default shadow style (1.8+)
    PSPDFShadowStyleCurl,   // old shadow style (< 1.8)
}typedef PSPDFShadowStyle;

/// Scrollview for a single page. Every PSPDFPageView is embedded in a PSPDFScrollView.
@interface PSPDFScrollView : UIScrollView <UIScrollViewDelegate>

/// display specific document with specified page.
- (void)displayDocument:(PSPDFDocument *)aDocument withPage:(NSUInteger)pageId;

/// releases document, removes all caches. Call before releasing. Can be called multiple times w/o error.
- (void)releaseDocumentAndCallDelegate:(BOOL)callDelegate;

// for memory warning relay. clears up internal resources.
- (void)didReceiveMemoryWarning;

// internal use for smooth rotations. Don't call unless you know exactly whay you're doing.
- (void)switchPages;

/// weak reference to parent pdfController.
@property(nonatomic, ps_weak) PSPDFViewController *pdfController;

/// current displayed page.
@property(nonatomic, assign) NSUInteger page;

/// actual view that gets zoomed. attach your views here instead of the PSPDFScrollView to get them zoomed.
@property(nonatomic, strong, readonly) UIView *compoundView;

/// if YES, two sites are displayed.
@property (nonatomic, assign, getter=isDualPageMode) BOOL dualPageMode;

/// shows first document page alone. Not relevant in PSPDFPageModeSinge.
@property(nonatomic, assign) BOOL doublePageModeOnFirstPage;

/// allow zooming of small documents to screen width/height.
@property(nonatomic, assign, getter=isZoomingSmallDocumentsEnabled) BOOL zoomingSmallDocumentsEnabled;

/// if true, pages are fit to screen width, not to either height or width (which one is larger - usually height)
@property(nonatomic, assign, getter=isFittingWidth) BOOL fitWidth;

/// enables/disables page shadow.
@property(nonatomic, assign, getter=isShadowEnabled) BOOL shadowEnabled;

/// Style of the page shadow. Defaults to PSPDFShadowStyleFlat. Can be customized with overriding pathShadowForView.
@property(nonatomic, assign) PSPDFShadowStyle shadowStyle;

/// tap on begin/end of page scrolls to previous/next page.
@property(nonatomic, assign, getter=isScrollOnTapPageEndEnabled) BOOL scrollOnTapPageEndEnabled;

/// show/hide tiled layer.
@property(nonatomic, assign, getter=isRotationActive) BOOL rotationActive;

/// left page. Always set.
@property(nonatomic, strong, readonly) PSPDFPageView *leftPage;

/// right page, if doublePageMode is enabled.
@property(nonatomic, strong, readonly) PSPDFPageView *rightPage;

/// for subclassing - allows changing the shadow path.
- (id)pathShadowForView:(UIView *)imgView; // returns CGPathRef

@end

/// Define a private interface for annotation views to pass messages back to the controller via the page view
@interface PSPDFScrollView (PSPDFAnnotationInteraction)

/// invoked when the user touches up inside the button associated with the given annotation view with a button
- (void)pageView:(PSPDFPageView *)pageView didTouchUpInsideAnnotationView:(UIView <PSPDFAnnotationView> *)annotationView;

@end
