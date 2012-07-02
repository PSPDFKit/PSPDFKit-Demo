//
//  PSPDFScrollView.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@protocol PSPDFAnnotationView;
@class PSPDFDocument, PSPDFPageView, PSPDFViewController, PSPDFLoupeView;

typedef NS_ENUM(NSInteger, PSPDFShadowStyle) {
    PSPDFShadowStyleFlat,   // flat  shadow style (Default)
    PSPDFShadowStyleCurl,   // curled shadow style
};

/// Scrollview for a single page. Every PSPDFPageView is embedded in a PSPDFScrollView.
@interface PSPDFScrollView : UIScrollView <UIScrollViewDelegate>

/// display specific document with specified page.
- (void)displayDocument:(PSPDFDocument *)document withPage:(NSUInteger)page;

/// releases document, removes all caches. Call before releasing. Can be called multiple times w/o error.
- (void)releaseDocument;

/// current displayed page.
@property(nonatomic, assign) NSUInteger page;

/// Associated document.
@property(nonatomic, strong, readonly) PSPDFDocument *document;

/// weak reference to parent pdfController.
@property(nonatomic, ps_weak) PSPDFViewController *pdfController;

/// left page. Always set. Not used if pageCurlEnabled.
@property(nonatomic, strong, readonly) PSPDFPageView *leftPage;

/// right page, if doublePageMode is enabled. Not used if pageCurlEnabled.
@property(nonatomic, strong, readonly) PSPDFPageView *rightPage;

/// Style of the page shadow. Defaults to PSPDFShadowStyleFlat. Can be customized with overriding pathShadowForView.
@property(nonatomic, assign) PSPDFShadowStyle shadowStyle;


/// @name Mirrored properties from PSPDFViewController

/// if YES, two sites are displayed.
@property (nonatomic, assign, getter=isDualPageMode) BOOL dualPageMode;

/// shows first document page alone. Not relevant in PSPDFPageModeSinge.
@property(nonatomic, assign, getter=isDoublePageModeOnFirstPage) BOOL doublePageModeOnFirstPage;

/// allow zooming of small documents to screen width/height.
@property(nonatomic, assign, getter=isZoomingSmallDocumentsEnabled) BOOL zoomingSmallDocumentsEnabled;

/// if true, pages are fit to screen width, not to either height or width (which one is larger - usually height)
@property(nonatomic, assign, getter=isFittingWidth) BOOL fitWidth;

/// enables/disables page shadow.
@property(nonatomic, assign, getter=isShadowEnabled) BOOL shadowEnabled;

/// tap on begin/end of page scrolls to previous/next page.
@property(nonatomic, assign, getter=isScrollOnTapPageEndEnabled) BOOL scrollOnTapPageEndEnabled;

@end

@interface PSPDFScrollView (PSPDFSubclassing)

// Gesture recognizers to sync with your own recognizers.
// Don't change the delegate or things will break.
@property(nonatomic, strong, readonly) UITapGestureRecognizer *singleTapGesture;
@property(nonatomic, strong, readonly) UITapGestureRecognizer *doubleTapGesture;
@property(nonatomic, strong, readonly) UILongPressGestureRecognizer *longPressGesture;

- (void)singleTapped:(UITapGestureRecognizer *)recognizer;
- (void)doubleTapped:(UITapGestureRecognizer *)recognizer;
- (void)longPress:(UILongPressGestureRecognizer *)recognizer;

// Allows changing the shadow path.
- (id)pathShadowForView:(UIView *)imgView; // returns CGPathRef

@end

@interface PSPDFScrollView (PSPDFInternal)

// View that gets zoomed. attach your views here instead of the PSPDFScrollView to get them zoomed.
@property(nonatomic, strong, readonly) UIView *compoundView;

/// Global loupe view.
@property(nonatomic, strong, readonly) PSPDFLoupeView *loupeView;

// Used for improved rotation handling.
@property(nonatomic, assign, getter=isRotationActive) BOOL rotationActive;

// for memory warning relay. clears up internal resources.
- (void)didReceiveMemoryWarning;

// internal use for smooth rotations. Don't call unless you know exactly whay you're doing.
- (void)switchPages;

// Return the actual PSPDFPageView behind point.
- (PSPDFPageView *)pageViewForPoint:(CGPoint)point;

@end
