//
//  PSPDFViewControllerDelegate.h
//  PSPDFKit
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFViewController.h"

@protocol PSPDFAnnotationViewProtocol;
@class PSPDFDocument, PSPDFPageInfo, PSPDFImageInfo, PSPDFAnnotation, PSPDFPageView, PSPDFScrollView;

/// Implement this delegate in your UIViewController to get notified of PSPDFViewController events.
@protocol PSPDFViewControllerDelegate <NSObject>

@optional

///--------------------------------------------
/// @name Document Handling
///--------------------------------------------

/// Will be called when an action tries to change the document (For example, a PDF link annotation pointing to another document).
/// Will also be called when the document is changed via using the `document` property.
/// Return NO to block changing the document.
- (BOOL)pdfViewController:(PSPDFViewController *)pdfController shouldChangeDocument:(PSPDFDocument *)document;

/// Will be called after the document has been changed.
/// @note This will also be called for nil and broken documents. use document.isValid to check.
- (void)pdfViewController:(PSPDFViewController *)pdfController didChangeDocument:(PSPDFDocument *)document;

///--------------------------------------------
/// @name Scroll and Page Events
///--------------------------------------------

// If you need more scroll events, subclass PSPDFScrollView and relay your custom scroll events. Don't forget calling super though.

/// Control scrolling to pages. Not implementing this will return YES.
- (BOOL)pdfViewController:(PSPDFViewController *)pdfController shouldScrollToPage:(NSUInteger)page;

/// Controller did show/scrolled to a new page. (at least 51% of it is visible)
- (void)pdfViewController:(PSPDFViewController *)pdfController didShowPageView:(PSPDFPageView *)pageView;

/// Page was fully rendered at zoom level = 1.
- (void)pdfViewController:(PSPDFViewController *)pdfController didRenderPageView:(PSPDFPageView *)pageView;

/// Called after pdf page has been loaded and added to the pagingScrollView.
- (void)pdfViewController:(PSPDFViewController *)pdfController didLoadPageView:(PSPDFPageView *)pageView;

/// Called before a pdf page will be unloaded and removed from the pagingScrollView.
- (void)pdfViewController:(PSPDFViewController *)pdfController willUnloadPageView:(PSPDFPageView *)pageView;

/// Will be called before the page rect has been dragged.
- (void)pdfViewController:(PSPDFViewController *)pdfController didBeginPageDragging:(UIScrollView *)scrollView;

/**
 Will be called after the page rect has been dragged.
 If decelerate is YES, this will be called again after deceleration is complete.

 You can also change the target with changing targetContentOffset.

 This delegate combines the following scrollViewDelegates:
 - scrollViewWillEndDragging / scrollViewDidEndDragging
 - scrollViewDidEndDecelerating

 @note Be careful to not dereference a nil pointer in targetContentOffset.
 To get more delegate options, you can subclass PSPDFScrollView and use all available delegates of UIScrollViewDelegate (don't forget calling super)
 */
- (void)pdfViewController:(PSPDFViewController *)pdfController didEndPageDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;

/// Will be called after the paging animation is complete.
- (void)pdfViewController:(PSPDFViewController *)pdfController didEndPageScrollingAnimation:(UIScrollView *)scrollView;

/// Will be called before the zoom level starts to change.
- (void)pdfViewController:(PSPDFViewController *)pdfController didBeginPageZooming:(UIScrollView *)scrollView;

/// Will be called after the zoom level has been changed, either programmatically or manually.
- (void)pdfViewController:(PSPDFViewController *)pdfController didEndPageZooming:(UIScrollView *)scrollView atScale:(CGFloat)scale;

/// Return a PSPDFDocument for a relative path.
/// If this returns nil, we try to find the PDF ourselves with using the current document's basePath.
- (PSPDFDocument *)pdfViewController:(PSPDFViewController *)pdfController documentForRelativePath:(NSString *)relativePath;

/**
 didTapOnPageView will be called if a user taps on the screen. Taps outside pageView will be reported too (with negative offset)
 Return YES if you want to set this touch as processed; this will disable automatic touch processing like showing/hiding the HUDView or scrolling to the next/previous page.

 @note This will not send events when the controller is in thumbnail view.

 PSPDFPageCoordinates has been replaced by just CGPoint viewPoint.
 You can easily calculate other needed coordinates:
 e.g. to get the pdfPoint:    [pageView convertViewPointToPDFPoint:viewPoint]
                 screenPoint: [pageView convertPoint:tapPosition fromView:pageView]
                 zoomScale:    pageView.scrollView.zoomScale
                 pageInfo:     pageView.pageInfo
 */
- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didTapOnPageView:(PSPDFPageView *)pageView atPoint:(CGPoint)viewPoint;


/**
 Similar to didTapOnPageView; invoked after 0.35 sec of tap-holding. LongPress and tap are mutually exclusive. Return YES if you custom-process that event.

 Default handling is (if available) text selection; showing the magnification-loupe.
 The gestureRecognizer helps you evaluating the state; as this delegate is called on every touch-move.

 Note that there may be unexpected results if you only capture *some* events (thus, return YES on some movements during the recognition state) as e.g. you might not give the system a chance to clean up the magnification loupe. Either consume all or no events for a recognition cycle.
 */
- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didLongPressOnPageView:(PSPDFPageView *)pageView atPoint:(CGPoint)viewPoint gestureRecognizer:(UILongPressGestureRecognizer *)gestureRecognizer;

///--------------------------------------------
/// @name Text Selection
///--------------------------------------------

/// Called when text is about to be selected. Return NO to disable text selection.
- (BOOL)pdfViewController:(PSPDFViewController *)pdfController shouldSelectText:(NSString *)text withGlyphs:(NSArray *)glyphs atRect:(CGRect)rect onPageView:(PSPDFPageView *)pageView;

/// Called after text has been selected.
/// Will also be called when text has been deselected. Deselection sometimes cannot be stopped, so the shouldSelectText: will be skipped.
- (void)pdfViewController:(PSPDFViewController *)pdfController didSelectText:(NSString *)text withGlyphs:(NSArray *)glyphs atRect:(CGRect)rect onPageView:(PSPDFPageView *)pageView;

///--------------------------------------------
/// @name Menu Handling
///--------------------------------------------

/**
 Called before the menu for text selection is displayed.
 All coordinates are in view coordinate space.

 Using PSPDFMenuItem will help with adding custom menu's w/o hacking the responder chain.
 Default returns menuItems if not implemented. Return nil or an empty array to not show the menu.

 Use PSPDFMenuItem's 'identifier' to check and modify the menu items. This string will not be translated (vs the title property)
*/
- (NSArray *)pdfViewController:(PSPDFViewController *)pdfController shouldShowMenuItems:(NSArray *)menuItems atSuggestedTargetRect:(CGRect)rect forSelectedText:(NSString *)selectedText inRect:(CGRect)textRect onPageView:(PSPDFPageView *)pageView;

/// Called before the menu for a selected image is displayed.
- (NSArray *)pdfViewController:(PSPDFViewController *)pdfController shouldShowMenuItems:(NSArray *)menuItems atSuggestedTargetRect:(CGRect)rect forSelectedImage:(PSPDFImageInfo *)selectedImage inRect:(CGRect)textRect onPageView:(PSPDFPageView *)pageView;

/// Called before we're showing the menu for an annotation.
/// If annotation is nil, we show the menu to create *new* annotations (in that case annotationRect will also be nil)
- (NSArray *)pdfViewController:(PSPDFViewController *)pdfController shouldShowMenuItems:(NSArray *)menuItems atSuggestedTargetRect:(CGRect)rect forAnnotations:(NSArray *)annotations inRect:(CGRect)annotationRect onPageView:(PSPDFPageView *)pageView;

///--------------------------------------------
/// @name Annotations
///--------------------------------------------

/// Called before a annotation view is created and added to a page. Defaults to YES if not implemented.
/// @warning This will only be called for annotations that render as an overlay (that return YES for isOverlay)
/// If NO is returned, viewForAnnotation will not be called.
- (BOOL)pdfViewController:(PSPDFViewController *)pdfController shouldDisplayAnnotation:(PSPDFAnnotation *)annotation onPageView:(PSPDFPageView *)pageView;

/**
 Delegate for tapping annotations. Will be called before the more general didTapOnPageView if an annotationView is hit.

 Return YES to override the default action and custom-handle this.
 Default actions might be scroll to target page, open Safari, show a menu, ...

 Some annotations might not have an annotationView attached. (because they are rendered with the page content, for example highlight annotations)

 AnnotationPoint is the point relative to PSPDFAnnotation, in PDF coordinate space.
    viewPoint is the point relative to the PSPDFPageView.
 */
- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didTapOnAnnotation:(PSPDFAnnotation *)annotation annotationPoint:(CGPoint)annotationPoint annotationView:(UIView <PSPDFAnnotationViewProtocol> *)annotationView pageView:(PSPDFPageView *)pageView viewPoint:(CGPoint)viewPoint;

/// Called before an annotation will be selected. (but after didTapOnAnnotation)
- (NSArray *)pdfViewController:(PSPDFViewController *)pdfController shouldSelectAnnotations:(NSArray *)annotations onPageView:(PSPDFPageView *)pageView;

/// Called after an annotation has been selected.
- (void)pdfViewController:(PSPDFViewController *)pdfController didSelectAnnotations:(NSArray *)annotations onPageView:(PSPDFPageView *)pageView;

/// Returns a pre-generated annotationView that can be modified before being added to the view.
/// If no generator for a custom annotation is found, annotationView will be nil (as a replacement to viewForAnnotation)
/// To get the targeted rect use [annotation rectForPageRect:pageView.bounds];
- (UIView <PSPDFAnnotationViewProtocol> *)pdfViewController:(PSPDFViewController *)pdfController annotationView:(UIView <PSPDFAnnotationViewProtocol> *)annotationView forAnnotation:(PSPDFAnnotation *)annotation onPageView:(PSPDFPageView *)pageView;

/// Invoked prior to the presentation of the annotation view: use this to configure actions etc
/// @warning This will only be called for annotations that render as an overlay (that return YES for isOverlay)
/// PSPDFLinkAnnotations are handled differently (they don't have a selected state) - delegate will not be called for those.
- (void)pdfViewController:(PSPDFViewController *)pdfController willShowAnnotationView:(UIView <PSPDFAnnotationViewProtocol> *)annotationView onPageView:(PSPDFPageView *)pageView;

/// Invoked after animation used to present the annotation view
/// @warning This will only be called for annotations that render as an overlay (that return YES for isOverlay)
/// PSPDFLinkAnnotations are handled differently (they don't have a selected state) - delegate will not be called for those.
- (void)pdfViewController:(PSPDFViewController *)pdfController didShowAnnotationView:(UIView <PSPDFAnnotationViewProtocol> *)annotationView onPageView:(PSPDFPageView *)pageView;

///--------------------------------------------
/// @name View Controller Management
///--------------------------------------------

/**
 Called before we show a internal controller (color picker, note editor, ...) modally or in a popover. Allows last minute modifications.

 The embeddedInController is either a UINavigationController, a UIPopoverController or nil. viewController is of type id because controller like UIPrintInteractionController are no subclasses of UIViewController.

 Return NO to process the displaying manually.
 */
- (BOOL)pdfViewController:(PSPDFViewController *)pdfController shouldShowController:(id)viewController embeddedInController:(id)controller options:(NSDictionary *)options animated:(BOOL)animated;

/// Called after the controller has been fully displayed. Isn't called for UIPopoverController's.
- (void)pdfViewController:(PSPDFViewController *)pdfController didShowController:(id)viewController embeddedInController:(id)controller options:(NSDictionary *)options animated:(BOOL)animated;

///--------------------------------------------
/// @name General View State
///--------------------------------------------

/// If you implement your own super-custom toolbar, handle updates for bar buttons. (e.g. with re-setting the items array)
/// One popular example is PSPDFBookmarkBarButtonItem, which needs to change its image after pressing the button.
/// Ignore this if you're letting PSPDFKit manage your toolbar or if you're using a UIToolbar.
/// If you implement this delegate, the default UIToolbar-update-code will not be called.
- (void)pdfViewController:(PSPDFViewController *)pdfController requestsUpdateForBarButtonItem:(UIBarButtonItem *)barButtonItem animated:(BOOL)animated;

/// Will be called when viewMode changes.
- (void)pdfViewController:(PSPDFViewController *)pdfController didChangeViewMode:(PSPDFViewMode)viewMode;

/// Called before the view controller will be dismissed (either by modal dismissal, or popping from the navigation stack).
/// Called before PSPDFKit tries to save any dirty annotation.
/// @note If you use child view containment then the dismissal might not be properly detected.
- (void)pdfViewControllerWillDismiss:(PSPDFViewController *)pdfController;

/// Called after the view controller has been dismissed (either by modal dismissal, or popping from the navigation stack).
/// @note If you use child view containment then the dismissal might not be properly detected.
- (void)pdfViewControllerDidDismiss:(PSPDFViewController *)pdfController;

///--------------------------------------------
/// @name HUD
///--------------------------------------------

/// Return NO to stop the HUD change event.
- (BOOL)pdfViewController:(PSPDFViewController *)pdfController shouldShowHUD:(BOOL)animated;

/// HUD was displayed (called after the animation finishes)
- (void)pdfViewController:(PSPDFViewController *)pdfController didShowHUD:(BOOL)animated;

/// Return NO to stop the HUD change event.
- (BOOL)pdfViewController:(PSPDFViewController *)pdfController shouldHideHUD:(BOOL)animated;

/// HUD was hidden (called after the animation finishes)
- (void)pdfViewController:(PSPDFViewController *)pdfController didHideHUD:(BOOL)animated;

@end
