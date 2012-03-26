//
//  PSPDFViewController.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PSPDFBaseViewController.h"
#import "PSPDFKitGlobal.h"

@protocol PSPDFViewControllerDelegate;
@class PSPDFDocument, PSPDFScrollView, PSPDFScrobbleBar, PSPDFPageView, PSPDFHUDView, PSPDFGridView, PSPDFPageViewController;

/// current active view mode.
enum {
    PSPDFViewModeDocument,
    PSPDFViewModeThumbnails
}typedef PSPDFViewMode;

/// active page mode.
enum {
    PSPDFPageModeSingle,   // Default on iPhone.
    PSPDFPageModeDouble,
    PSPDFPageModeAutomatic // single in portrait, double in landscape if the document's height > width. Default on iPad.
}typedef PSPDFPageMode;

/// active scrolling direction.
enum {
    PSPDFScrollingHorizontal, // default
    PSPDFScrollingVertical
}typedef PSPDFScrolling;

/// status bar style. (old status will be restored regardless of the style chosen)
enum {
    PSPDFStatusBarInherit,            /// don't change status bar style, but show/hide statusbar on HUD events
    PSPDFStatusBarSmartBlack,         /// use UIStatusBarStyleBlackOpaque on iPad, UIStatusBarStyleBlackTranslucent on iPhone.
    PSPDFStatusBarBlackOpaque,        /// Opaque Black everywhere
    PSPDFStatusBarDefaultWhite,       /// Switch to default (white) statusbar
    PSPDFStatusBarDisable,            /// never show status bar
    PSPDFStatusBarIgnore = 0x100      /// causes this class to ignore the statusbar entirely.
}typedef PSPDFStatusBarStyleSetting;

enum {
    PSPDFLinkActionNone,         /// Link actions are ignored..
    PSPDFLinkActionAlertView,    /// Link actions open an AlertView.
    PSPDFLinkActionOpenSafari,   /// Link actions directly open Safari.
    PSPDFLinkActionInlineBrowser /// Link actions open in an inline browser.
}typedef PSPDFLinkActionSetting;

/// The main view controller to display pdfs. Can be displayed in fullscreen or embedded.
/// When embedded, be sure to correctly relay the viewController calls of viewWillAppear/etc. (or use iOS5 view controller containment)
@interface PSPDFViewController : PSPDFBaseViewController <UIScrollViewDelegate, UIPopoverControllerDelegate>

/// @name Initialization

/// Initialize with a document.
- (id)initWithDocument:(PSPDFDocument *)document;


/// @name Page Scrolling and Zooming

/// Control currently displayed page. Page starts at 0.
- (void)scrollToPage:(NSUInteger)page animated:(BOOL)animated;

/// Control currently displayed page, optionally show/hide the HUD. Page starts at 0.
- (void)scrollToPage:(NSUInteger)page animated:(BOOL)animated hideHUD:(BOOL)hideHUD;

/// Scroll to next page.
- (BOOL)scrollToNextPageAnimated:(BOOL)animated;

/// Scroll to previous page.
- (BOOL)scrollToPreviousPageAnimated:(BOOL)animated;

/// Scrolls to a specific rect on the current page. No effect if zoom is at 1.0.
- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated;

/// Zooms to a specific rect, optionally animated.
- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated;


/// @name Reloading Content

/// Reload scrollview. Call if you manually change the view width/height or some property inside PSPDFDocument. Usually not needed.
- (void)reloadData;

/// Reload scrollview, scroll to specified page.
- (void)reloadDataAndScrollToPage:(NSUInteger)page;


/// @name Thumbnail View

/// View mode: PSPDFViewModeDocument or PSPDFViewModeThumbnails.
@property(nonatomic, assign) PSPDFViewMode viewMode;
- (void)setViewMode:(PSPDFViewMode)viewMode animated:(BOOL)animated;

/// Change thumbnail size. Default is 170x220.
@property(nonatomic, assign) CGSize thumbnailSize;

/// Thumbnails on iPhone are smaller - you may change the reduction factor. Defaults to 0.5.
@property(nonatomic, assign) CGFloat iPhoneThumbnailSizeReductionFactor;


/// @name Class Accessors

/// Return the pageView for a given page. Returns nil if page is not initalized (e.g. page is not visible.)
/// Usually, using the delegates is a better idea to get the current page.
- (PSPDFPageView *)pageViewForPage:(NSUInteger)page;

/// Saves the popoverController if currently displayed.
@property(nonatomic, strong) UIPopoverController *popoverController;

/// Paging scroll view. (hosts scollviews for pdf)
@property(nonatomic, strong, readonly) UIScrollView *pagingScrollView;


/// @name Helpers

/// Depending on pageMode, this returns true if two pages are displayed.
- (BOOL)isDualPageMode;
- (BOOL)isDualPageModeForOrientation:(UIInterfaceOrientation)interfaceOrientation;

/// Checks if the current page is on the right side, when in double page mode. Page starts at 0.
- (BOOL)isRightPageInDoublePageMode:(NSUInteger)page;

/// Show a modal view controller with automatically added close button on the left side.
- (void)presentModalViewController:(UIViewController *)controller withCloseButton:(BOOL)closeButton animated:(BOOL)animated;

/// Return array of currently visible page numbers.
- (NSArray *)visiblePageNumbers;

/// YES if we are at the last page
- (BOOL)isLastPage;

/// YES if we are at the first page
- (BOOL)isFirstPage;


/// @name HUD Controls

/// View that is displayed as HUD. Make a KVO on viewMode if you build a different HUD for thumbnails view.
/// HUD is created in viewDidLoad. Subclass or use KVO to add your custom views when this changes.
@property(nonatomic, strong, readonly) PSPDFHUDView *hudView;

/// Show or hide HUD controls, titlebar, status bar. (iPhone only)
@property(nonatomic, assign, getter=isHUDVisible) BOOL HUDVisible;

/// Animated show or hide HUD controls, titlebar, status bar. (status bar fade is iPhone only)
- (void)setHUDVisible:(BOOL)show animated:(BOOL)animated;

/// Enables bottom scrobble bar [if HUD is displayed]. will be hidden automatically when in thumbnail mode. Defaults to YES. Animatable.
/// There's some more logic involved, e.g. is the default white statusbar not hidden on a HUD change.
@property(nonatomic, assign, getter=isScrobbleBarEnabled) BOOL scrobbleBarEnabled;

/// Enables/Disables the bottom document site position overlay. Defaults to YES. Animatable. Will be added to the hudView.
@property(nonatomic, assign, getter=isPositionViewEnabled) BOOL positionViewEnabled;

/// Enables default header toolbar. Only displayed if inside UINavigationController. Defaults to YES. Set before loading view.
@property(nonatomic, assign, getter=isToolbarEnabled) BOOL toolbarEnabled;

/// Controls if the thumbnail view toggle is displayed or not. Defaults to YES.
@property(nonatomic, assign, getter=isViewModeControlVisible) BOOL viewModeControlVisible;


/// @name Properties

/// Register delegate to capture events, change properties.
@property(nonatomic, ps_weak) IBOutlet id<PSPDFViewControllerDelegate> delegate;

/// Document that will be displayed.
@property(nonatomic, strong) PSPDFDocument *document;

/// Current page displayed, not landscape corrected. To change page, use scrollToPage.
/// e.g. if you have 50 pages, you get 25/26 "dual pages" when in double page mode. KVO observable.
@property(nonatomic, assign, readonly) NSUInteger page;

/// Current page displayed, landscape corrected. To change page, use scrollToPage.
/// This represents the pages in the pdf document, starting at 0. KVO observable.
@property(nonatomic, assign, readonly) NSUInteger realPage;

/// Pages that are kept in pageScrollView after last visible page. Defaults to 0. Don't set too high, needs lots of memory!
@property(nonatomic, assign) NSUInteger preloadedPagesPerSide;

/// Enable/disable scrolling. can be used in special cases where scrolling is turned of (temporarily). Defaults to YES.
@property(nonatomic, assign, getter=isScrollingEnabled) BOOL scrollingEnabled;

/// Tap on begin/end of page scrolls to previous/next page. Defaults to YES.
@property(nonatomic, assign, getter=isScrollOnTapPageEndEnabled) BOOL scrollOnTapPageEndEnabled;

/// Set the default link action for pressing on PSPDFLinkAnnotations. Default is PSPDFLinkActionAlertView.
/// Note: if modal is set in the link, this property has no effect.
@property(nonatomic, assign) PSPDFLinkActionSetting linkAction;

/// Show a print icon when running on iOS 4.2 or later. Defaults to NO.
/// Note: if the document does not allow printing (i.e. self.document.allowsPrinting == NO), this property has no effect.
@property(nonatomic, assign, getter=isPrintEnabled) BOOL printEnabled;

/// Show the open in icon to transfer the pdf into any registered app. Defaults to NO.
/// Note: This is currently only supported for deault single-URL documents.
/// You have to load a valid document on view creation for this to work.
@property(nonatomic, assign, getter=isOpenInEnabled) BOOL openInEnabled;

/// @name Appearance Properties

/// Set a PageMode defined in the enum. (Single/Double Pages)
/// Reloads the view, unless it is set while rotation is active.
/// Thus, one can customize the rotation behavior with animations when set within willAnimate*.
@property(nonatomic, assign) PSPDFPageMode pageMode;

/// Change scrolling direction. defaults to horizontal scrolling. (PSPDFScrollingHorizontal)
@property(nonatomic, assign) PSPDFScrolling pageScrolling;

/// Shows first document page alone. Not relevant in PSPDFPageModeSinge. Defaults to NO.
@property(nonatomic, assign, getter=isDoublePageModeOnFirstPage) BOOL doublePageModeOnFirstPage;

/// Allow zooming of small documents to screen width/height. Defaults to YES.
@property(nonatomic, assign, getter=isZoomingSmallDocumentsEnabled) BOOL zoomingSmallDocumentsEnabled;

/// Enables iBooks-like page curl feature. Works only with iOS5 or later. Falls back to default scrolling on iOS4. Since PSPDFKit 1.9.
/// Note: doesn't work well with non-equal sized documents. Use scrolling if you have such complex documents.
@property(nonatomic, assign, getter=isPageCurlEnabled) BOOL pageCurlEnabled;

/// If true, pages are fit to screen width, not to either height or width (which one is larger - usually height.) Defaults to NO.
/// iPhone switches to yes in willRotateToInterfaceOrientation - reset back to no if you don't want this.
/// fitWidth is currently not supported for vertical scrolling. This is a know limitation.
@property(nonatomic, assign, getter=isFittingWidth) BOOL fitWidth;

/// Maximum zoom scale for the scrollview. Defaults to 5.0. Set before creating the view.
@property(nonatomic, assign) float maximumZoomScale;

/// Page padding width between single/double pages. Defaults to 20.
@property(nonatomic, assign) CGFloat pagePadding;

/// Enable/disable page shadow.
@property(nonatomic, assign, getter=isShadowEnabled) BOOL shadowEnabled;

/// Status bar styling. Defaults to PSPDFStatusBarSmartBlack.
/// If controller is used embedded (in a non-fullscreen way), this setting has no effect.
@property(nonatomic, assign) PSPDFStatusBarStyleSetting statusBarStyleSetting;

/// If not set, we'll use scrollViewTexturedBackgroundColor as default.
@property(nonatomic, strong) UIColor *backgroundColor;

/// Set global toolbar tint color. Overrides defaults. Default is nil (depends on statusBarStyleSetting)
@property(nonatomic, strong) UIColor *tintColor;

/// Annotations are faded in. Set global duration for this fade here. Defaults to 0.25f.
@property(nonatomic, assign) CGFloat annotationAnimationDuration;


/// @name Subclassing Helpers

/// Use this to use specific subclass names instead of the default PSPDF* classes.
/// e.g. add an entry of "PSPDFScrollView" / "MyCustomPSPDFScrollViewSubclass" as key/value pair to use the custom subclass.
/// This replaces the previous properties "scrollViewClass" and "scrobbleBarClass" and adds support for many used classes.
@property(nonatomic, strong) NSDictionary *overrideClassNames;

/// returns the topmost active viewcontroller. override if you have a custom setup of viewControllers
- (UIViewController *)masterViewController;

/// override if you're changing the toolbar to your own.
/// Note: The toolbar is only displayed, if PSPDFViewController is inside a UINavigationController.
- (void)createToolbar;

- (UIBarButtonItem *)toolbarBackButton; // defaults to "Documents"

- (NSArray *)additionalLeftToolbarButtons; // not used when not modal

- (void)updateToolbars;

/// Setup the grid view. Call [super gridView] and modify it for your needs
- (PSPDFGridView *)gridView;

/// Can be subclassed to update grid spacing.
- (void)updateGridForOrientation;

// called from scrollviews
- (void)showControls;
- (void)hideControls;
- (void)toggleControls;
- (NSUInteger)landscapePage:(NSUInteger)aPage;

/// Manually return the desired UI status bar style (default is evaluated via app status bar style)
- (UIStatusBarStyle)statusBarStyle;

/// Checks if viewControllerClass is currently visible and dismisses the popover if so.
/// Returns YES if the popover has been dismissed, NO otherwise.
/// Note: if viewControllerClass is nil, the popover will always be dismissed, as long as it exists.
/// This also supports UIDocumentInteractionController and UIPrintInteractionController.
- (BOOL)checkAndDismissPopoverForViewControllerClass:(Class)viewControllerClass animated:(BOOL)animated;

@end
