//
//  PSPDFViewController.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "PSPDFBaseViewController.h"
#import "PSPDFKitGlobal.h"
#import "PSPDFTextSearch.h"
#import "PSPDFPasswordView.h"

@protocol PSPDFViewControllerDelegate;
@class PSPDFDocument, PSPDFScrollView, PSPDFScrobbleBar, PSPDFPageView, PSPDFHUDView, PSPDFGridView, PSPDFPageViewController, PSPDFSearchResult, PSPDFViewState, PSPDFBarButtonItem;

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
@interface PSPDFViewController : PSPDFBaseViewController <PSPDFPasswordViewDelegate, PSPDFSearchDelegate, UIScrollViewDelegate, UIPopoverControllerDelegate, MFMailComposeViewControllerDelegate>

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
/// Note that rect are *screen* coordinates. If you want to use pdf coordinates, convert them via:
/// PSPDFConvertPDFRectToViewRect() or -convertPDFPointToViewPoint of PSPDFPageView.
- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated;

/// Zooms to a specific rect, optionally animated.
- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated;

/// Save view state (page/zoom/position)
- (PSPDFViewState *)documentViewState;

/// Restore view state (page/zoom/position)
/// Note: restoring a certain zoomscale/rect is currently not animatable.
- (void)restoreDocumentViewState:(PSPDFViewState *)viewState animated:(BOOL)animated;

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
/// hudView is created in viewDidLoad. Subclass or use KVO to add your custom views when this changes.
@property(nonatomic, strong, readonly) PSPDFHUDView *hudView;

/// Content view. Use this if you want to add any always-visible UI elements.
/// Created in viewDidLoad. contentView is behind hudView but always visible.
/// ContentView does NOT overlay the navigationBar/statusBar, even if that one is transparent.
@property(nonatomic, strong, readonly) PSPDFHUDView *contentView;

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


/// @name Properties

/// Register delegate to capture events, change properties.
@property(nonatomic, ps_weak) IBOutlet id<PSPDFViewControllerDelegate> delegate;

/// Document that will be displayed.
/// Note: has simple support to also accepts an NSString, the bundle path then will be used.
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

/// Allows text selection. Defaults to YES.
/// Note: This implies that the PDF file actually contains text glypths.
/// Sometimes text is represented via embedded images or vectors, in that case we can't select it.
@property(nonatomic, assign, getter=isTextSelectionEnabled) BOOL textSelectionEnabled;

/// Set the default link action for pressing on PSPDFLinkAnnotations. Default is PSPDFLinkActionInlineBrowser.
/// Note: if modal is set in the link, this property has no effect.
@property(nonatomic, assign) PSPDFLinkActionSetting linkAction;


/// @name Toolbar button items

/*
 Note: This more dynamic toolbar building system replaces the properties
 searchEnabled, outlineEnabled, printEnabled, openInEnabled.

 You can now build your own toolbar with much less hassle.
 For example, to add those features under the "action" icon as a menu, use this:
 self.additionalRightBarButtonItems = [NSArray arrayWithObjects:self.printButtonItem, self.openInButtonItem, self.emailButtonItem, nil];
 
 You can change the button with using the subclassing system: (e.g. if you are looking for toolbarBackButton)
 overrideClassNames = [NSDictionary dictionaryWithObject:[MyCustomButtonSubclass Class]
                                                  forKey:[PSPDFCloseBarButtonItem class]]
 
*/

/// Default button in leftToolbarButtonItems if view is presented modally.
@property(nonatomic, strong, readonly) PSPDFBarButtonItem *closeButtonItem;

// Default button items included by default in rightToolbarButtonItems

/// Show Outline/Table Of Contents (if available in the PDF)
@property(nonatomic, strong, readonly) PSPDFBarButtonItem *outlineButtonItem;
/// Enable Search.
@property(nonatomic, strong, readonly) PSPDFBarButtonItem *searchButtonItem;
/// Document/Thumbnail toggle.
@property(nonatomic, strong, readonly) PSPDFBarButtonItem *viewModeButtonItem;


// Default button items not included by default

/// Print feature. Only displayed if document is allowed to be printed.
@property(nonatomic, strong, readonly) PSPDFBarButtonItem *printButtonItem;

/// Shows the Open In... iOS dialog. Only works with single-file pdf's.
@property(nonatomic, strong, readonly) PSPDFBarButtonItem *openInButtonItem;

/// Send current pdf via email. Only works with single-file/data pdf's.
@property(nonatomic, strong, readonly) PSPDFBarButtonItem *emailButtonItem;

/// Bar button items displayed at the left of the toolbar
/// Must be UIBarButtonItem or PSPDFBarButtonItem instances
/// Defaults to (closeButtonItem) if view is presented modally.
@property(nonatomic, strong) NSArray *leftBarButtonItems;

/// Bar button items displayed at the right of the toolbar
/// Must be UIBarButtonItem or PSPDFBarButtonItem instances
/// Defaults to [NSArray arrayWithObjects:self.searchButtonItem, self.outlineButtonItem, self.viewModeButtonItem, nil];
@property(nonatomic, strong) NSArray *rightBarButtonItems;

/// Displayed at the left of the rightBarButtonItems inside an action sheet
/// Must be PSPDFBarButtonItem instances
/// If [additionalRightToolbarButtonItems count] == 1 then no action sheet is displayed
@property(nonatomic, strong) NSArray *additionalRightBarButtonItems; // defaults to nil

/// Add your custom UIBarButtonItems so that they won't be automatically enabed/disabed.
/// Note: You really want to add yout custom close/back button there, else the user might get stuck!
@property(nonatomic, strong) NSArray *barButtonItemsAlwaysEnabled;

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

/// Enables iBooks-like page curl feature. Works only with iOS5 or later. Falls back to default scrolling on iOS4. Defaults to NO.
/// Note: doesn't work well with non-equal sized documents. Use scrolling if you have such complex documents.
/// Note: You might wanna disable this on the iPad1, because this is more memory hungry than classic scrolling.
/// You can use pageCurlEnabled = !PSPSDIsCrappyDevice(); which will return YES for older devices only.
/// If you change the property dynamically depending on the screen orientation, don't use willRotateToInterfaceOrientation but didRotateFromInterfaceOrientation, else the controller will get in an invalid state.
@property(nonatomic, assign, getter=isPageCurlEnabled) BOOL pageCurlEnabled;

/// For Left-To-Right documents, this sets the pagecurl to go backwards. Defaults to NO.
/// Note: doesn't re-order document pages. There's currently no real LTR support in PSPDFKit.
@property(nonatomic, assign, getter=isPageCurlDirectionLeftToRight) BOOL pageCurlDirectionLeftToRight;

/// If true, pages are fit to screen width, not to either height or width (which one is larger - usually height.) Defaults to NO.
/// iPhone switches to yes in willRotateToInterfaceOrientation - reset back to no if you don't want this.
/// fitWidth is currently not supported for vertical scrolling. This is a know limitation.
@property(nonatomic, assign, getter=isFittingWidth) BOOL fitWidth;

/// PageCurl mode only: clips the page to its boundaries, not showing a pageCurl on empty background. Defaults to YES.
/// Usually you want this, unless your document is variable sized.
@property(nonatomic, assign) BOOL clipToPageBoundaries;

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

/// The navigationBar is animated. Check this to get the proper value, even if navigationBar.navigationBarHidden is not yet set (but will be in the animation block)
@property(nonatomic, assign, getter=isNavigationBarHidden, readonly) BOOL navigationBarHidden;

/// Annotations are faded in. Set global duration for this fade here. Defaults to 0.25f.
@property(nonatomic, assign) CGFloat annotationAnimationDuration;

/// Defaults to YES. Set to NO for faster page-scrolling, but may flash white even if there are thumbnails supplied.
@property(nonatomic, assign) BOOL loadThumbnailsOnMainThread;


/// @name Subclassing Helpers

/// Use this to use specific subclass names instead of the default PSPDF* classes.
/// e.g. add an entry of [PSPDFScrollView class] / [MyCustomPSPDFScrollViewSubclass class] as key/value pair to use the custom subclass.
@property(nonatomic, strong) NSDictionary *overrideClassNames;

/// If embedded via iOS5 viewController containment, set this to true to allow this controller
/// to access the parent navigationBar to add custom buttons.
/// Has no effect if toolbarEnabled is false or there's no parentViewController.
@property(nonatomic, assign) BOOL useParentNavigationBar;

/// returns the topmost active viewcontroller. override if you have a custom setup of viewControllers
- (UIViewController *)masterViewController;

/// override if you're changing the toolbar to your own.
/// Note: The toolbar is only displayed, if PSPDFViewController is inside a UINavigationController.
- (void)createToolbar;

- (void)updateToolbars;

/// Return rect of the content view area excluding translucent toolbar/statusbar.
- (CGRect)contentRect;

/// UIBarButtonItem doesn't support calculation of it's width, so we have to approximate.
/// This allows you to change the minimum width if the heuristics fail.
/// Note: Set this in your subclass within updateToolbars, then call [super updateToolbars].
@property(nonatomic, assign) CGFloat minLeftToolbarWidth;

/// Allows to change the minimum width of the right toolbar. Set this within updateToolbars.
@property(nonatomic, assign) CGFloat minRightToolbarWidth;

/// Setup the grid view. Call [super gridView] and modify it to your needs.
- (UIScrollView *)gridView;

/// Can be subclassed to update grid spacing.
- (void)updateGridForOrientation;

// called from scrollviews
- (void)showControls;
- (void)hideControls;
- (void)toggleControls;
- (NSUInteger)landscapePage:(NSUInteger)aPage;

/// Manually return the desired UI status bar style (default is evaluated via app status bar style)
- (UIStatusBarStyle)statusBarStyle;

// Clears the highlight views. Can be subclassed.
- (void)clearHighlightedSearchResults;

// Adds the highlight views. Can be subclassed.
- (void)addHighlightSearchResults:(NSArray *)searchResults;

// Animates a certain search highlight. Can be subclassed.
- (void)animateSearchHighlight:(PSPDFSearchResult *)searchResult;

@end

// Allows better guessing of the status bar style.
@protocol PSPDFStatusBarStyleHint <NSObject>
- (UIStatusBarStyle)preferredStatusBarStyle;
@end
