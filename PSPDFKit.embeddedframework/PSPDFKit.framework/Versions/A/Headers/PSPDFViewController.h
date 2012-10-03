//
//  PSPDFViewController.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "PSPDFKitGlobal.h"
#import "PSPDFAnnotation.h"
#import "PSPDFBaseViewController.h"
#import "PSPDFTextSearch.h"
#import "PSPDFPasswordView.h"
#import "PSPDFOutlineViewController.h"
#import "PSPDFTransitionProtocol.h"
#import "PSPDFWebViewController.h"
#import "PSTCollectionView.h"

@protocol PSPDFViewControllerDelegate;
@class PSPDFDocument, PSPDFScrollView, PSPDFScrobbleBar, PSPDFPageView, PSPDFHUDView, PSPDFGridView, PSPDFPageViewController, PSPDFSearchResult, PSPDFViewState, PSPDFBarButtonItem;

/// Page Transition. Can be scrolling or something more fancy.
typedef NS_ENUM(NSInteger, PSPDFPageTransition) {
    PSPDFPageScrollPerPageTransition = 0,      // default mode for iOS4. Has one scrollView per page.
    PSPDFPageScrollContinuousTransition = 1,   // Similar to UIWebView. Ignores PSPDFPageModeDouble.
    PSPDFPageCurlTransition = 2                // replaces pageCurlEnabled. iOS5+ feature.
};

/// Current active view mode.
typedef NS_ENUM(NSInteger, PSPDFViewMode) {
    PSPDFViewModeDocument,
    PSPDFViewModeThumbnails
};

/// Active page mode.
typedef NS_ENUM(NSInteger, PSPDFPageMode) {
    PSPDFPageModeSingle,   // Default on iPhone.
    PSPDFPageModeDouble,
    PSPDFPageModeAutomatic // single in portrait, double in landscape if the document's height > width. Default on iPad.
};

/// Active scrolling direction. Only relevant for scrolling page transitions.
typedef NS_ENUM(NSInteger, PSPDFScrollDirection) {
    PSPDFScrollDirectionHorizontal, // default
    PSPDFScrollDirectionVertical
};

/// Status bar style. (old status will be restored regardless of the style chosen)
typedef NS_ENUM(NSInteger, PSPDFStatusBarStyleSetting) {
    PSPDFStatusBarInherit,            /// Don't change status bar style, but show/hide statusbar on HUD events
    PSPDFStatusBarSmartBlack,         /// Use UIStatusBarStyleBlackOpaque on iPad, UIStatusBarStyleBlackTranslucent on iPhone.
    PSPDFStatusBarBlackOpaque,        /// Opaque Black everywhere
    PSPDFStatusBarDefault,            /// Default statusbar (white on iPhone/black on iPad)
    PSPDFStatusBarDisable,            /// Never show status bar
    PSPDFStatusBarIgnore = 0x100      /// Causes this class to ignore the statusbar entirely.
};

typedef NS_ENUM(NSInteger, PSPDFHUDViewMode) {
    PSPDFHUDViewAlways,               /// Always show the HUD.
    PSPDFHUDViewAutomatic,            /// Show HUD on touch and first/last page.
    PSPDFHUDViewNever                 /// Never show the HUD.
};

/// Default action for PDF link annotations.
typedef NS_ENUM(NSInteger, PSPDFLinkAction) {
    PSPDFLinkActionNone,         /// Link actions are ignored.
    PSPDFLinkActionAlertView,    /// Link actions open an UIAlertView.
    PSPDFLinkActionOpenSafari,   /// Link actions directly open Safari.
    PSPDFLinkActionInlineBrowser /// Link actions open in an inline browser.
};

// Customize how a single page should be displayed.
typedef NS_ENUM(NSInteger, PSPDFPageRenderingMode) {
    PSPDFPageRenderingModeThumbailThenFullPage, // load cached page async
    PSPDFPageRenderingModeFullPage,             // load cached page async, no upscaled thumb
    PSPDFPageRenderingModeFullPageBlocking,     // load cached page directly
    PSPDFPageRenderingModeThumbnailThenRender,  // don't use cached page but thumb
    PSPDFPageRenderingModeRender                // don't use cached page nor thumb
};

/**
 The main view controller to display PDFs. Can be displayed in fullscreen or embedded. Everything in PSPDFKit is based around PSPDFViewController. This is the class you want to override and customize.
 
 Make sure to correctly use viewController containment when adding this as a child view controller. If you override this class, ensure all UIViewController methods you're using do call super. (e.g. viewWillAppear). 
*/
@interface PSPDFViewController : PSPDFBaseViewController <PSPDFOutlineViewControllerDelegate,PSPDFPasswordViewDelegate, PSPDFSearchDelegate, PSPDFWebViewControllerDelegate, PSUICollectionViewDataSource, PSUICollectionViewDelegate, UIPopoverControllerDelegate, MFMailComposeViewControllerDelegate>

/// @name Initialization

/// Initialize with a document.
/// Document can be nil. In this case, just the background is displayed and the HUD stays visible.
/// Also supports creation via initWithCoder to allow usage in Storyboards.
- (id)initWithDocument:(PSPDFDocument *)document;


/// @name Page Scrolling and Zooming

/// Current page displayed, not landscape corrected. To change page, use scrollToPage.
/// e.g. if you have 50 pages, you get 25/26 "double pages" when in double page mode.
@property (nonatomic, assign, readonly) NSUInteger page;

/// Current page displayed, landscape corrected. To change page, use scrollToPage.
/// This represents the pages in the PDF document, starting at 0.
@property (nonatomic, assign, readonly) NSUInteger realPage;

/// Control currently displayed page. Page starts at 0.
- (BOOL)setPage:(NSUInteger)page animated:(BOOL)animated;

/// Scroll to next page. Will potentiall advance two pages in dualPage mode.
- (BOOL)scrollToNextPageAnimated:(BOOL)animated;

/// Scroll to previous page. Will potentiall decrease two pages in dualPage mode.
- (BOOL)scrollToPreviousPageAnimated:(BOOL)animated;

/// Scrolls to a specific rect on the current page. No effect if zoom is at 1.0.
/// Note that rect are *screen* coordinates. If you want to use PDF coordinates, convert them via:
/// PSPDFConvertPDFRectToViewRect() or -convertPDFPointToViewPoint of PSPDFPageView.
- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated;

/// Zooms to a specific rect, optionally animated.
- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated;

/// Saves the view state into a serializable object. (page/zoom/position/HUD)
@property (nonatomic, strong) PSPDFViewState *viewState;
- (void)setViewState:(PSPDFViewState *)viewState animated:(BOOL)animated;

/// Recreates the content view hierarchy. Usually automatically invoked if you change certain properties (like document, pageTransition).
- (IBAction)reloadData;

/// Opens the PSPDFSearchViewController with the searchString.
- (void)searchForString:(NSString *)searchText animated:(BOOL)animated;


/// @name Page Rendering

/*
 Changing those settings will affect PDF rendering.
 Currently the PDF cache still does not yet honor those settings.
 You need to manually call [self reloadData] after changing those properites.
*/

/// Change the PDF content opacity. Defaults to 1 (100%)
@property (nonatomic, assign) CGFloat renderContentOpacity;

/// Multiplies a color to the PDF background color.
/// Does not change anything if the pge color is black.
/// This is useful to ease reading on mostly white documents. Defaults to [UIColor whiteColor]. (white)
/// Can not be set to nil.
@property (nonatomic, strong) UIColor *renderBackgroundColor;

/// Inverts PDF rendering. Useful for people that need additional accessibility.
@property (nonatomic, assign) BOOL renderInvertEnabled;

/// Set what annotations should be rendered. Defaults to PSPDFAnnotationTypeAll.
/// Set this to PSPDFAnnotationTypeLink | PSPDFAnnotationTypeHighlight for PSPDFKit v1 rendering style. 
@property (nonatomic, assign) PSPDFAnnotationType renderAnnotationTypes;


/// @name HUD Controls

/// View that is displayed as HUD. Make a KVO on viewMode if you build a different HUD for thumbnails view.
/// HUDView is created in viewDidLoad. Subclass or use KVO to add your custom views when this changes.
@property (nonatomic, strong, readonly) PSPDFHUDView *HUDView;

/// Manages the show/hide mode of the HUD view. Defaults to PSPDFHUDViewAutomatic.
/// Note: this does not affect manually setting HUDVisible.
/// If your statusbar setting is set to PSPDFStatusBarDefault; the HUD will be non-opaque and thus stay visible always.
/// HUD will not change when changing this mode. Use setHUDVisible:animated:.
@property (nonatomic, assign) PSPDFHUDViewMode HUDViewMode;

/// Show or hide HUD controls, titlebar, status bar. (iPhone only)
@property (nonatomic, assign, getter=isHUDVisible) BOOL HUDVisible;
- (BOOL)setHUDVisible:(BOOL)show animated:(BOOL)animated;

/// Show the HUD. Respects HUDViewMode.
- (BOOL)showControls;
/// Hide the HUD. Respects HUDViewMode.
- (BOOL)hideControls;
/// Hide the HUD (respects HUDViewMode) and additional elements like page selection.
- (BOOL)hideControlsAndPageElements;
/// Toggles the HUD. Respects HUDViewMode.
- (BOOL)toggleControls;

/// Enables default header toolbar. Only displayed if inside UINavigationController. Defaults to YES. Set before loading view.
@property (nonatomic, assign, getter=isToolbarEnabled) BOOL toolbarEnabled;

/// Enables bottom scrobble bar [if HUD is displayed]. will be hidden automatically when in thumbnail mode. Defaults to YES. Animatable.
/// There's some more logic involved, e.g. is the default white statusbar not hidden on a HUD change.
@property (nonatomic, assign, getter=isScrobbleBarEnabled) BOOL scrobbleBarEnabled;

/// Enables/Disables the bottom document site position overlay. Defaults to YES. Animatable. Will be added to the hudView.
@property (nonatomic, assign, getter=isPositionViewEnabled) BOOL positionViewEnabled;

/// Enable/disable the top document label overlay. Defaults to YES on iPhone and NO on iPad.
/// (On iPad, there's enough space to show the title in the navigationBar)
@property (nonatomic, assign, getter=isDocumentLabelEnabled) BOOL documentLabelEnabled;

/// If YES, shows a decent UIActivityIndicator on the top right while page is rendering. Defaults to YES.
@property (nonatomic, assign, getter=isRenderAnimationEnabled) BOOL renderAnimationEnabled;

/// Content view. Use this if you want to add any always-visible UI elements.
/// Created in viewDidLoad. contentView is behind hudView but always visible.
/// ContentView does NOT overlay the navigationBar/statusBar, even if that one is transparent.
@property (nonatomic, strong, readonly) PSPDFHUDView *contentView;


/// @name Properties

/// Register delegate to capture events, change properties.
@property (nonatomic, ps_weak) IBOutlet id<PSPDFViewControllerDelegate> delegate;

/// Document that will be displayed.
/// Note: has simple support to also accepts an NSString, the bundle path then will be used.
@property (nonatomic, strong) PSPDFDocument *document;

/**
    Set margin for document pages. Defaults to UIEdgeInsetsZero.
    Margin is extra space for your (always visible) UI elements.
    Content will be moved accordingly.
    Area outside margin does not receive touch events, or is shown while zooming.
 */
@property (nonatomic, assign) UIEdgeInsets margin;

/**
    Padding for document pages. Defaults to CGSizeZero.
    Padding is space that is displayed around the document.
    (In fact, the minimum zoom is adapted; thus you can only modify width/height here)
    When changing padding; the touch area is still fully active.
 */
@property (nonatomic, assign) CGSize padding;

/**
    This manages how the PDF image cache (thumbnail, full page) is used.

    PSPDFPageRenderingModeFullPageBlocking is a great option for PSPDFPageCurlTransition.
    Note: PSPDFPageRenderingModeFullPageBlocking will disable certain page scroll animations.

    Defaults to PSPDFPageRenderingModeThumbnailsThenFullPage.
 */
@property (nonatomic, assign) PSPDFPageRenderingMode renderingMode;

/// If set to YES, tries to find the text blocks on the page and zooms into the tapped block.
/// NO will perform a generic zoom into the tap area. Defauts to YES.
@property (nonatomic, assign, getter=isSmartZoomEnabled) BOOL smartZoomEnabled;

/// Enable/disable scrolling. can be used in special cases where scrolling is turned of (temporarily). Defaults to YES.
@property (nonatomic, assign, getter=isScrollingEnabled) BOOL scrollingEnabled;

/// Locks the view and the HUD. Disables scrolling, zooming and gestures that would invoke scrolling/zooming.
/// This is useful if you want to invoke a "drawing mode". (e.g. Ink Annotation drawing)
/// This also blocks programatically calls to scrollToPage.
/// Note: This might be disabled after a reloadData.
@property (nonatomic, assign, getter=isViewLockEnabled) BOOL viewLockEnabled;

/// Locks the current set rotation. Defaults to NO.
/// If set to false, it invokes a attemptRotationToDeviceOrientation (iOS5 and above)
@property (nonatomic, assign, getter=isRotationLockEnabled) BOOL rotationLockEnabled;

/// Tap on begin/end of page scrolls to previous/next page. Defaults to YES.
@property (nonatomic, assign, getter=isScrollOnTapPageEndEnabled) BOOL scrollOnTapPageEndEnabled;

/// Margin at which the scroll to next/previous tap should be invoked. Defaults to 60.
@property (nonatomic, assign) CGFloat scrollOnTapPageEndMargin;

/**
    Allows text selection. Defaults to YES.

    Note: This implies that the PDF file actually contains text glypths.
          Sometimes text is represented via embedded images or vectors, in that case we can't select it.

    Also disable long press gesture recognizer on PSPDFScrollView if set to NO.

    Only available in PSPDFKit Annotate.
 */
@property (nonatomic, assign, getter=isTextSelectionEnabled) BOOL textSelectionEnabled;

/// If YES, when a PDF that requires a password is set, a password dialog is shown.
/// (The password dialog is of class PSPDFPasswordView; customize with overrideClassNames)
/// Defaults to YES. If NO, an attempt to display the document anyway is made.
@property (nonatomic, assign, getter=isPasswordDialogEnabled) BOOL passwordDialogEnabled;

/// If embedded via iOS5 viewController containment, set this to true to allow this controller
/// to access the parent navigationBar/navigationController to add custom buttons.
/// Has no effect if toolbarEnabled is false or there's no parentViewController. Defaults to NO.
@property (nonatomic, assign) BOOL useParentNavigationBar;

/// Set the default link action for pressing on PSPDFLinkAnnotations. Default is PSPDFLinkActionInlineBrowser.
/// Note: if modal is set in the link, this property has no effect.
@property (nonatomic, assign) PSPDFLinkAction linkAction;


/// @name Toolbar button items

/*
 Note: This more dynamic toolbar building system replaces the properties
 searchEnabled, outlineEnabled, printEnabled, openInEnabled.

 You can now build your own toolbar with much less hassle.
 For example, to add those features under the "action" icon as a menu, use this:
 self.additionalRightBarButtonItems = @[self.printButtonItem, self.openInButtonItem, self.emailButtonItem];

 You can change the button with using the subclassing system: (e.g. if you are looking for toolbarBackButton)
 overrideClassNames = @[[PSPDFCloseBarButtonItem class] : [MyCustomButtonSubclass class]];
*/

/// Default button in leftBarButtonItems if view is presented modally.
@property (nonatomic, strong, readonly) PSPDFBarButtonItem *closeButtonItem;

// Default button items included by default in rightToolbarButtonItems

/// Show Outline/Table Of Contents (if available in the PDF)
@property (nonatomic, strong, readonly) PSPDFBarButtonItem *outlineButtonItem;
/// Enable Search.
@property (nonatomic, strong, readonly) PSPDFBarButtonItem *searchButtonItem;
/// Document/Thumbnail toggle.
@property (nonatomic, strong, readonly) PSPDFBarButtonItem *viewModeButtonItem;


// Default button items not included by default

/// Print feature. Only displayed if document is allowed to be printed.
@property (nonatomic, strong, readonly) PSPDFBarButtonItem *printButtonItem;

/// Shows the Open In... iOS dialog. Only works with single-file pdf's.
@property (nonatomic, strong, readonly) PSPDFBarButtonItem *openInButtonItem;

/// Send current pdf via email. Only works with single-file/data pdf's.
@property (nonatomic, strong, readonly) PSPDFBarButtonItem *emailButtonItem;

/// Show the annotation menu. Only available in PSPDFKit Annotate.
@property (nonatomic, strong, readonly) PSPDFBarButtonItem *annotationButtonItem;

/// Show the bookmarks menu.
@property (nonatomic, strong, readonly) PSPDFBarButtonItem *bookmarkButtonItem;

/// Show a button to control the brightness.
@property (nonatomic, strong, readonly) PSPDFBarButtonItem *brightnessButtonItem;

/**
 Bar button items displayed at the left of the toolbar
 Must be UIBarButtonItem or PSPDFBarButtonItem instances
 Defaults to (closeButtonItem) if view is presented modally.
 
 Note that it appears that UIKit limits the left toolbar size if spaces is low in the toolbar, potentially cutting off buttons
 in those toolbars if the title is also too long. You can either reduce the number of buttons, cut down the text or use a titleView to 
 fix this problem. It also appears that UIKit focues on the leftToolbar, the right one is cut of much later.
 This problem only appears on the iPad in portrait mode.
 You can also use updateSettingsForRotation to adapt the toolbar for portrait/landscape mode.
 */
@property (nonatomic, strong) NSArray *leftBarButtonItems;

/// Bar button items displayed at the right of the toolbar
/// Must be UIBarButtonItem or PSPDFBarButtonItem instances
/// Defaults to @[self.searchButtonItem, self.outlineButtonItem, self.viewModeButtonItem];
@property (nonatomic, strong) NSArray *rightBarButtonItems;

/// Displayed at the left of the rightBarButtonItems inside an action sheet
/// Must be PSPDFBarButtonItem instances
/// If [additionalRightToolbarButtonItems count] == 1 then no action sheet is displayed
@property (nonatomic, strong) NSArray *additionalRightBarButtonItems; // defaults to nil

/// Add your custom UIBarButtonItems so that they won't be automatically enabed/disabed.
/// Note: You really want to add yout custom close/back button there, else the user might get stuck!
@property (nonatomic, strong) NSArray *barButtonItemsAlwaysEnabled;

/// UIBarButtonItem doesn't support calculation of it's width, so we have to approximate.
/// This allows you to change the minimum width if the heuristics fail.
/// Note: Set this in your subclass within updateToolbars, then call [super updateToolbars].
@property (nonatomic, assign) CGFloat minLeftToolbarWidth;

/// Allows to change the minimum width of the right toolbar. Set this within updateToolbars.
@property (nonatomic, assign) CGFloat minRightToolbarWidth;


/// @name Appearance Properties

/// Set a PageMode defined in the enum. (Single/Double Pages)
/// Reloads the view, unless it is set while rotation is active.
/// Thus, one can customize the rotation behavior with animations when set within willAnimate*.
/// Defaults to PSPDFPageModeAutomatic on iPad and PSPDFPageModeSingle on iPhone.
@property (nonatomic, assign) PSPDFPageMode pageMode;

/**
    Defines the page transition. Replaces pageCurlEnabled; allows more modes.

    Note about PSPDFPageCurlTransition:
    PageCurl needs iOS5 and above and will fall back to default scrolling on iOS4.
    PageCurl is more memory intensive; you might wanna disable this on an iPad1.
    (e.g. with using the PSPSDIsCrappyDevice() to check for modern devices)

    If you change the property dynamically depending on the screen orientation, don't use
    willRotateToInterfaceOrientation but didRotateFromInterfaceOrientation,
    else the controller will get in an invalid state.
*/
@property (nonatomic, assign) PSPDFPageTransition pageTransition;

/// Change scrolling direction. defaults to horizontal scrolling. (PSPDFScrollDirectionHorizontal)
/// Only relevant for scrolling page transitions.
@property (nonatomic, assign) PSPDFScrollDirection pageScrolling;

/// Shows first document page alone. Not relevant in PSPDFPageModeSinge. Defaults to NO.
@property (nonatomic, assign, getter=isDoublePageModeOnFirstPage) BOOL doublePageModeOnFirstPage;

/// Allow zooming of small documents to screen width/height. Defaults to YES.
@property (nonatomic, assign, getter=isZoomingSmallDocumentsEnabled) BOOL zoomingSmallDocumentsEnabled;

/// For Left-To-Right documents, this sets the pagecurl to go backwards. Defaults to NO.
/// Note: doesn't re-order document pages. There's currently no real LTR support in PSPDFKit.
@property (nonatomic, assign, getter=isPageCurlDirectionLeftToRight) BOOL pageCurlDirectionLeftToRight;

/// If true, pages are fit to screen width, not to either height or width (which one is larger - usually height.) Defaults to NO.
/// iPhone switches to yes in willRotateToInterfaceOrientation - reset back to no if you don't want this.
/// fitToWidthEnabled is currently not supported for vertical scrolling or pageCurl mode.
@property (nonatomic, assign, getter=isFitToWidthEnabled) BOOL fitToWidthEnabled;

/// Defaults to NO. If this is set to YES, the page remembers its vertical position if fitToWidthEnabled is enabled. If NO, new pages will start at the page top position.
@property (nonatomic, assign) BOOL fixedVerticalPositionForfitToWidthEnabledMode;

/// PageCurl mode only: clips the page to its boundaries, not showing a pageCurl on empty background. Defaults to YES.
/// Usually you want this, unless your document is variable sized.
@property (nonatomic, assign) BOOL clipToPageBoundaries;

/// Maximum zoom scale for the scrollview. Defaults to 10. Set before creating the view.
@property (nonatomic, assign) float maximumZoomScale;

/// Page padding width between single/double pages. Defaults to 20.
@property (nonatomic, assign) CGFloat pagePadding;

/// Enable/disable page shadow.
@property (nonatomic, assign, getter=isShadowEnabled) BOOL shadowEnabled;

/// Status bar styling. Defaults to PSPDFStatusBarSmartBlack.
/// If controller is used embedded (in a non-fullscreen way), this setting has no effect.
@property (nonatomic, assign) PSPDFStatusBarStyleSetting statusBarStyleSetting;

/// If not set, we'll use scrollViewTexturedBackgroundColor as default.
@property (nonatomic, strong) UIColor *backgroundColor;

/// Set global toolbar tint color. Overrides defaults. Default is nil (depends on statusBarStyleSetting)
@property (nonatomic, strong) UIColor *tintColor;

/// Enable to add tinting to UIPopoverController. (using a custom UIPopoverView subclass)
/// iOS5 and later. Defaults to YES. New since PSPDFKit 2.2.
@property (nonatomic, assign) BOOL shouldTintPopovers;

/// The navigationBar is animated. Check this to get the proper value, even if navigationBar.navigationBarHidden is not yet set (but will be in the animation block)
@property (nonatomic, assign, getter=isNavigationBarHidden, readonly) BOOL navigationBarHidden;

/// Annotations are faded in. Set global duration for this fade here. Defaults to 0.25f.
@property (nonatomic, assign) CGFloat annotationAnimationDuration;


/// @name Class Accessors

/// Return the pageView for a given page. Returns nil if page is not initalized (e.g. page is not visible.)
/// Usually, using the delegates is a better idea to get the current page.
- (PSPDFPageView *)pageViewForPage:(NSUInteger)page;

/// Saves the popoverController if currently displayed.
@property (nonatomic, strong) UIPopoverController *popoverController;

/// Paging scroll view. (hosts scollviews for pdf)
@property (nonatomic, strong, readonly) UIScrollView *pagingScrollView;


/// @name Thumbnail View

/// View mode: PSPDFViewModeDocument or PSPDFViewModeThumbnails.
@property (nonatomic, assign) PSPDFViewMode viewMode;
- (void)setViewMode:(PSPDFViewMode)viewMode animated:(BOOL)animated;

/// The UIGridView/PSPDFGridView thumbnail view.
@property (nonatomic, strong, readonly) PSUICollectionView *gridView;

/// Change thumbnail size. Default is 170x220.
@property (nonatomic, assign) CGSize thumbnailSize;

/// Thumbnails on iPhone are smaller - you may change the reduction factor. Defaults to 0.5.
@property (nonatomic, assign) CGFloat iPhoneThumbnailSizeReductionFactor;


/// @name Helpers

/// Depending on pageMode, this returns true if two pages are displayed.
- (BOOL)isDoublePageMode;
- (BOOL)isDoublePageModeForOrientation:(UIInterfaceOrientation)interfaceOrientation;

// we have certain cases where even in double page situations one page has to be displayed
// (e.g. cover page; last page)
- (BOOL)isDoublePageModeForPage:(NSUInteger)page;

/// Checks if the current page is on the right side, when in double page mode. Page starts at 0.
- (BOOL)isRightPageInDoublePageMode:(NSUInteger)page;

/// Show a modal view controller with automatically added close button on the left side.
- (void)presentModalViewController:(UIViewController *)controller embeddedInNavigationController:(BOOL)embedded withCloseButton:(BOOL)closeButton animated:(BOOL)animated;

/// Show a modal view controller or a popover with automatically added close button on the left side.
/// Use sender OR rect (both only needed for the popover)
extern NSString *const PSPDFPresentOptionRect;                          // target rect, if sender is nil for UIPopoverController
extern NSString *const PSPDFPresentOptionPopoverContentSize;            // content size for UIPopoverController
extern NSString *const PSPDFPresentOptionAllowedPopoverArrowDirections; // customize default arrow directions for popover.
extern NSString *const PSPDFPresentOptionModalPresentationStyle;        // overrides UIPopoverController if set.
extern NSString *const PSPDFPresentOptionAlwaysModal;                   // don't use UIPopoverController, even on iPad.
extern NSString *const PSPDFPresentOptionPassthroughViews;              // customizes the click-through views.
- (id)presentViewControllerModalOrPopover:(UIViewController *)controller embeddedInNavigationController:(BOOL)embedded withCloseButton:(BOOL)closeButton animated:(BOOL)animated sender:(UIBarButtonItem *)sender options:(NSDictionary *)options;

/// Return an NSNumber-array of currently visible page numbers.
- (NSArray *)visiblePageNumbers;

/// Return array of currently visible PSPDFPageView's.
- (NSArray *)visiblePageViews;

/// YES if we are at the last page.
- (BOOL)isLastPage;

/// YES if we are at the first page.
- (BOOL)isFirstPage;

/**
    Returns the topmost, active viewcontroller.

    This tries to be smart and even works in weird, non-default situations where viewControllers are embedded w/o iOS5 child controller embedding.

    If you get effects like the email controller not appearing at all, override this and return the controller where modal controllers can be pushed onto.
    (Try "return self" first)

    It's a sad thing that this tends to be one of the most complex things in iOS development to get right.
 */
- (UIViewController *)masterViewController;

@end


@interface PSPDFViewController (SubclassingHooks)

/// Use this to use specific subclass names instead of the default PSPDF* classes.
/// e.g. add an entry of [PSPDFPageView class] / [MyCustomPageView class] as key/value pair to use the custom subclass. (MyCustomPageView must be a subclass of PSPDFPageView)
/// Throws an exception if the overriding class is not a subclass of the overridden class.
@property (nonatomic, strong) NSDictionary *overrideClassNames;

/// Override if you're changing the toolbar to your own.
/// The toolbar is only displayed, if PSPDFViewController is inside a UINavigationController.
- (void)createToolbarAnimated:(BOOL)animated;
- (void)updateToolbarAnimated:(BOOL)animated;

/// Request to update a specific barButton. Might be more efficent than using createToolbar.
- (void)updateBarButtonItem:(UIBarButtonItem *)barButtonItem animated:(BOOL)animated;

/// Can be subclassed to update grid spacing.
- (void)updateGridForOrientation;

/// Called in viewWillAppear with the initial rotation and then in willRotateToInterfaceOrientation.
/// Might be called multiple times during a rotation, so any code in there should be fast.
/// The default implementation for this is empty.
- (void)updateSettingsForRotation:(UIInterfaceOrientation)toInterfaceOrientation;

/// Manually return the desired UI status bar style (default is evaluated via app status bar style)
- (UIStatusBarStyle)statusBarStyle;

// Clears the highlight views.
- (void)clearHighlightedSearchResults;

// Adds the highlight views.
- (void)addHighlightSearchResults:(NSArray *)searchResults;

// Animates a certain search highlight.
- (void)animateSearchHighlight:(PSPDFSearchResult *)searchResult;

/// Access internal UIViewController for displaying the PDF content
@property (nonatomic, strong, readonly) UIViewController<PSPDFTransitionProtocol> *pageTransitionController;

// Return rect of the content view area excluding translucent toolbar/statusbar.
- (CGRect)contentRect;

/// Default saves annotations when app goes to background.
/// Is registered on init/deregistered on dealloc.
/// Only tries to saves document if view is visible.
- (void)applicationDidEnterBackground:(NSNotification *)notification;

@end


@interface PSPDFViewController (Deprecated)

- (BOOL)scrollToPage:(NSUInteger)page animated:(BOOL)animated __attribute__((deprecated("Deprecated. Use setPage:animated: instead.")));
- (BOOL)scrollToPage:(NSUInteger)page animated:(BOOL)animated hideHUD:(BOOL)hideHUD __attribute__((deprecated("Deprecated. Use setPage:animated: and setHUD:animated: instead.")));

@end


// Allows better guessing of the status bar style.
@protocol PSPDFStatusBarStyleHint <NSObject>
- (UIStatusBarStyle)preferredStatusBarStyle;
@end
