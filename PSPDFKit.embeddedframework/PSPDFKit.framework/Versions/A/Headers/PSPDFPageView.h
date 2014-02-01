//
//  PSPDFPageView.h
//  PSPDFKit
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFRenderQueue.h"
#import "PSPDFResizableView.h"
#import "PSPDFHUDView.h"
#import "PSPDFLongPressGestureRecognizer.h"
#import "PSPDFSignatureViewController.h"
#import "PSPDFSignatureSelectorViewController.h"
#import "PSPDFStampViewController.h"
#import "PSPDFNoteAnnotationViewController.h"
#import "PSPDFFontSelectorViewController.h"
#import "PSPDFFontStyleViewController.h"
#import "PSPDFAnnotationStyleViewController.h"
#import "PSPDFAnnotation.h"
#import "PSPDFCache.h"

// The page view delegate, connected with the parent scroll view.
@protocol PSPDFPageViewDelegate <PSPDFOverridable> @end

@protocol PSPDFAnnotationViewProtocol;
@class PSPDFLinkAnnotation, PSPDFPageInfo, PSPDFScrollView, PSPDFDocument, PSPDFViewController, PSPDFTextParser, PSPDFTextSelectionView, PSPDFAnnotation, PSPDFRenderStatusView, PSPDFNoteAnnotation, PSPDFOrderedDictionary, PSPDFMenuItem, PSPDFFreeTextAnnotation;

@interface PSPDFAnnotationContainerView : PSPDFHUDView @end

// Notification is fired when the `selectedAnnotations` value changed.
// `object` is the pageView.
extern NSString *const PSPDFPageViewSelectedAnnotationsDidChangeNotification;

/// Compound view for a single PDF page. Will be re-used.
/// You can add your own views on top of the `annotationContainerView` (e.g. custom annotations)
/// Events from a attached UIScrollView will be relayed to all visible PSPDFPageView classes.
/// @note The UINavigationControllerDelegate is only defined to satisfy the UIImagePickerController delegate.
@interface PSPDFPageView : UIView <UIScrollViewDelegate, PSPDFRenderDelegate, PSPDFCacheDelegate, PSPDFResizableViewDelegate, PSPDFLongPressGestureRecognizerDelegate, PSPDFAnnotationGridViewControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate>

/// Designated initializer.
- (id)initWithFrame:(CGRect)frame delegate:(id <PSPDFPageViewDelegate>)delegate;

/// @name Show / Destroy a document

/// configure page container with data.
- (void)displayDocument:(PSPDFDocument *)document page:(NSUInteger)page pageRect:(CGRect)pageRect scale:(CGFloat)scale delayPageAnnotations:(BOOL)delayPageAnnotations pdfController:(PSPDFViewController *)pdfController;

/// Prepares the `PSPDFPageView` for reuse. Removes all unknown internal `UIViews`.
- (void)prepareForReuse;

/// @name Internal views and rendering

/// Redraw the `renderView` (dynamically rendered PDF for maximum sharpness, updated on every zoom level.)
- (void)updateRenderView;

/// Redraw `renderView` and `contentView`.
- (void)updateView;

/// If annotations are already loaded, and the annotation is a view, access it here.
/// (Most PDF annotations are actually rendered into the page; except annotations that return YES for `isOverlay`, like links or notes.
- (UIView <PSPDFAnnotationViewProtocol> *)annotationViewForAnnotation:(PSPDFAnnotation *)annotation;

/// UIImageView displaying the whole document. Readonly.
@property (nonatomic, strong, readonly) UIImageView *contentView;

/// UIImageView for the zoomed in state. Readonly.
@property (nonatomic, strong, readonly) UIImageView *renderView;

/**
 Container view for all overlay annotations.

 This is just a named subclass of `UIView` that will always track the frame of the `PSPDFPageView`.
 It's useful to coordinate this with your own subviews to get the zIndex right.

 @warning Most annotations will not be rendered as overlays or only when they are currently being selected.
 Rendering annotations within the pageView has several advantages including performance or view color multiplication (in case of highlight annotations)
 Do not manually add/remove views into the container view. Contents is managed. Views should respond to the `PSPDFAnnotationViewProtocol`, especially the annotation method.
 */
@property (nonatomic, strong, readonly) PSPDFAnnotationContainerView *annotationContainerView;

/// Access the selectionView. (handles text selection)
@property (nonatomic, strong, readonly) PSPDFTextSelectionView *selectionView;

/// Access the render status view that is displayed on top of a page while we are rendering.
@property (nonatomic, strong) PSPDFRenderStatusView *renderStatusView;

/// Top right offset. Defaults to 30.f.
@property (nonatomic, assign) CGFloat renderStatusViewOffset;

/// Should center render status view. Defaults to NO.
@property (nonatomic, assign) BOOL centerRenderStatusView;

/// Calculated scale. Readonly.
@property (nonatomic, assign, readonly) CGFloat PDFScale;

/// Is view currently rendering (either `contentView` or `renderView`)
@property (nonatomic, assign, getter=isRendering, readonly) BOOL rendering;

/// Current CGRect of the part of the page that's visible. Screen coordinate space.
/// @note If the scroll view is currently decelerating, this will show the TARGET rect, not the one that's currently animating.
@property (nonatomic, assign, readonly) CGRect visibleRect;

/// @name Coordinate calculations and object fetching

/// Convert a view point to the corresponding PDF point.
/// @note `pageBounds` usually is `PSPDFPageView` bounds.
- (CGPoint)convertViewPointToPDFPoint:(CGPoint)viewPoint;

/// Convert a PDF point to the corresponding view point.
/// @note `pageBounds` usually is `PSPDFPageView` bounds.
- (CGPoint)convertPDFPointToViewPoint:(CGPoint)pdfPoint;

/// Convert a view rect to the corresponding pdf rect.
- (CGRect)convertViewRectToPDFRect:(CGRect)viewRect;

/// Convert a PDF rect to the corresponding view rect
- (CGRect)convertPDFRectToViewRect:(CGRect)pdfRect;

/// Convert a PDF glyph rect to the corresponding view rect.
/// (Glyphs are not rotated on parsing to preserve reading direction, thus need to be converted differently than e.g. annotations)
- (CGRect)convertGlyphRectToViewRect:(CGRect)glyphRect;

/// Convert a view rect to PDF glyph rect.
/// This is equivalent to `[self convertPDFRectToViewRect:CGRectApplyAffineTransform(glyphRect, pageInfo.pageRotationTransform)]`
- (CGRect)convertViewRectToGlyphRect:(CGRect)viewRect;

/// Get the glyphs/words on a specific page.
- (NSDictionary *)objectsAtPoint:(CGPoint)viewPoint options:(NSDictionary *)options;

/// Get the glyphs/words on a specific rect.
/// Usage e.g. `NSDictionary *objects = [pageView objectsAtRect:rect options:@{PSPDFObjectsFullWords : @YES}]`;
- (NSDictionary *)objectsAtRect:(CGRect)viewRect options:(NSDictionary *)options;

/// @name Accessors

/// Access parent `PSPDFScrollView` if available. (zoom controller)
/// @note this only lets you access the scrollView if it's in the view hierarchy.
/// If we use pageCurl mode, we have a global scrollView which can be accessed with `pdfController.pagingScrollView`
- (PSPDFScrollView *)scrollView;

/// Returns an array of `UIView` `PSPDFAnnotationViewProtocol` objects currently in the view hierarchy.
- (NSArray *)visibleAnnotationViews;

/// Access the attached pdfController.
@property (atomic, weak, readonly) PSPDFViewController *pdfController;

/// Page that is displayed. Readonly.
@property (atomic, assign, readonly) NSUInteger page;

/// Document that is displayed. Readonly.
@property (atomic, strong, readonly) PSPDFDocument *document;

/// Shortcut to access the current boxRect of the set page.
@property (nonatomic, strong, readonly) PSPDFPageInfo *pageInfo;

/// Return YES if the pdfPage is displayed in a double page mode setup on the right side.
@property (nonatomic, assign, readonly, getter=isRightPage) BOOL rightPage;


/// @name Shadow settings

/// Enables shadow for a single page. Only useful in combination with pageCurl.
@property (nonatomic, assign, getter=isShadowEnabled) BOOL shadowEnabled;

/// Set default shadowOpacity. Defaults to 0.7f.
@property (nonatomic, assign) float shadowOpacity;

/// Subclass to change shadow behavior.
- (void)updateShadowAnimated:(BOOL)animated;

/// Set block that is executed within `updateShadow` when `isShadowEnabled = YES`.
@property (nonatomic, copy) void(^updateShadowBlock)(PSPDFPageView *pageView);

@end

// Extensions to handle annotations.
@interface PSPDFPageView (AnnotationViews)

// Associate an annotation with an annotation view
- (void)setAnnotation:(PSPDFAnnotation *)annotation forAnnotationView:(UIView <PSPDFAnnotationViewProtocol> *)annotationView;

// Recall the annotation associated with an annotation view
- (PSPDFAnnotation *)annotationForAnnotationView:(UIView <PSPDFAnnotationViewProtocol> *)annotationView;

/// Currently selected annotations (selected by a tap; showing a menu)
@property (nonatomic, copy) NSArray *selectedAnnotations;

/**
 Hit-testing for a single `PSPDFPageView`. This is usually a relayed event from the parent `PSPDFScrollView`.
 Returns YES if the tap has been handled, else NO.

 All annotations for the current page are loaded and hit-tested (except `PSPDFAnnotationTypeLink`; which has already been handled by now)

 If an annotation has been hit (via `[annotation hitTest:tapPoint]`; convert the tapPoint in PDF coordinate space via convertViewPointToPDFPoint) then we call showMenuForAnnotation.

 If the tap didn't hit an annotation but we are showing a UIMenuController menu; we hide that and set the touch as processed.
 */
- (BOOL)singleTapped:(UITapGestureRecognizer *)recognizer;

/// Handle long press, potentially relay to subviews.
- (BOOL)longPress:(UILongPressGestureRecognizer *)recognizer;

/**
 Add an `annotation` to the current pageView.
 This will either queue a re-render of the PDF, or add a UIView subclass for the matching annotation,
 depending on the annotation type and the value of `isOverlay`.
 This will not change anything on the data model below. Also add an annotation to the document object.

 @note In PSPDFKit, annotations are managed in two ways:

 1) Annotations that are fixed and rendered with the page image.
 Those annotations are `PSPDFHighlightAnnotation`, `PSPDFSquareAnnotation`, `PSPDFInkAnnotation` and more.
 Pretty much all more or less "static" annotations are handled this way.

 2) Then, there are the more dynamic annotations like `PSPDFLinkAnnotation` and `PSPDFNoteAnnotation`.
 Those annotations are not part of the rendered image but are actual subviews in `PSPDFPageView`.
 Those annotations return YES on the isOverlay property.

 Especially with `PSPDFLinkAnnotation`, the resulting views are - depending on the subtype - `PSPDFVideoAnnotationView`, `PSPDFWebAnnotationView` and much more. The classic PDF link is a `PSPDFLinkAnnotationView`.

 This method is called recursively with all annotation types except if they return isOverlay = NO. In case of isOverlay = NO, it will call updateView to re-render the page.
 */
- (void)addAnnotation:(PSPDFAnnotation *)annotation animated:(BOOL)animated;

/// Removes an `annotation` from the view, either by re-rendering the page image or removing a matching UIView-subclass of the annotation was added as an overlay.
/// @note This will not change the data model of the document.
- (BOOL)removeAnnotation:(PSPDFAnnotation *)annotation animated:(BOOL)animated;

/// Select annotation and show the menu for it
- (void)selectAnnotaton:(PSPDFAnnotation *)annotation animated:(BOOL)animated;

@end

@interface PSPDFPageView (SubclassingHooks)

// Internally used to add annotations.
- (void)insertAnnotations:(NSArray *)annotations forPage:(NSUInteger)page inDocument:(PSPDFDocument *)document;

// Returns annotations that we could tap on. (checks against `editableAnnotationTypes`)
// The point will have a variance of a few pixels to improve touch recognition.
- (NSArray *)tappableAnnotationsAtPoint:(CGPoint)viewPoint;

// Same as above, but will be called when we're detecting a long press.
- (NSArray *)tappableAnnotationsForLongPressAtPoint:(CGPoint)viewPoint;

// Used within `tappableAnnotationsAtPoint:` to expand the tap point to make tapping objects easier.
// By default the rect has a size of 10 pixels.
- (CGRect)hitTestRectForPoint:(CGPoint)viewPoint;

// Can be used for manual tap forwarding.
- (BOOL)singleTappedAtViewPoint:(CGPoint)viewPoint;

// Get annotation rect (PDF coordinate space)
- (CGRect)rectForAnnotations:(NSArray *)annotations;

// Render options that are used for the live-page rendering. (not for the cache)
// One way to use this would be to customize what annotations types will be rendered with the pdf.
// See `PSPDFPageRenderer` for a list of options.
- (NSDictionary *)renderOptionsDictWithZoomScale:(CGFloat)zoomScale animated:(BOOL)animated;

// View for the selected annotation.
@property (nonatomic, strong, readonly) PSPDFResizableView *annotationSelectionView;

// Helper to properly place an annotation.
- (void)centerAnnotation:(PSPDFAnnotation *)annotation aroundViewPoint:(CGPoint)viewPoint;

// Load page annotations from the PDF.
- (void)loadPageAnnotationsAnimated:(BOOL)animated blockWhileParsing:(BOOL)blockWhileParsing;

// Computes a scale value suitable for computation of the line width to use during drawing and selection.
- (CGFloat)scaleForPageView;

// If you use child view controller containment, use this as the parent VC.
- (UIViewController *)parentViewController;

// Change notification processing.
- (void)annotationsAddedNotification:(NSNotification *)notification NS_REQUIRES_SUPER;
- (void)annotationsRemovedNotification:(NSNotification *)notification NS_REQUIRES_SUPER;
- (void)annotationChangedNotification:(NSNotification *)notification NS_REQUIRES_SUPER;

@end
