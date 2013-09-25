//
//  PSPDFViewController.h
//  PSPDFKit
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
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
#import "PSPDFBookmarkViewController.h"
#import "PSPDFThumbnailViewController.h"
#import "PSPDFAnnotationTableViewController.h"
#import "PSPDFSearchViewController.h"
#import "PSPDFStatusBarStyleHint.h"
#import "PSPDFThumbnailBar.h"

@protocol PSPDFViewControllerDelegate, PSPDFAnnotationSetStore, PSPDFFormSubmissionDelegate;
@class PSPDFDocument, PSPDFScrollView, PSPDFScrobbleBar, PSPDFPageView, PSPDFHUDView, PSPDFPageViewController, PSPDFSearchResult, PSPDFViewState, PSPDFBarButtonItem, PSPDFPageLabelView, PSPDFDocumentLabelView, PSPDFEmailBarButtonItem, PSPDFOpenInBarButtonItem, PSPDFCloseBarButtonItem, PSPDFMoreBarButtonItem, PSPDFBrightnessBarButtonItem, PSPDFBookmarkBarButtonItem, PSPDFViewModeBarButtonItem, PSPDFActivityBarButtonItem, PSPDFAnnotationBarButtonItem, PSPDFSearchBarButtonItem, PSPDFOutlineBarButtonItem, PSPDFPrintBarButtonItem, PSPDFAnnotationToolbar, PSPDFAnnotationViewCache;

/// Page Transition. Can be scrolling or something more fancy.
typedef NS_ENUM(NSInteger, PSPDFPageTransition) {
    PSPDFPageTransitionScrollPerPage,      // One ScrollView per page.
    PSPDFPageTransitionScrollContinuous,   // Similar to UIWebView. Ignores PSPDFPageModeDouble.
    PSPDFPageTransitionCurl                // PageCurl mode, similar to iBooks.
};

/// Current active view mode.
typedef NS_ENUM(NSInteger, PSPDFViewMode) {
    PSPDFViewModeDocument,
    PSPDFViewModeThumbnails
};

/// Active page mode.
typedef NS_ENUM(NSInteger, PSPDFPageMode) {
    PSPDFPageModeSingle,   // Default on iPhone.
    PSPDFPageModeDouble,   // Always show double pages.
    PSPDFPageModeAutomatic // Single in portrait, double in landscape if the document's height > width. Default on iPad.
};

/// Active scrolling direction. Only relevant for scrolling page transitions.
typedef NS_ENUM(NSInteger, PSPDFScrollDirection) {
    PSPDFScrollDirectionHorizontal, // default
    PSPDFScrollDirectionVertical
};

/// Status bar style. (old status will be restored regardless of the style chosen)
typedef NS_ENUM(NSInteger, PSPDFStatusBarStyle) {
    PSPDFStatusBarStyleInherit,             /// Don't change status bar style, but show/hide status bar on HUD events.
    PSPDFStatusBarStyleSmartBlack,          /// UIStatusBarStyleBlackOpaque on iPad, UIStatusBarStyleBlackTranslucent on iPhone.
    PSPDFStatusBarStyleSmartBlackHideOnIpad,/// Similar to PSPDFStatusBarStyleSmartBlack (iOS 7: white), but also hides statusBar on iPad.
    PSPDFStatusBarStyleBlackOpaque,         /// Opaque Black everywhere. (iOS 7: white)
    PSPDFStatusBarStyleDefault,             /// Default status bar (iOS 6: white on iPhone/black on iPad iOS 7: Black).
    PSPDFStatusBarStyleDisable              /// Never show status bar.
};

typedef NS_ENUM(NSInteger, PSPDFHUDViewMode) {
    PSPDFHUDViewModeAlways,                   // Always show the HUD.
    PSPDFHUDViewModeAutomatic,                // Show HUD on touch and first/last page.
    PSPDFHUDViewModeAutomaticNoFirstLastPage, // Show HUD on touch.
    PSPDFHUDViewModeNever                     // Never show the HUD.
};

typedef NS_ENUM(NSInteger, PSPDFHUDViewAnimation) {
    PSPDFHUDViewAnimationNone,            // Don't animate HUD appearance
    PSPDFHUDViewAnimationFade,            // Fade HUD in/out
    PSPDFHUDViewAnimationSlide            // Slide HUD.
};

typedef NS_ENUM(NSInteger, PSPDFThumbnailBarMode) {
    PSPDFThumbnailBarModeNone,            // Don't show thumbnail bottom bar.
    PSPDFThumbnailBarModeScrobbleBar,     // Show scrobble bar (like iBooks, PSPDFScrobbleBar)
    PSPDFThumbnailBarModeScrollable       // Show scrollable thumbnail bar (PSPDFThumbnailBar)
};

/// Default action for PDF link annotations.
typedef NS_ENUM(NSInteger, PSPDFLinkAction) {
    PSPDFLinkActionNone,         // Link actions are ignored.
    PSPDFLinkActionAlertView,    // Link actions open an UIAlertView.
    PSPDFLinkActionOpenSafari,   // Link actions directly open Safari.
    PSPDFLinkActionInlineBrowser // Link actions open in an inline browser.
};

// Customize how a single page should be displayed.
typedef NS_ENUM(NSInteger, PSPDFPageRenderingMode) {
    PSPDFPageRenderingModeThumbnailThenFullPage, // Load cached page async.
    PSPDFPageRenderingModeFullPage,              // Load cached page async, no upscaled thumb.
    PSPDFPageRenderingModeFullPageBlocking,      // Load cached page directly.
    PSPDFPageRenderingModeThumbnailThenRender,   // Don't use cached page but thumb.
    PSPDFPageRenderingModeRender                 // Don't use cached page nor thumb.
};

// Menu options when text is selected on this document.
typedef NS_OPTIONS(NSUInteger, PSPDFTextSelectionMenuAction) {
    PSPDFTextSelectionMenuActionSearch              = 1 << 0,
    PSPDFTextSelectionMenuActionDefine              = 1 << 1, // Starting with iOS 7, this will also offer Wikipedia in the controller.
    PSPDFTextSelectionMenuActionWikipediaAsFallback = 1 << 2, // Only displayed if Define fails/is missing. Ignored as of iOS 7.
    PSPDFTextSelectionMenuActionAll                 = NSUIntegerMax
};

/**
 This is the main view controller to display PDFs. Can be displayed in full-screen or embedded. Everything in PSPDFKit is based around PSPDFViewController. This is the class you want to override and customize.

 Make sure to correctly use viewController containment when adding this as a child view controller. If you override this class, ensure all UIViewController methods you're using do call super. (e.g. viewWillAppear).

 For subclassing, please use overrideClass:withClass: to register your custom subclasses.

 The best time for setting the properties is during initialization, in commonInitWithDocument:. Some properties require a call to reloadData if they are changed after the controller has been displayed. Do not set properties during a rotation phase or view appearance (e.g. viewWillAppear is bad, viewDidAppear is ok) since that could corrupt internal state, instead use updateSettingsForRotation:.
*/
@interface PSPDFViewController : PSPDFBaseViewController <PSPDFOutlineViewControllerDelegate, PSPDFPasswordViewDelegate, PSPDFTextSearchDelegate, PSPDFWebViewControllerDelegate, PSPDFBookmarkViewControllerDelegate, PSPDFSearchViewControllerDelegate, PSPDFAnnotationTableViewControllerDelegate, PSPDFThumbnailViewControllerDelegate, PSPDFThumbnailBarDelegate, PSPDFOverridable, UIPopoverControllerDelegate, MFMailComposeViewControllerDelegate>

/// @name Initialization and essential properties

/// Initialize with a document.
/// Document can be nil. In this case, just the background is displayed and the HUD stays visible.
/// Also supports creation via initWithCoder to allow usage in Storyboards.
- (id)initWithDocument:(PSPDFDocument *)document NS_REQUIRES_SUPER;

/// Register delegate to capture events, change properties.
@property (nonatomic, weak) IBOutlet id<PSPDFViewControllerDelegate> delegate;

/// Register to be informed of and direct form submissions.
@property (nonatomic, weak) IBOutlet id<PSPDFFormSubmissionDelegate> formSubmissionDelegate;

/// Property for the currently displayed document.
/// @note To allow easier setup via Storyboard, this property also accepts NSStrings. (The default bundle path will be used)
@property (nonatomic, strong) PSPDFDocument *document;

/// Recreates the content view hierarchy. Usually automatically invoked if you change certain properties (like document, pageTransition).
- (IBAction)reloadData;


/// @name Page Scrolling

/// Set current page. Page starts at 0.
@property (nonatomic, assign) NSUInteger page;

/// Set current page, optionally animated. Page starts at 0. Returns NO if page is invalid (e.g. out of bounds).
- (BOOL)setPage:(NSUInteger)page animated:(BOOL)animated;

/// Scroll to next page. Will potentially advance two pages in dualPage mode.
- (BOOL)scrollToNextPageAnimated:(BOOL)animated;

/// Scroll to previous page. Will potentially decrease two pages in dualPage mode.
- (BOOL)scrollToPreviousPageAnimated:(BOOL)animated;

/// If we're in double page mode, this will return the current screen page, else it's equal to page.
/// e.g. if you have 50 pages, you get 25/26 "double pages" when in double page mode.
@property (nonatomic, assign, readonly) NSUInteger screenPage;


/// @name Zooming

/// Scrolls to a specific rect on the current page. No effect if zoom is at 1.0.
/// Note that rect are *screen* coordinates. If you want to use PDF coordinates, convert them via:
/// PSPDFConvertPDFRectToViewRect() or -convertPDFPointToViewPoint of PSPDFPageView.
- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated;

/// Zooms to a specific rect, optionally animated.
- (void)zoomToRect:(CGRect)rect animated:(BOOL)animated;

/// Zoom to specific scale, optionally animated.
- (void)setZoomScale:(float)scale animated:(BOOL)animated;


/// @name View State Restoration

/// Saves the view state into a serializable object. (page/zoom/position/HUD)
@property (nonatomic, strong) PSPDFViewState *viewState;

/// Restores the view state, optionally animated. (page/zoom/position/HUD)
- (void)setViewState:(PSPDFViewState *)viewState animated:(BOOL)animated;


/// @name Searching

/// Search current page, but don't show any search UI.
extern NSString *const PSPDFViewControllerSearchHeadlessKey;

/// Searches for `searchText` within the current document.
/// Opens the PSPDFSearchViewController unless specified differently in `options`.
- (void)searchForString:(NSString *)searchText options:(NSDictionary *)options animated:(BOOL)animated;


/// @name Properties

/// Set margin for document pages. Defaults to UIEdgeInsetsZero.
/// Margin is extra space for your (always visible) UI elements. Content will be moved accordingly.
/// Area outside margin does not receive touch events, or is shown while zooming.
@property (nonatomic, assign) UIEdgeInsets margin;

/// Padding for document pages. Defaults to CGSizeZero. Padding is space that is displayed around the document. (In fact, the minimum zoom is adapted; thus you can only modify width/height here)
/// When changing padding; the touch area is still fully active.
@property (nonatomic, assign) CGSize padding;

/// This manages how the PDF image cache (thumbnail, full page) is used. Defaults to PSPDFPageRenderingModeThumbnailsThenFullPage.
/// PSPDFPageRenderingModeFullPageBlocking is a great option for PSPDFPageTransitionCurl.
/// @warning: PSPDFPageRenderingModeFullPageBlocking will disable certain page scroll animations.
@property (nonatomic, assign) PSPDFPageRenderingMode renderingMode;

/// If set to YES, tries to find the text blocks on the page and zooms into the tapped block.
/// NO will perform a generic zoom into the tap area. Defaults to YES.
@property (nonatomic, assign, getter=isSmartZoomEnabled) BOOL smartZoomEnabled;

/// Enable/disable scrolling. Can be used in special cases where scrolling is turned off (temporarily). Defaults to YES.
@property (nonatomic, assign, getter=isScrollingEnabled) BOOL scrollingEnabled;

/// Locks the view. Disables scrolling, zooming and gestures that would invoke scrolling/zooming. Also blocks programmatically calls to scrollToPage. This is useful if you want to invoke a "drawing mode". (e.g. Ink Annotation drawing)
/// @warning This might be disabled after a reloadData.
@property (nonatomic, assign, getter=isViewLockEnabled) BOOL viewLockEnabled;

/// Locks the current set rotation. Defaults to NO.
/// If set to false, it invokes an attemptRotationToDeviceOrientation.
/// @warning Rotation lock is application-global, even when the controller isn't displayed.
@property (nonatomic, assign, getter=isRotationLockEnabled) BOOL rotationLockEnabled;

/// Tap on begin/end of page scrolls to previous/next page. Defaults to YES.
@property (nonatomic, assign, getter=isScrollOnTapPageEndEnabled) BOOL scrollOnTapPageEndEnabled;

/// Page transition to next/prev page via scrollOnTapPageEndEnabled is enabled. Defaults to YES.
/// @warning Only effective if scrollOnTapPageEndEnabled is set to YES.
@property (nonatomic, assign, getter=isScrollOnTapPageEndAnimationEnabled) BOOL scrollOnTapPageEndAnimationEnabled;

/// Margin at which the scroll to next/previous tap should be invoked. Defaults to 60.
@property (nonatomic, assign) CGFloat scrollOnTapPageEndMargin;

/// Allows text selection. Defaults to YES. Only available in PSPDFKit Annotate.
/// @warning This implies that the PDF file actually contains text glyphs. Sometimes text is represented via embedded images or vectors, in that case PSPDFKit can't select it.
@property (nonatomic, assign, getter=isTextSelectionEnabled) BOOL textSelectionEnabled;

/// Allows image selection. Defaults to NO. Only available in PSPDFKit Annotate.
/// @warning Will only work if textSelectionEnabled is also set to YES. This implies that the image is not in vector format. Only supports a subset of all possible image types in PDF.
@property (nonatomic, assign, getter=isImageSelectionEnabled) BOOL imageSelectionEnabled;

/// If YES, when a PDF that requires a password is set, a password dialog is shown.
/// (The password dialog is of class PSPDFPasswordView; customize with overrideClassNames)
/// Defaults to YES. If NO, an attempt to display the document anyway is made.
@property (nonatomic, assign, getter=isPasswordDialogEnabled) BOOL passwordDialogEnabled;

/// Enable/Disable all internal gesture recognizers. Defaults to YES.
/// Can be useful if you're doing custom drawing on the PSPDFPageView.
@property (nonatomic, assign) BOOL internalTapGesturesEnabled;

/// Set this to true to allow this controller to access the parent navigationBar/navigationController to add custom buttons.
/// Has no effect if toolbarEnabled is false or there's no parentViewController. Defaults to NO.
@property (nonatomic, assign) BOOL useParentNavigationBar;

/// If YES, the navigation bar state before pushing this controller is captured and subsequently restored in viewWillDisappear.
/// Set to NO to not restore the style. Defaults to YES.
@property (nonatomic, assign) BOOL shouldRestoreNavigationBarStyle;

/// Set the default link action for pressing on PSPDFLinkAnnotations. Default is PSPDFLinkActionInlineBrowser.
/// @note If modal is set in the link, this property has no effect.
@property (nonatomic, assign) PSPDFLinkAction linkAction;

/// Allows to customize other displayed menu actions when text is selected.
/// Defaults to PSPDFTextSelectionMenuActionSearch|PSPDFTextSelectionMenuActionDefine|PSPDFTextSelectionMenuActionWikipediaAsFallback
/// @note This is no flag that gets parsed from the document (like allowsCopying) but seems to be  a better fit here than on the controller, since almost all menu related options are controller from the document.
@property (nonatomic, assign) PSPDFTextSelectionMenuAction allowedMenuActions;


/// @name HUD Controls

/// View that is displayed as HUD. Make a KVO on viewMode if you build a different HUD for thumbnails view.
/// HUDView is created in viewDidLoad. Subclass or use KVO to add your custom views when this changes.
@property (nonatomic, strong, readonly) PSPDFHUDView *HUDView;

/// Manages the show/hide mode of the HUD view. Defaults to PSPDFHUDViewModeAutomatic.
/// If your statusbar setting is set to PSPDFStatusBarStyleDefault, the HUD will be non-opaque and thus stay visible always.
/// @warning HUD will not change when changing this mode after controller is visible. Use setHUDVisible:animated: instead.
/// Does not affect manual calls to setHUDVisible.
@property (nonatomic, assign) PSPDFHUDViewMode HUDViewMode;

/// Sets the way the HUD will be animated. Defaults to PSPDFHUDViewAnimationFade.
@property (nonatomic, assign) PSPDFHUDViewAnimation HUDViewAnimation;

/// Show or hide HUD controls, titlebar, status bar (depending on the statusBarStyleSetting).
@property (nonatomic, assign, getter=isHUDVisible) BOOL HUDVisible;

/// Show or hide HUD controls. optionally animated.
- (BOOL)setHUDVisible:(BOOL)show animated:(BOOL)animated;

/// Show the HUD. Respects HUDViewMode.
- (BOOL)showControlsAnimated:(BOOL)animated;

/// Hide the HUD. Respects HUDViewMode.
- (BOOL)hideControlsAnimated:(BOOL)animated;

/// Hide the HUD (respects HUDViewMode) and additional elements like page selection.
- (BOOL)hideControlsAndPageElementsAnimated:(BOOL)animated;

/// Toggles the HUD. Respects HUDViewMode.
- (BOOL)toggleControlsAnimated:(BOOL)animated;

/// Enables default header toolbar. Only displayed if inside UINavigationController. Defaults to YES. Set before loading view.
@property (nonatomic, assign, getter=isToolbarEnabled) BOOL toolbarEnabled;

/// Allow PSPDFKit to change the title of this viewController.
/// Defaults to NO on iPhone (no space) and YES on iPad.
/// @warning Requires isToolbarEnabled = YES to work.
@property (nonatomic, assign) BOOL allowToolbarTitleChange;

/// Sets the thumbnail bar mode. Defaults to PSPDFThumbnailBarModeScrobbleBar.
@property (nonatomic, assign) PSPDFThumbnailBarMode thumbnailBarMode;

/// Enables/Disables the bottom document site position overlay.
/// Defaults to YES. Animatable. Will be added to the HUDView.
@property (nonatomic, assign, getter=isPageLabelEnabled) BOOL pageLabelEnabled;

/// Enable/disable the top document label overlay. Defaults to YES on iPhone and NO on iPad.
/// (On iPad, there's enough space to show the title in the navigationBar)
@property (nonatomic, assign, getter=isDocumentLabelEnabled) BOOL documentLabelEnabled;

/// If YES, shows a decent UIActivityIndicator on the top right while page is rendering. Defaults to YES.
@property (nonatomic, assign, getter=isRenderAnimationEnabled) BOOL renderAnimationEnabled;

/// Content view. Use this if you want to add any always-visible UI elements.
/// Created in viewDidLoad. contentView is behind HUDView but always visible.
/// ContentView does NOT overlay the navigationBar/statusBar, even if that one is transparent.
@property (nonatomic, strong, readonly) PSPDFHUDView *contentView;

/// @name Appearance Properties

/// Set a PageMode defined in the enum. (Single/Double Pages)
/// Reloads the view, unless it is set while rotation is active. Thus, one can customize the rotation behavior with animations when set within willAnimate*. Defaults to PSPDFPageModeAutomatic on iPad and PSPDFPageModeSingle on iPhone.
@property (nonatomic, assign) PSPDFPageMode pageMode;

/// Defines the page transition.
/// @warning If you change the property dynamically depending on the screen orientation, don't use willRotateToInterfaceOrientation but didRotateFromInterfaceOrientation, else the controller will get in an invalid state. ChildViewControllers get rotation events AFTER the parent view controller, so if you're changing this from a parent viewController, for PSPDFKit the rotation hasn't been completed yet, and your app will eventually crash. In that case, use a dispatch_async(dispatch_get_main_queue(), ^{ ... }); to set. You might just want to override updateSettingsForRotation: and set your properties there.
@property (nonatomic, assign) PSPDFPageTransition pageTransition;

/// Page scrolling direction. Defaults to PSPDFScrollDirectionHorizontal. Only relevant for scrolling page transitions.
@property (nonatomic, assign) PSPDFScrollDirection scrollDirection;

/// Shows first document page alone. Not relevant in PSPDFPageModeSingle. Defaults to NO.
@property (nonatomic, assign, getter=isDoublePageModeOnFirstPage) BOOL doublePageModeOnFirstPage;

/// Allow zooming of small documents to screen width/height. Defaults to YES.
@property (nonatomic, assign, getter=isZoomingSmallDocumentsEnabled) BOOL zoomingSmallDocumentsEnabled;

/// For Left-To-Right documents, this sets the pagecurl to go backwards. Defaults to NO.
/// @note Doesn't re-order document pages. There's currently no real LTR support in PSPDFKit.
@property (nonatomic, assign, getter=isPageCurlDirectionLeftToRight) BOOL pageCurlDirectionLeftToRight;

/// If true, pages are fit to screen width, not to either height or width (which one is larger - usually height.) Defaults to NO.
/// iPhone switches to yes in willRotateToInterfaceOrientation - reset back to no if you don't want this.
/// fitToWidthEnabled is not supported for vertical scrolling or pageCurl mode. (You might want PSPDFPageTransitionScrollContinuous)
@property (nonatomic, assign, getter=isFitToWidthEnabled) BOOL fitToWidthEnabled;

/// Always bounces pages in the set scroll direction.
/// Defaults to NO. If set, pages with only one page will still bounce left/right or up/down instead of being fixed. Corresponds to UIScrollView's `alwaysBounceHorizontal` or `alwaysBounceVertical` of the pagingScrollView.
/// @note Only valid for PSPDFPageTransitionScrollPerPage or PSPDFPageTransitionScrollContinuous.
@property (nonatomic, assign) BOOL alwaysBouncePages;

/// Defaults to NO. If this is set to YES, the page remembers its vertical position if fitToWidthEnabled is enabled. If NO, new pages will start at the page top position.
@property (nonatomic, assign) BOOL fixedVerticalPositionForFitToWidthEnabledMode;

/// Only useful for PSPDFPageTransitionCurl. Clips the page to its boundaries, not showing a pageCurl on empty background. Defaults to YES. Set to NO if your document is variably sized.
@property (nonatomic, assign) BOOL clipToPageBoundaries;

/// Minimum zoom scale. Defaults to 1. You usually don't want to change this.
/// @warning This might break certain pageTransitions if not set to 1.
@property (nonatomic, assign) float minimumZoomScale;

/// Maximum zoom scale for the scrollview. Defaults to 10. Set before creating the view.
@property (nonatomic, assign) float maximumZoomScale;

/// Page padding width between single/double pages. Defaults to 20.
@property (nonatomic, assign) CGFloat pagePadding;

/// Enable/disable page shadow. Defaults to YES on iOS6 and NO on iOS7.
@property (nonatomic, assign, getter=isShadowEnabled) BOOL shadowEnabled;

/// Status bar styling. Defaults to PSPDFStatusBarStyleSmartBlack.
/// Setting this will update statusBarStyle, transparentHUD, shouldHideNavigationBarWithHUD, shouldHideStatusBarWithHUD.
@property (nonatomic, assign) PSPDFStatusBarStyle statusBarStyleSetting;

/// Current statusBarStyle.
/// @warning Remember that UIStatusBarStyleBlackTranslucent is not available on iPad.
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

/// Current navigationBarStyle.
@property (nonatomic, assign) UIBarStyle navigationBarStyle;

/// Defines if the HUD is transparent or not.
/// This is set depending on the `statusBarStyle` and always enabled by default on iOS7.
/// @warning If this is set to NO, shouldHideNavigationBarWithHUD and shouldHideStatusBarWithHUD won't work as expected.
@property (nonatomic, assign, getter=isTransparentHUD) BOOL transparentHUD;

/// If YES, the navigation bar will be hidden when the HUD is hidden.
@property (nonatomic, assign) BOOL shouldHideNavigationBarWithHUD;

/// If YES, the status bar will be hidden when the HUD is hidden.
/// @note Needs to be set before the view is loaded.
/// @warning While you *can* set this to YES and leave shouldHideNavigationBarWithHUD at NO, this won't make much sense.
@property (nonatomic, assign) BOOL shouldHideStatusBarWithHUD;

/// Set global toolbar tint color. Overrides defaults. Default is nil (depends on statusBarStyleSetting)
@property (nonatomic, strong) UIColor *tintColor;

/// Enable to add tinting to UIPopoverController using a custom UIPopoverView subclass. Defaults to NO.
@property (nonatomic, assign) BOOL shouldTintPopovers;

/// Enable to allow tinting of PSPDFAlertView. Defaults to YES.
/// @note This is ignored as of iOS 7.
@property (nonatomic, assign) BOOL shouldTintAlertView;

/// If not set, we'll use the PSPDFKit default.
/// Default is scrollViewTexturedBackgroundColor on iOS <= 6, and dark gray on iOS7+.
@property (nonatomic, strong) UIColor *backgroundColor;

/// The navigationBar is animated. Check this to get the proper value, even if navigationBar.navigationBarHidden is not yet set (but will be in the animation block)
@property (nonatomic, assign, getter=isNavigationBarHidden, readonly) BOOL navigationBarHidden;

/// Overlay annotations are faded in. Set global duration for this fade here. Defaults to 0.25f.
@property (nonatomic, assign) CGFloat annotationAnimationDuration;

/// If set to YES, you can group/ungroup annotations with the multi-select tool.
/// Defaults to YES.
@property (nonatomic, assign) BOOL annotationGroupingEnabled;

/// If set to YES, a long-tap that ends on a page area that is not a text/image will show a new menu to create annotations. Defaults to YES.
/// If set to NO, there's no menu displayed and the loupe is simply hidden. Only available in PSPDFKit Annotate.
/// Menu can be intercepted and customized with the shouldShowMenuItems:atSuggestedTargetRect:forAnnotation:inRect:onPageView: delegate. (when annotation is nil)
@property (nonatomic, assign, getter=isCreateAnnotationMenuEnabled) BOOL createAnnotationMenuEnabled;

/// If YES, the annotation menu will be displayed after an annotation has been created. Defaults to NO.
@property (nonatomic, assign) BOOL showAnnotationMenuAfterCreation;

/// Controls if a second tap to an annotation that allows inline editing enters edit mode. Defaults to YES.
/// (The most probable candidate for this is PSPDFFreeTextAnnotation)
@property (nonatomic, assign) BOOL annotationEntersEditModeAfterSecondTapEnabled;

/// The save method will be invoked when the view controller is dismissed. For compatibility reasons, the default value for this method is NO. Make sure that you don't re-create the PSPDFDocument object if you enable background saving, else you might run into race conditions where the old object is still saving and the new one might load outdated/corrupted data.
/// Enabling this will speed up controller dismissal.
@property (nonatomic, assign) BOOL allowBackgroundSaving;

/// @name Class Accessors

/// Return the pageView for a given page. Returns nil if page is not Initialized (e.g. page is not visible.)
/// Usually, using the delegates is a better idea to get the current page.
- (PSPDFPageView *)pageViewForPage:(NSUInteger)page;

/// Saves the popoverController if currently displayed.
/// @note PSPDFKit also sometimes shows controls that internally are a popover but don't expose it, like the UIActionSheet or the UIPrintInteractionController. You can dismiss those popovers with calling [PSPDFBarButtonItem dismissPopoverAnimated:].
@property (nonatomic, strong) UIPopoverController *popoverController;

@property (nonatomic, strong) UIViewController *halfModalController;

/// Paging scroll view. (hosts scroll views for PDF)
/// If you want to customize this, override reloadData and set the properties after calling super.
@property (nonatomic, strong, readonly) UIScrollView *pagingScrollView;


/// @name Thumbnail View

/// Get or set the current view mode. (PSPDFViewModeDocument or PSPDFViewModeThumbnails)
@property (nonatomic, assign) PSPDFViewMode viewMode;

/// Set the view mode, optionally animated.
- (void)setViewMode:(PSPDFViewMode)viewMode animated:(BOOL)animated;

/// Thumbnail controller. Contains the (grid) collectionView. Lazily created.
@property (nonatomic, strong) PSPDFThumbnailViewController *thumbnailController;

/// Thumbnail size. For defaults see PSPDFCache.sharedCache.thumbnailSize.
@property (nonatomic, assign) CGSize thumbnailSize;

/// Set margin for thumbnail view mode. Defaults to UIEdgeInsetsMake(15, 15, 15, 15).
/// Margin is extra space around the grid of thumbnails.
@property (nonatomic, assign) UIEdgeInsets thumbnailMargin;


/// @name Helpers

/// Return an NSNumber-Array of currently visible page numbers.
/// @warning This might return more numbers than actually visible if it's queried during a scroll animation.
- (NSOrderedSet *)visiblePageNumbers;

/// Return array of all currently visible PSPDFPageView objects.
- (NSArray *)visiblePageViews;

/// Depending on pageMode, this returns true if two pages are displayed.
- (BOOL)isDoublePageMode;

/// Returns YES if the document is at the last page.
- (BOOL)isLastPage;

/// Returns YES if the document is at the first page.
- (BOOL)isFirstPage;

/// Returns the topmost, active view controller.
/// If you get effects like the email controller not appearing at all, override this and return the controller where modal controllers can be pushed onto. (Try "return self" first)
- (UIViewController *)masterViewController;

@end

@interface PSPDFViewController (PSPDFPresentation)

extern NSString *const PSPDFPresentOptionRect;                          // target rect, if sender is nil for UIPopoverController
extern NSString *const PSPDFPresentOptionPopoverContentSize;            // content size for UIPopoverController
extern NSString *const PSPDFPresentOptionAllowedPopoverArrowDirections; // customize default arrow directions for popover.
extern NSString *const PSPDFPresentOptionModalPresentationStyle;        // overrides UIPopoverController if set.
extern NSString *const PSPDFPresentOptionAlwaysModal;                   // don't use UIPopoverController, even on iPad.
extern NSString *const PSPDFPresentOptionAlwaysPopover;                 // show as popover, even on iPhone. (limited functionality!)
extern NSString *const PSPDFPresentOptionPassthroughViews;              // customizes the click-through views.
extern NSString *const PSPDFPresentOptionWillDismissBlock;              // dispatch_block_t called when the popover is being dismissed.
extern NSString *const PSPDFPresentOptionHalfModalMode;                 // Shows a VC on 50% of the screen. Used for the Inspector on iPhone.
extern NSString *const PSPDFPresentOptionPersistentCloseButtonMode;     // Set to enable a persistent close button.

/// Show a modal view controller or a popover with automatically added close button on the left side.
/// Use sender (UIBarButtonItem or UIView) OR rect in options (both only needed for the popover)
- (id)presentModalOrInPopover:(UIViewController *)controller embeddedInNavigationController:(BOOL)embedded withCloseButton:(BOOL)closeButton animated:(BOOL)animated sender:(id)sender options:(NSDictionary *)options;

@end

@interface PSPDFViewController (PSPDFToolbar)

/// @name Toolbar button items

// You can change the button/icons with using the subclassing system:
// [self overrideClass:PSPDFCloseBarButtonItem.class withClass:MyCustomButtonSubclass.class]

/// Default button in leftBarButtonItems if view is presented modally.
@property (nonatomic, strong, readonly) PSPDFCloseBarButtonItem *closeButtonItem;

/// Show Outline/Table Of Contents (if available in the PDF)
@property (nonatomic, strong, readonly) PSPDFOutlineBarButtonItem *outlineButtonItem;

/// Enable Search.
@property (nonatomic, strong, readonly) PSPDFSearchBarButtonItem *searchButtonItem;

/// Document/Thumbnail toggle.
@property (nonatomic, strong, readonly) PSPDFViewModeBarButtonItem *viewModeButtonItem;

/// Print feature. Only displayed if document is allowed to be printed.
@property (nonatomic, strong, readonly) PSPDFPrintBarButtonItem *printButtonItem;

/// Shows the Open In... iOS dialog. Only works with single-file pdf's.
@property (nonatomic, strong, readonly) PSPDFOpenInBarButtonItem *openInButtonItem;

/// Send current pdf via email. Only works with single-file/data pdf's.
@property (nonatomic, strong, readonly) PSPDFEmailBarButtonItem *emailButtonItem;

/// Show the annotation menu. Only available in PSPDFKit Annotate.
@property (nonatomic, strong, readonly) PSPDFAnnotationBarButtonItem *annotationButtonItem;

/// Show the bookmarks menu.
@property (nonatomic, strong, readonly) PSPDFBookmarkBarButtonItem *bookmarkButtonItem;

/// Show a button to control the brightness.
@property (nonatomic, strong, readonly) PSPDFBrightnessBarButtonItem *brightnessButtonItem;

/// Show a button to show UIActivityViewController (iOS6+).
@property (nonatomic, strong, readonly) PSPDFActivityBarButtonItem *activityButtonItem;

/// If added to the left/rightBarButtonItems, the position of the additionalRightBarButtonItems action button can be customized.
/// By default this button is added to the rightBarButtonItems on the left. Button only visible if additionalRightBarButtonItems.count > 1.
/// @warning Do not add this to additionalRightBarButtonItems.
@property (nonatomic, strong, readonly) PSPDFMoreBarButtonItem *additionalActionsButtonItem;

/// Bar button items displayed at the left of the toolbar. Must be UIBarButtonItem or PSPDFBarButtonItem instances. Defaults to @[closeButtonItem] if view is presented modally.
/// @warning UIKit limits the left toolbar size if space is low in the toolbar, potentially cutting off buttons in those toolbars if the title is also too long. You can either reduce the number of buttons, cut down the text or use a titleView to fix this problem. It also appears that UIKit focuses on the leftToolbar, the right one is cut off much later. This problem only appears on the iPad in portrait mode. You can also use updateSettingsForRotation to adapt the toolbar for portrait/landscape mode.
/// @note If you use any of the provided bar button items in a custom toolbar, make sure to set leftBarButtonItems and rightBarButtonItems to nil - a UIBarButtonItem can only ever have one parent, else some icons might "vanish" from your toolbar.
@property (nonatomic, copy) NSArray *leftBarButtonItems;

/// Bar button items displayed at the right of the toolbar. Must be UIBarButtonItem or PSPDFBarButtonItem instances.
/// Defaults to @[self.searchButtonItem, self.outlineButtonItem, self.viewModeButtonItem];
/// @note If you use any of the provided bar button items in a custom toolbar, make sure to set leftBarButtonItems and rightBarButtonItems to nil - a UIBarButtonItem can only ever have one parent, else some icons might "vanish" from your toolbar.
@property (nonatomic, copy) NSArray *rightBarButtonItems;

/// Displayed at the left of the rightBarButtonItems inside an action sheet. Items must be PSPDFBarButtonItem instances.
/// If additionalRightToolbarButtonItems.count == 1 then no action sheet is displayed
@property (nonatomic, copy) NSArray *additionalBarButtonItems; // defaults to nil

/// Add your custom UIBarButtonItems so that they won't be automatically enabled/disabled.
/// @note You really want to add your custom close/back button there, else the user might get stuck!
/// @warning This needs to be set BEFORE setting left/rightBarButtonItems.
@property (nonatomic, copy) NSArray *barButtonItemsAlwaysEnabled;

/// UIBarButtonItem doesn't support calculation of its width, so we have to approximate.
/// This allows you to change the minimum width if the heuristics fail.
/// @note Set this in your subclass within updateToolbars, then call [super updateToolbars].
@property (nonatomic, assign) CGFloat minLeftToolbarWidth;

/// Allows to change the minimum width of the right toolbar. Set this within updateToolbars.
@property (nonatomic, assign) CGFloat minRightToolbarWidth;

/// Will use UIBarButtonItemStyleBordered instead of UIBarButtonItemStylePlain for toolbar items.
/// @note Setting this won't have any effect in iOS7.
/// @warning You have to call reloadData after changing this.
@property (nonatomic, assign) BOOL useBorderedToolbarStyle;

@end

@interface PSPDFViewController (SubclassingHooks)

/// Override this initializer to allow all use cases (storyboard loading, etc)
- (void)commonInitWithDocument:(PSPDFDocument *)document NS_REQUIRES_SUPER;

/// Use this to use specific subclasses instead of the default PSPDF* classes.
/// This works across the whole framework and allows you to subclass all usages of a class. For example add an entry of PSPDFPageView.class / MyCustomPageView.class to use the custom subclass. (MyCustomPageView must be a subclass of PSPDFPageView)
/// @throws an exception if the overriding class is not a subclass of the overridden class.
/// @note Only set from the main thread, before you first use the object.
/// Model objects will use the overrideClass entries from the set document instead.
- (void)overrideClass:(Class)builtinClass withClass:(Class)subclass;

/// Override if you're changing the toolbar to your own.
/// The toolbar is only displayed, if PSPDFViewController is inside a UINavigationController.
- (void)createToolbarAnimated:(BOOL)animated;

/// Updates the toolbar buttons.
- (void)updateToolbarAnimated:(BOOL)animated;

/// Request to update a specific barButton. Might be more efficient than using createToolbar.
- (void)updateBarButtonItem:(UIBarButtonItem *)barButtonItem animated:(BOOL)animated;

/// Called in viewWillAppear with the initial rotation and then in willRotateToInterfaceOrientation.
/// Might be called multiple times during a rotation, so any code in there should be fast.
/// The default implementation calls the block set in setUpdateSettingsForRotationBlock.
- (void)updateSettingsForRotation:(UIInterfaceOrientation)toInterfaceOrientation;

/// Convenience method for updateSettingsForRotation:
- (void)setUpdateSettingsForRotationBlock:(void (^)(PSPDFViewController *pdfController, UIInterfaceOrientation toInterfaceOrientation))block;

// Clears the highlight views.
- (void)clearHighlightedSearchResults;

// Adds the highlight views.
- (void)addHighlightSearchResults:(NSArray *)searchResults;

// Animates a certain search highlight.
- (void)animateSearchHighlight:(PSPDFSearchResult *)searchResult;

/// Access internal UIViewController for displaying the PDF content
@property (nonatomic, strong, readonly) UIViewController<PSPDFTransitionProtocol> *pageTransitionController;

// Return rect of the content view area excluding translucent toolbar/statusbar.
// This will even return the correctly compensated statusBar if that one is currently not visible.
- (CGRect)contentRect;

/// Will return the annotation bar if currently one is visible.
- (PSPDFAnnotationToolbar *)visibleAnnotationToolbar;

/// Document page label view.
@property (nonatomic, strong) PSPDFPageLabelView *pageLabel;

/// Specifies the distance between the page label view and the top of the scrobble bar or the
/// bottom of the screen, depending on whether the scrobble bar is enabled. Defaults to 30.f
@property (nonatomic, assign) CGFloat pageLabelDistance;

/// Document title label view. (default iPhone only)
@property (nonatomic, strong) PSPDFDocumentLabelView *documentLabel;

/// Scrobble bar. Created lazily. Available if PSPDFThumbnailBarModeScrobbleBar is set.
@property (nonatomic, strong, readonly) PSPDFScrobbleBar *scrobbleBar;

/// Thumbnail bar. Created lazily. Available if PSPDFThumbnailBarModeScrollable is set.
@property (nonatomic, strong, readonly) PSPDFThumbnailBar *thumbnailBar;

// Allows access to the annotation cache.
@property (nonatomic, strong, readonly) PSPDFAnnotationViewCache *annotationViewCache;

// Called when a PDF action requests to load a new document in a new controller (modally).
// Will copy all important settings from the current controller to the new controller.
- (PSPDFViewController *)createNewControllerForDocument:(PSPDFDocument *)document;

// Return page numbers that are visible. Only returns the current set page in continuous scroll mode
// Useful to get exact pages for double page mode.
- (NSArray *)calculatedVisiblePageNumbers;

@end
