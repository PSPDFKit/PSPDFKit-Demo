//
//  PSPDFScrollView.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFLongPressGestureRecognizer.h"

@protocol PSPDFAnnotationView;
@class PSPDFDocument, PSPDFPageView, PSPDFViewController, PSPDFLoupeView;

typedef NS_ENUM(NSInteger, PSPDFShadowStyle) {
    PSPDFShadowStyleFlat,   // flat  shadow style (Default)
    PSPDFShadowStyleCurl,   // curled shadow style
};

/**
 ScrollView that manages one or multiple PSPDFView's.
 Depending on the pageTransition, either every PSPDFPageView is embedded in a PSPDFScrollView,
 or there is one global PSPDFScrollView for all PSPDFPageView's.
 This is also the center for all the gesture recognizers. Subclass to customize behavior (e.g. override gestureRecognizerShouldBegin)
 */
@interface PSPDFScrollView : UIScrollView <UIScrollViewDelegate, PSPDFLongPressGestureRecognizerDelegate>

/// Display specific document with specified page.
- (void)displayDocument:(PSPDFDocument *)document withPage:(NSUInteger)page;

/// Releases document, removes all caches. Call before releasing. Can be called multiple times w/o error.
- (void)releaseDocument;

/// Current displayed page.
@property (nonatomic, assign) NSUInteger page;

/// Associated document.
@property (nonatomic, strong, readonly) PSPDFDocument *document;

/// Weak reference to parent pdfController.
@property (nonatomic, ps_weak) PSPDFViewController *pdfController;

/// Left page. Always set. Not used if pageCurlEnabled.
@property (nonatomic, strong, readonly) PSPDFPageView *leftPage;

/// Right page, if doublePageMode is enabled. Not used if the pageCurl transition is used.
@property (nonatomic, strong, readonly) PSPDFPageView *rightPage;

/// Style of the page shadow. Defaults to PSPDFShadowStyleFlat. Can be customized with overriding pathShadowForView.
@property (nonatomic, assign) PSPDFShadowStyle shadowStyle;

/// Enables/Disables zooming. Defaults to YES. If set to NO, will lock current zoom level.
@property (nonatomic, assign, getter=isZoomingEnabled) BOOL zoomingEnabled;


/// @name Mirrored properties from PSPDFViewController

/// If YES, two sites are displayed.
@property (nonatomic, assign, getter=isDoublePageMode) BOOL doublePageMode;

/// Shows first document page alone. Not relevant in PSPDFPageModeSinge.
@property (nonatomic, assign, getter=isDoublePageModeOnFirstPage) BOOL doublePageModeOnFirstPage;

/// Allow zooming of small documents to screen width/height.
@property (nonatomic, assign, getter=isZoomingSmallDocumentsEnabled) BOOL zoomingSmallDocumentsEnabled;

/// If true, pages are fit to screen width, not to either height or width (which one is larger - usually height)
@property (nonatomic, assign, getter=isFitToWidthEnabled) BOOL fitToWidthEnabled;

/// Enables/disables page shadow.
@property (nonatomic, assign, getter=isShadowEnabled) BOOL shadowEnabled;

/// Tap on begin/end of page scrolls to previous/next page.
@property (nonatomic, assign, getter=isScrollOnTapPageEndEnabled) BOOL scrollOnTapPageEndEnabled;

@end

@interface PSPDFScrollView (PSPDFSubclassing)

// Gesture recognizers to sync with your own recognizers.
// Don't change the delegate or things will break.
@property (nonatomic, strong, readonly) UITapGestureRecognizer *singleTapGesture;
@property (nonatomic, strong, readonly) UITapGestureRecognizer *doubleTapGesture;
@property (nonatomic, strong, readonly) UILongPressGestureRecognizer *longPressGesture;

/// Disables singleTapGesture for the current ongoing touch.
- (void)setCurrentTouchEventAsProcessed;

/**
    Hit-Testing
 
    PSPDFKit has a UITapGestureRecognizer to detects taps. There are several different actions called, if one succeeds further processing will be stopped.
 
    First, we check if we hit a PSPDFLinkAnnotationView and invoke the delegates and default action if found.
 
    Next, we check if there's text selection and discard if.
    Then, touches are relayed to all visible PSPDFPageView's and singleTapped: is called. If one page reports that the touch has been processed; the loop is stopped.
 
    Next, the didTapOnPageView:atPoint: delegate is called if the touch still hasn't been processed.
 
    Lastly, if even the delegate returned NO, we look if isScrollOnTapPageEndEnabled and scroll to the next/previous page if the border is near enough; or just toggle the HUD (if that is allowed)
 */
- (void)singleTapped:(UITapGestureRecognizer *)recognizer;
- (void)doubleTapped:(UITapGestureRecognizer *)recognizer;
- (void)longPress:(UILongPressGestureRecognizer *)recognizer;

// Allows changing the shadow path.
- (id)pathShadowForView:(UIView *)imgView; // returns CGPathRef

@end

@interface PSPDFScrollView (PSPDFInternal)

// View that gets zoomed. attach your views here instead of the PSPDFScrollView to get them zoomed.
@property (nonatomic, strong, readonly) UIView *compoundView;

/// Global loupe view.
@property (nonatomic, strong, readonly) PSPDFLoupeView *loupeView;

// Used for improved rotation handling.
@property (nonatomic, assign, getter=isRotationActive) BOOL rotationActive;

/// Track animations of zoomToRect:animated: if we're zooming IN.
/// (Used to decide when it's best to tile pages in ContinuousScroll)
@property (nonatomic, assign, getter=isAnimatingZoomIn, readonly) BOOL animatingZoomIn;

// Internal use for smooth rotations. Don't call unless you know exactly whay you're doing.
- (void)switchPages;

// Call to manually re-center the content.
- (void)ensureContentIsCentered;

// Return the actual PSPDFPageView behind point.
- (PSPDFPageView *)pageViewForPoint:(CGPoint)point;

@end
