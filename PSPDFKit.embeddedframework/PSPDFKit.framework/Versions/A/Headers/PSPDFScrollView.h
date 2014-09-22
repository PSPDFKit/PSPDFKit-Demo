//
//  PSPDFScrollView.h
//  PSPDFKit
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PSPDFLongPressGestureRecognizer.h"
#import "PSPDFKeyboardAvoidingScrollView.h"
#import "PSPDFPresentationContext.h"

@protocol PSPDFAnnotationViewProtocol;
@class PSPDFDocument, PSPDFPageView, PSPDFViewController, PSPDFConfiguration;

/**
 ScrollView that manages one or multiple `PSPDFPageView's`.

 Depending on the `pageTransition`, either every `PSPDFPageView` is embedded in a `PSPDFScrollView`,
 or there is one global `PSPDFScrollView` for all `PSPDFPageView's`.
 This is also the center for all the gesture recognizers. Subclass to customize behavior (e.g. override `gestureRecognizerShouldBegin:`)

 @warning If you manually zoom/change the contentOffset, you must use the methods with animation extension.
 (You don't have to animate, but those are overridden by PSPDFKit to properly inform the `PSPDFPageViews` to re-render. You can also use the default `UIScrollView` properties and manually call updateRenderView on each visible PSPDFPageView)

`- (void)setZoomScale:(float)scale animated:(BOOL)animated;`
`- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated;`
`- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;`
 */
@interface PSPDFScrollView : PSPDFKeyboardAvoidingScrollView <UIScrollViewDelegate, PSPDFLongPressGestureRecognizerDelegate>

// Designated initializer.
- (instancetype)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;

/// Display specific document with specified page.
- (void)displayPage:(NSUInteger)page;

/// Releases document, removes all caches. Call before releasing. Can be called multiple times w/o error.
- (void)prepareForReuse;

/// Current displayed page.
@property (nonatomic, assign) NSUInteger page;

/// The configuration data source for this scroll view
@property (nonatomic, weak) id<PSPDFPresentationContext> presentationContext;

/// Left page. Always set. Not used in `PSPDFPageTransitionCurl`.
@property (nonatomic, strong, readonly) PSPDFPageView *leftPage;

/// Right page, if doublePageMode is enabled. Not used if the pageCurl transition is used.
@property (nonatomic, strong, readonly) PSPDFPageView *rightPage;

/// Enables/Disables zooming. Defaults to YES. If set to NO, will lock current zoom level.
@property (nonatomic, assign, getter=isZoomingEnabled) BOOL zoomingEnabled;

@end

@interface PSPDFScrollView (PSPDFSubclassing)

// Gesture recognizers to sync with your own recognizers.
// Don't change the delegate or things will break.
@property (nonatomic, strong, readonly) UITapGestureRecognizer *singleTapGesture;
@property (nonatomic, strong, readonly) UITapGestureRecognizer *doubleTapGesture;
@property (nonatomic, strong, readonly) UILongPressGestureRecognizer *longPressGesture;

/**
 Hit-Testing

 PSPDFKit has a `UITapGestureRecognizer` to detects taps. There are several different actions called, if one succeeds further processing will be stopped.

 First, we check if we hit a `PSPDFLinkAnnotationView` and invoke the delegates and default action if found.

 Next, we check if there's text selection and discard if.
 Then, touches are relayed to all visible `PSPDFPageView's` and `singleTapped:` is called. If one page reports that the touch has been processed; the loop is stopped.

 Next, the `didTapOnPageView:atPoint:` delegate is called if the touch still hasn't been processed.

 Lastly, if even the delegate returned NO, we look if `isScrollOnTapPageEndEnabled` and scroll to the next/previous page if the border is near enough; or just toggle the HUD (if that is allowed)

 Do note that the single and double tap gestures do not have dependencies. This has been made to improve single tap performance.
 If your app requires this, you can manually add this dependency.
 */
- (void)singleTapped:(UITapGestureRecognizer *)recognizer;
- (void)doubleTapped:(UITapGestureRecognizer *)recognizer;
- (void)longPress:(UILongPressGestureRecognizer *)recognizer;

// Allows changing the shadow path.
- (id)pathShadowForView:(UIView *)view; // returns `CGPathRef`.

// Call to manually re-center the content.
- (void)ensureContentIsCentered;

// Creates and sets up the double tap gesture. Override and return nil to remove it.
- (UITapGestureRecognizer *)createDoubleTapGesture;

// View that gets zoomed. attach your views here instead of the `PSPDFScrollView` to get them zoomed.
@property (nonatomic, strong, readonly) UIView *compoundView;

@end

@interface PSPDFScrollView (PSPDFAdvanced)

/// Returns all selected annotations of all visible `PSPDFPageViews`.
@property (nonatomic, copy, readonly) NSArray *selectedAnnotations;

@end
