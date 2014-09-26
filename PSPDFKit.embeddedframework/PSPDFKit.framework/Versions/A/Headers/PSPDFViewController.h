//
//  PSPDFViewController.h
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
#import "PSPDFPresentationContext.h"
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
#import "PSPDFThumbnailBar.h"
#import "PSPDFHUDView.h"
#import "PSPDFConfiguration.h"
#import <MessageUI/MessageUI.h>

@protocol PSPDFViewControllerDelegate, PSPDFAnnotationSetStore, PSPDFFormSubmissionDelegate;
@class PSPDFDocument, PSPDFScrollView, PSPDFScrobbleBar, PSPDFPageView, PSPDFRelayTouchesView, PSPDFPageViewController, PSPDFSearchResult, PSPDFViewState, PSPDFBarButtonItem, PSPDFPageLabelView, PSPDFDocumentLabelView, PSPDFEmailBarButtonItem, PSPDFMessageBarButtonItem, PSPDFOpenInBarButtonItem, PSPDFCloseBarButtonItem, PSPDFMoreBarButtonItem, PSPDFBrightnessBarButtonItem, PSPDFBookmarkBarButtonItem, PSPDFViewModeBarButtonItem, PSPDFActivityBarButtonItem, PSPDFAnnotationBarButtonItem, PSPDFSearchBarButtonItem, PSPDFOutlineBarButtonItem, PSPDFPrintBarButtonItem, PSPDFAnnotationViewCache, PSPDFAnnotationStateManager, PSPDFSearchHighlightViewManager, PSPDFAction, PSPDFAnnotationToolbar;

/**
 This is the main view controller to display PDFs. Can be displayed in full-screen or embedded. Everything in PSPDFKit is based around `PSPDFViewController`. This is the class you want to override and customize.

 Make sure to correctly use view controller containment when adding this as a child view controller. If you override this class, ensure all `UIViewController` methods you're using do call super. (e.g. `viewWillAppear:`).

 For subclassing, use `overrideClass:withClass:` to register your custom subclasses.

 The best time for setting the properties is during initialization in `commonInitWithDocument:configuration:`. Some properties require a call to `reloadData` if they are changed after the controller has been displayed. Do not set properties during a rotation phase or view appearance (e.g. use `viewDidAppear:` instead of `viewWillAppear:`) since that could corrupt internal state, instead use `updateSettingsForRotation:`.
*/
@interface PSPDFViewController : PSPDFBaseViewController <PSPDFOutlineViewControllerDelegate, PSPDFPasswordViewDelegate, PSPDFTextSearchDelegate, PSPDFWebViewControllerDelegate, PSPDFBookmarkViewControllerDelegate, PSPDFSearchViewControllerDelegate, PSPDFAnnotationTableViewControllerDelegate, PSPDFThumbnailViewControllerDelegate, PSPDFOverridable, UIPopoverControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, PSPDFPresentationContext, PSPDFControlDelegate>

/// @name Initialization and essential properties.

/// Initialize with a document.
/// @note Document can be nil. In this case, just the background is displayed and the HUD stays visible.
/// Also supports creation via `initWithCoder:` to allow usage in Storyboards.
- (instancetype)initWithDocument:(PSPDFDocument *)document;

- (instancetype)initWithDocument:(PSPDFDocument *)document configuration:(PSPDFConfiguration *)configuration NS_REQUIRES_SUPER NS_DESIGNATED_INITIALIZER;

/// Property for the currently displayed document.
/// @note To allow easier setup via Storyboards, this property also accepts NSStrings. (The default bundle path will be used)
@property (nonatomic, strong) PSPDFDocument *document;

/// Register delegate to capture events, change properties.
@property (nonatomic, weak) IBOutlet id<PSPDFViewControllerDelegate> delegate;

/// Register to be informed of and direct form submissions.
@property (nonatomic, weak) IBOutlet id<PSPDFFormSubmissionDelegate> formSubmissionDelegate;

/// Recreates the complete view hierarchy.
- (IBAction)reloadData;


/// @name Page Scrolling

/// Set current page. Page starts at 0.
@property (nonatomic, assign) NSUInteger page;

/// If we're in double page mode, this will return the current screen page, else it's equal to page.
/// e.g. if you have 50 pages, you get 25/26 "double pages" when in double page mode.
@property (nonatomic, assign, readonly) NSUInteger screenPage;

/// Set current page, optionally animated. Page starts at 0. Returns NO if page is invalid (e.g. out of bounds).
- (BOOL)setPage:(NSUInteger)page animated:(BOOL)animated;

/// Scroll to next page. Will potentially advance two pages in dualPage mode.
- (BOOL)scrollToNextPageAnimated:(BOOL)animated;

/// Scroll to previous page. Will potentially decrease two pages in dualPage mode.
- (BOOL)scrollToPreviousPageAnimated:(BOOL)animated;

/// Enable/disable scrolling. Can be used in special cases where scrolling is turned off (temporarily). Defaults to YES.
@property (nonatomic, assign, getter=isScrollingEnabled) BOOL scrollingEnabled;

/// Locks the view. Disables scrolling, zooming and gestures that would invoke scrolling/zooming. Also blocks programmatically calls to scrollToPage. This is useful if you want to invoke a "drawing mode". (e.g. Ink Annotation drawing)
/// @warning This might be disabled after a reloadData.
@property (nonatomic, assign, getter=isViewLockEnabled) BOOL viewLockEnabled;

/// @name Zooming

/// Scrolls to a specific rect on the current page. No effect if zoom is at 1.0.
/// Note that rect are *screen* coordinates. If you want to use PDF coordinates, convert them via:
/// `PSPDFConvertPDFRectToViewRect()` or `-convertPDFPointToViewPoint:` of PSPDFPageView.
- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated;

/// Zooms to a specific view rect, optionally animated.
- (void)zoomToRect:(CGRect)rect page:(NSUInteger)page animated:(BOOL)animated;

/// Zoom to specific scale, optionally animated.
- (void)setZoomScale:(CGFloat)scale animated:(BOOL)animated;


/// @name View State Restoration

/// Saves the view state into a serializable object. (`page`/`zoom`/`position`/`HUD`)
@property (nonatomic, strong) PSPDFViewState *viewState;

/// Restores the view state, optionally animated. (`page`/`zoom`/`position`/`HUD`)
- (void)setViewState:(PSPDFViewState *)viewState animated:(BOOL)animated;


/// @name Searching

/// Search current page, but don't show any search UI.
extern NSString *const PSPDFViewControllerSearchHeadlessKey;

/// Searches for `searchText` within the current document.
/// Opens the `PSPDFSearchViewController` unless specified differently in `options`.
/// The only valid option is `PSPDFViewControllerSearchHeadlessKey` to disable the search UI.
/// `options` are also passed through to the `presentViewController:options:animated:sender:completion:` method.
/// `sender` is used to anchor the search popover, if one should be displayed (see `searchMode` in `PSPDFConfiguration`).
- (void)searchForString:(NSString *)searchText options:(NSDictionary *)options sender:(id)sender animated:(BOOL)animated;

/// The search view manager
@property (nonatomic, strong, readonly) PSPDFSearchHighlightViewManager *searchHighlightViewManager;

/// Text extraction class for current document.
/// The delegate is set to this controller. Don't change but create your own text search class instead if you need a different delegate.
/// Will be recreated as the document changes. Returns nil if the document is nil. Thread safe.
@property (nonatomic, strong, readonly) PSPDFTextSearch *textSearch;


/// @name HUD Controls

/// View that is displayed as HUD.
/// The `HUDView` is created in viewDidLoad.
@property (nonatomic, strong, readonly) PSPDFHUDView *HUDView;

/// Show or hide HUD controls, titlebar, status bar (depending on the appearance properties).
@property (nonatomic, assign, getter=isHUDVisible) BOOL HUDVisible;

/// Allows to temporarily override the `HUDViewMode` setting in the configuration.
@property (nonatomic, assign) BOOL shouldAlwaysShowHUD;

/// Show or hide HUD controls. optionally animated.
- (BOOL)setHUDVisible:(BOOL)show animated:(BOOL)animated;

/// Show the HUD. Respects `HUDViewMode`.
- (BOOL)showControlsAnimated:(BOOL)animated;

/// Hide the HUD. Respects `HUDViewMode`.
- (BOOL)hideControlsAnimated:(BOOL)animated;

/// Hide the HUD (respects `HUDViewMode`) and additional elements like page selection.
- (BOOL)hideControlsAndPageElementsAnimated:(BOOL)animated;

/// Toggles the HUD. Respects `HUDViewMode`.
- (BOOL)toggleControlsAnimated:(BOOL)animated;

/// Content view. Use this if you want to add any always-visible UI elements.
/// Created in `viewDidLoad.` `contentView` is behind `HUDView` but always visible.
/// ContentView does NOT overlay the `navigationBar`/`statusBar`, even if that one is transparent.
@property (nonatomic, strong, readonly) PSPDFRelayTouchesView *contentView;

/// The navigationBar is animated. Check this to get the proper value, even if `navigationBar.navigationBarHidden` is not yet set (but will be in the animation block)
@property (nonatomic, assign, getter=isNavigationBarHidden, readonly) BOOL navigationBarHidden;

/// Locks the current set rotation. Defaults to NO.
/// If set to false, it invokes an `attemptRotationToDeviceOrientation`.
/// @warning Rotation lock is application-global, even when the controller isn't displayed.
@property (nonatomic, assign, getter=isRotationLockEnabled) BOOL rotationLockEnabled;

/// @name Class Accessors

/// Return the pageView for a given page. Returns nil if page is not Initialized (e.g. page is not visible.)
/// Usually, using the delegates is a better idea to get the current page.
- (PSPDFPageView *)pageViewForPage:(NSUInteger)page;

/// Paging scroll view. (hosts scroll views for PDF)
/// If you want to customize this, override `reloadData` and set the properties after calling super.
@property (nonatomic, strong, readonly) UIScrollView *pagingScrollView;


/// @name Thumbnail View

/// Get or set the current view mode. (`PSPDFViewModeDocument` or `PSPDFViewModeThumbnails`)
@property (nonatomic, assign) PSPDFViewMode viewMode;

/// Set the view mode, optionally animated.
- (void)setViewMode:(PSPDFViewMode)viewMode animated:(BOOL)animated;

/// Thumbnail controller. Contains the (grid) collectionView. Lazily created.
@property (nonatomic, strong) PSPDFThumbnailViewController *thumbnailController;


/// @name Helpers

/// Return an NSNumber-Array of currently visible page numbers.
/// @warning This might return more numbers than actually visible if it's queried during a scroll animation.
- (NSOrderedSet *)visiblePageNumbers;

/// Return array of all currently visible `PSPDFPageView` objects.
- (NSArray *)visiblePageViews;

/// Depending on pageMode, this returns true if two pages are displayed.
- (BOOL)isDoublePageMode;

/// Returns YES if the document is at the last page.
- (BOOL)isLastPage;

/// Returns YES if the document is at the first page.
- (BOOL)isFirstPage;

@end

@interface PSPDFViewController (Configuration)

/// The configuration. Defaults to `+[PSPDFConfiguration defaultConfiguration]`.
/// @warning You cannot set this property to `nil` since the pdf controller must always have a configuration.
@property (nonatomic, copy, readonly) PSPDFConfiguration *configuration;

/// Allows to change any value within `PSPDFConfiguration` and correctly updates the state in the controller.
- (void)updateConfigurationWithBuilder:(void (^)(PSPDFConfigurationBuilder *builder))builderBlock;

/// Allows to update the configuration without triggering a reload.
/// @warning You should know what you're doing with using this updater.
/// The `PSPDFViewController` will not be reloaded, which can bring it into a invalid state.
/// Use this for properties that don't require reloading such as `textSelectionEnabled` or `scrollOnTapPageEndEnabled`.
- (void)updateConfigurationWithoutReloadingWithBuilder:(void (^)(PSPDFConfigurationBuilder *builder))builderBlock;

@end

@interface PSPDFViewController (Presentation)

typedef NS_ENUM(NSUInteger, PSPDFPresentationStyle) {
    PSPDFPresentationStyleDefault,  /// Chooses automatically
    PSPDFPresentationStyleModal,    /// Always presents the view controller modally
    PSPDFPresentationStylePopover,  /// Always presents the view controller in a popover (even for `UIUserInterfaceSizeClassCompact`)
    PSPDFPresentationStyleHalfModal /// Presents the view controller in a half modal mode (`UIUserInterfaceSizeClassCompact` only)
};

// Presentation style.
extern NSString *const PSPDFPresentationStyleKey;                  // See `PSPDFPresentationStyle`.
extern NSString *const PSPDFPresentationModalStyleKey;             // See `UIModalPresentationStyle`.

// Persistent hooks for dismissal.
extern NSString *const PSPDFPresentationWillDismissBlockKey;        // Block called when the controller is being dismissed.
extern NSString *const PSPDFPresentationDidDismissBlockKey;         // Block called when the controller has been dismissed.

// `UIPopoverController` specific.
extern NSString *const PSPDFPresentationRectKey;                    // Target rect, if sender is nil for `UIPopoverController`
extern NSString *const PSPDFPresentationContentSizeKey;             // Content size for `UIPopoverController` or for `UIModalPresentationFormSheet`.
extern NSString *const PSPDFPresentationPopoverArrowDirectionsKey;  // Customize default arrow directions for popover.
extern NSString *const PSPDFPresentationPopoverPassthroughViewsKey; // Customize the popover click-through views.

// Navigation Controller and close button logic.
extern NSString *const PSPDFPresentationInNavigationControllerKey;  // Set to YES to embedd the controller into a navigation controller.
extern NSString *const PSPDFPresentationCloseButtonKey;             // Set to YES to add a close button.
extern NSString *const PSPDFPresentationPersistentCloseButtonKey;   // See `PSPDFPersistentCloseButtonMode`

/// Show a modal view controller or a popover with automatically added close button on the left side.
/// Use sender (`UIBarButtonItem` or `UIView`) OR rect in options (both only needed for the popover)
- (id)presentViewController:(UIViewController *)controller options:(NSDictionary *)options animated:(BOOL)animated sender:(id)sender completion:(void (^)(void))completion;

/// Dismiss popover if it matches `class`. Set class to nil to dismiss all popover types.
/// @note Will also dismiss the half modal controller.
- (BOOL)dismissPopoverAnimated:(BOOL)animated class:(Class)popoverClass completion:(void (^)(void))completion;

/// Dismisses a view controller or popover controller, if class matches.
- (void)dismissViewControllerAnimated:(BOOL)animated class:(Class)controllerClass completion:(void (^)(void))completion;

/// Saves the popoverController if currently displayed.
/// @note PSPDFKit also sometimes shows controls that internally are a popover but don't expose it, like the `UIActionSheet` or the `UIPrintInteractionController`. You can dismiss those popovers with calling `[PSPDFBarButtonItem dismissPopoverAnimated:]`.
@property (nonatomic, strong) UIPopoverController *popoverController;

/// On iPhone, some controllers are displayed "half modal" as split screen and are saved here.
@property (nonatomic, strong) UIViewController *halfModalController;

@end

@interface PSPDFViewController (Annotations)

/// A convenience accessor for a pre-configured, persistent, annotation state manager for the controller.
@property (nonatomic, strong, readonly) PSPDFAnnotationStateManager *annotationStateManager;

@end

@interface PSPDFViewController (Toolbar)

/// @name Toolbar button items

/// Default button in leftBarButtonItems if view is presented modally.
/// @note You can change the button/icons with using the subclassing system:
/// `[self overrideClass:PSPDFCloseBarButtonItem.class withClass:MyCustomButtonSubclass.class]`
@property (nonatomic, strong, readonly) PSPDFCloseBarButtonItem *closeButtonItem;

/// Presents the `PSPDFOutlineViewController` if there is an outline defined in the PDF.
/// @note Also available as activity via `PSPDFActivityTypeOutline`.
@property (nonatomic, strong, readonly) PSPDFOutlineBarButtonItem *outlineButtonItem;

/// Presents the `PSPDFSearchViewController` or the `PSPDFInlineSearchManager`
/// for searching text in the current `document`.
/// @see `PSPDFSearchMode` in `PSPDFConfiguration` to configure this.
/// @note Also available as activity via `PSPDFActivityTypeSearch`.
@property (nonatomic, strong, readonly) PSPDFSearchBarButtonItem *searchButtonItem;

/// Toggles between the document and the thumbnail view state. (See `PSPDFViewMode` and `setViewMode:animated:`)
@property (nonatomic, strong, readonly) PSPDFViewModeBarButtonItem *viewModeButtonItem;

/// Presents the `UIPrintInteractionController` for document printing.
/// @note Only displayed if document is allowed to be printed (see `allowsPrinting` in `PSPDFDocument`)
/// @note You should use the `activityButtonItem` instead (`UIActivityTypePrint`).
@property (nonatomic, strong, readonly) PSPDFPrintBarButtonItem *printButtonItem;

/// Presents the `UIDocumentInteractionController` controller to open documents in other apps.
/// @note You should use the `activityButtonItem` instead (`PSPDFActivityTypeOpenIn`).
@property (nonatomic, strong, readonly) PSPDFOpenInBarButtonItem *openInButtonItem;

/// Presents the `MFMailComposeViewController` to send the document via email.
/// @note Will only work when sending emails is configured on the device.
/// @note You should use the `activityButtonItem` instead (`UIActivityTypeMail`).
@property (nonatomic, strong, readonly) PSPDFEmailBarButtonItem *emailButtonItem;

/// Presents the `MFMessageComposeViewController` to send the document via SMS/iMessage.
/// @note Will only work if iMessage or SMS is configured on the device.
/// @note You should use the `activityButtonItem` instead (`UIActivityTypeMessage`).
@property (nonatomic, strong, readonly) PSPDFMessageBarButtonItem *messageButtonItem;

/// Shows and hides the `PSPDFAnnotationToolbar` toolbar for creating annotations.
/// @note Requires the `PSPDFFeatureMaskAnnotationEditing` feature flag.
@property (nonatomic, strong, readonly) PSPDFAnnotationBarButtonItem *annotationButtonItem;

/// Presents the `PSPDFBookmarkViewController` for creating/editing/viewing bookmarks.
/// @note Also available as activity via `PSPDFActivityTypeBookmarks`.
@property (nonatomic, strong, readonly) PSPDFBookmarkBarButtonItem *bookmarkButtonItem;

/// Presents the `PSPDFBrightnessViewController` to control screen brightness.
/// @note iOS has a similar feature in the control center, but PSPDFKit brightness includes an additional software brightener.
@property (nonatomic, strong, readonly) PSPDFBrightnessBarButtonItem *brightnessButtonItem;

/// Presents the `UIActivityViewController` for various actions, including many of the above button items.
/// See `applicationActivities` in `PSPDFActivityBarButtonItem` for details.
@property (nonatomic, strong, readonly) PSPDFActivityBarButtonItem *activityButtonItem;

/// If added to `leftBarButtonItems` or `rightBarButtonItems`, the position of the
/// `additionalActionsButtonItem` action button can be customized.
/// By default this button is added to the `rightBarButtonItems` on the leftmost position.
/// The button only visible if `additionalActionsButtonItem.count > 1`.
/// @note Most implementations should use the more modern `activityButtonItem` instead.
/// @warning Do not add this to `additionalActionsButtonItem`.
@property (nonatomic, strong, readonly) PSPDFMoreBarButtonItem *additionalActionsButtonItem;

/// Bar button items displayed at the left of the toolbar. Must be `UIBarButtonItem` or `PSPDFBarButtonItem` instances. Defaults to `[closeButtonItem]` if view is presented modally.
/// @warning UIKit limits the left toolbar size if space is low in the toolbar, potentially cutting off buttons in those toolbars if the title is also too long. You can either reduce the number of buttons, cut down the text or use a titleView to fix this problem. It also appears that UIKit focuses on the leftToolbar, the right one is cut off much later. This problem only appears on the iPad in portrait mode. You can also use `updateSettingsForRotation:` to adapt the toolbar for portrait/landscape mode.
/// @note If you use any of the provided bar button items in a custom toolbar, make sure to set `leftBarButtonItems` and `rightBarButtonItems` to nil - an `UIBarButtonItem` can only ever have one parent, else some icons might "vanish" from your toolbar.
@property (nonatomic, copy) NSArray *leftBarButtonItems;

/// Bar button items displayed at the right of the toolbar. Must be `UIBarButtonItem` or `PSPDFBarButtonItem` instances.
/// Defaults to `@[self.searchButtonItem, self.outlineButtonItem, self.viewModeButtonItem]`;
/// @note If you use any of the provided bar button items in a custom toolbar, make sure to set `leftBarButtonItems` and `rightBarButtonItems` to nil - an `UIBarButtonItem` can only ever have one parent, else some icons might "vanish" from your toolbar.
@property (nonatomic, copy) NSArray *rightBarButtonItems;

/// Displayed at the left of the rightBarButtonItems inside an action sheet. Items must be `PSPDFBarButtonItem` instances.
/// If `additionalRightToolbarButtonItems.count == 1` then no action sheet is displayed
@property (nonatomic, copy) NSArray *additionalBarButtonItems; // defaults to nil

/// Add your custom `UIBarButtonItems` so that they won't be automatically enabled/disabled.
/// @note You really want to add your custom close/back button there, else the user might get stuck!
/// @warning This needs to be set BEFORE setting left/rightBarButtonItems.
@property (nonatomic, copy) NSArray *barButtonItemsAlwaysEnabled;

@end

@interface PSPDFViewController (SubclassingHooks)

/// Override this initializer to allow all use cases (storyboard loading, etc)
/// @warning Do not call this method directly, except for calling super when overriding it.
- (void)commonInitWithDocument:(PSPDFDocument *)document configuration:(PSPDFConfiguration *)configuration NS_REQUIRES_SUPER;

// Executes a PDF action. (open link, email, page, document, etc)
// `page` is the page where the current action is. If not available, use `pdfController.page`.
// `actionContainer` might be nil, but usually it's the annotation that owns the action.
- (BOOL)executePDFAction:(PSPDFAction *)action inTargetRect:(CGRect)targetRect forPage:(NSUInteger)page animated:(BOOL)animated actionContainer:(id)actionContainer;

/// Override if you're changing the toolbar to your own.
/// The toolbar is only displayed, if `PSPDFViewController` is inside a `UINavigationController`.
- (void)updateToolbarAnimated:(BOOL)animated;

/// Request to update a specific barButton. Might be more efficient than using createToolbar.
- (void)updateBarButtonItem:(UIBarButtonItem *)barButtonItem animated:(BOOL)animated;

/// Called in `viewWillLayoutSubviews` and `willRotateToInterfaceOrientation:`.
- (void)setUpdateSettingsForBoundsChangeBlock:(void (^)(PSPDFViewController *pdfController))block;

/// Access internal `UIViewController` for displaying the PDF content
@property (nonatomic, strong, readonly) UIViewController<PSPDFTransitionProtocol> *pageTransitionController;

// Return rect of the content view area excluding translucent toolbar/statusbar.
// This will even return the correctly compensated statusBar if that one is currently not visible.
- (CGRect)contentRect;

/// Will return the annotation toolbar if one is currently visible.
- (PSPDFAnnotationToolbar *)visibleAnnotationToolbar;

// Called when a PDF action requests to load a new document in a new controller (modally).
// Will copy all important settings from the current controller to the new controller.
- (PSPDFViewController *)createNewControllerForDocument:(PSPDFDocument *)document;

// Return page numbers that are visible. Only returns the current set page in continuous scroll mode
// Useful to get exact pages for double page mode.
- (NSArray *)calculatedVisiblePageNumbers;

// Reload a specific page.
- (void)updatePage:(NSUInteger)page animated:(BOOL)animated;

@end
