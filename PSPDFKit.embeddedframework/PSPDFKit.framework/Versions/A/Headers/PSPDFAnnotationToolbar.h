//
//  PSPDFAnnotationToolbar.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFLineHelper.h"
#import "PSPDFAnnotationStateManager.h"
#import "PSPDFViewController.h"

// Compatiblity with Xcode 4.6 / SDK 6 (as binary)
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 70000 && !defined(UIBarPosition)
#define UIBarPosition NSInteger
#endif

@class PSPDFAnnotationToolbar;

/// Delegate to be notified on toolbar actions/hiding.
@protocol PSPDFAnnotationToolbarDelegate <NSObject>

@optional

/// The annotation toolbar will be displayed.
- (void)annotationToolbarWillShow:(PSPDFAnnotationToolbar *)annotationToolbar;

/// The annotation toolbar has been displayed.
- (void)annotationToolbarDidShow:(PSPDFAnnotationToolbar *)annotationToolbar;

/// Called when the Done button has been pressed to hide the toolbar.
- (void)annotationToolbarWillHide:(PSPDFAnnotationToolbar *)annotationToolbar;

/// Called when the Done button has been pressed to hide the toolbar.
- (void)annotationToolbarDidHide:(PSPDFAnnotationToolbar *)annotationToolbar;

/// Called after a mode change is set (button pressed; drawing finished, etc)
- (void)annotationToolbar:(PSPDFAnnotationToolbar *)annotationToolbar didChangeMode:(NSString *)newMode;

@end

/// The annotation toolbar allows creation of most annotation types supported by PSPDFKit.
/// @note This class does a lot of state management, so you might also just use it in a headless state calling down to the various action methods expoxed in the SubclassingHooks category.
/// To customize which annotation icons should be displayed, edit `editableAnnotationTypes` in PSPDFDocument.
@interface PSPDFAnnotationToolbar : UIToolbar <PSPDFAnnotationStateManagerDelegate>

/// Designated initializer.
- (id)initWithAnnotationStateManager:(PSPDFAnnotationStateManager *)annotationStateManager;

/// Attached annotation state manager.
@property (nonatomic, strong) PSPDFAnnotationStateManager *annotationStateManager;

/// Base PDF view controller. A shortcut for annotationStateManager.pdfController.
/// @note If you update `tintColor`, `barStyle`, etc., on your `PSPDFViewController` -
/// call `matchAppearanceToPDFViewControllerAppearance:` to re-capture changed states.
@property (nonatomic, weak, readonly) PSPDFViewController *pdfController;

/// Annotation toolbar delegate. (Can be freely set to any receiver)
@property (nonatomic, weak) IBOutlet id<PSPDFAnnotationToolbarDelegate> annotationToolbarDelegate;

/// Parses the `editableAnnotationTypes` set from the document.
/// Per default this is the contents of the editableAnnotationTypes set in PSPDFDocument.
/// If set to nil, this will load from `pdfController.document.editableAnnotationTypes.allObjects`.
/// KVO observable.
@property (nonatomic, copy) NSOrderedSet *editableAnnotationTypes;

/// @name Presentation

/// Show the toolbar in target rect. Rect should be the same height as the toolbar. (44px)
/// You need to manually add the toolbar to the view. This is just to get the animation right.
- (void)showToolbarInRect:(CGRect)rect animated:(BOOL)animated;

/// Hide the toolbar.
/// You need to manually remove the toolbar from the view in the completion block, if the finished parameter is set to YES.
/// This is just to get the animation right.
/// @warning This will restore the `HUDViewMode` that was set when `showToolbarInRect:animated:` has been called.
- (void)hideToolbarAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completionBlock;

/// Flashes the toolbar red (e.g. if user tries to hide the HUD.)
- (void)flashToolbar;

/// Enable to cause the toolbar to fade in and out. Defaults to YES.
@property (nonatomic, assign) BOOL fadeToolbar;

/// Enable to cause the toolbar to slide into place. Defaults to YES.
/// @warning Only effective if `fadeToolbar` is set to YES.
@property (nonatomic, assign) BOOL slideToolbar;

/// @name Behavior

/// Enable to auto-hide toolbar after drawing finishes. Defaults to NO.
@property (nonatomic, assign) BOOL hideAfterDrawingDidFinish;

/// This will issue a save event after the toolbar has been dismissed.
/// @note Since saving can take some time, this defaults to NO.
@property (nonatomic, assign) BOOL saveAfterToolbarHiding;

/// @name Styling

/// Selected UIBarButtonItem tint color on iOS 7 and later.
/// Has no effect on previous system versions.
/// Defaults to `barTintColor`.
@property (nonatomic, strong) UIColor *selectedTintColor;

/// Selected `UIBarButtonItem` background bezel color.
/// Defaults to `tintColor` on iOS 7 and later and 50% white on previous versions.
@property (nonatomic, strong) UIColor *selectedBackgroundColor;

// Dictionary keys for annotation groups.
extern NSString *const PSPDFAnnotationGroupKeyChoice;
extern NSString *const PSPDFAnnotationGroupKeyGroup;

/// Annotations are grouped by default. Set to nil to disable grouping.
/// Groups are defined as dictionaries containing arrays of `editableAnnotationType`-objects, paired with an index indicating the current choice within each array.
/// Annotation types that are defined in the group but are missing in `annotationStateManager.editableAnnotationTypes` will be ignored silently.
/// Use `PSPDFAnnotationGroupKeyChoice` and `PSPDFAnnotationGroupKeyGroup` as constants to configure the array.
@property (nonatomic, copy) NSArray *annotationGroups;

/// Allows custom `UIBarButtonItem` objects to be added after the buttons in `annotationGroups`.
/// Defaults to nil.
/// @note Do not insert space objects - this is managed by PSPDFKit.
@property (nonatomic, copy) NSArray *additionalBarButtonItems;

/// Matches the toolbar appearance to the toolbar styles defined inside the pdf controller (`tintColor`, `barStyle`, etc.).
/// Called automatically when an annotation state manager is assigned and can be manually re-called to capture any PSPDFViewController style changes.
- (void)matchAppearanceToPDFViewControllerAppearance:(PSPDFViewController *)pdfController;

@end

@interface PSPDFAnnotationToolbar (SubclassingHooks)

// Instead of calling these buttons, it's better you use the `PSPDFAnnotationStateManager`.
- (void)textButtonPressed:(id)sender; // Note
- (void)highlightButtonPressed:(id)sender;
- (void)strikeoutButtonPressed:(id)sender;
- (void)underlineButtonPressed:(id)sender;
- (void)squigglyButtonPressed:(id)sender;
- (void)inkButtonPressed:(id)sender;
- (void)squareButtonPressed:(id)sender;
- (void)circleButtonPressed:(id)sender;
- (void)lineButtonPressed:(id)sender;
- (void)polygonButtonPressed:(id)sender;
- (void)polylineButtonPressed:(id)sender;
- (void)freetextButtonPressed:(id)sender;
- (void)signatureButtonPressed:(id)sender;
- (void)stampButtonPressed:(id)sender;
- (void)imageButtonPressed:(id)sender;
- (void)soundButtonPressed:(id)sender;
- (void)eraserButtonPressed:(id)sender;
- (void)selectiontoolButtonPressed:(id)sender;
- (void)colorButtonPressed:(id)sender;
- (void)doneButtonPressed:(id)sender NS_REQUIRES_SUPER;

// Called each time the toolbar items are re-set.
- (void)updateToolbarButtonsAnimated:(BOOL)animated;

/// Return the number of buttons allowed in the toolbar.
- (NSUInteger)allowedButtonCount;

/// Creates and returns a back button. Return your custom one that executes `@selector(doneButtonPressed:)` if you want to change the design.
- (UIBarButtonItem *)backButtonItem;

// Called anytime the drawing toolbar is taken down.
- (void)hideAndRemoveToolbarAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completionBlock;

/// By default, the toolbar position is top, so this defaults to `UIBarPositionTopAttached`.
/// Set to `UIBarPositionBottom` if you're showing the toolbar at the bottom.
/// @note This forwards to `positionForBar:` and is only evaluated in iOS 7 when the view is added to a window.
@property (nonatomic, assign) UIBarPosition barPosition;

// The Undo/Redo buttons.
@property (nonatomic, strong, readonly) UIBarButtonItem *undoButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *redoButtonItem;

@end


@interface PSPDFAnnotationToolbar (Deprecated)

- (void)setLastUsedColor:(UIColor *)lastUsedDrawColor annotationString:(NSString *)annotationString PSPDF_DEPRECATED(3.4.3, "Use PSPDFAnnotationStateManager instead.");
- (UIColor *)lastUsedColorForAnnotationString:(NSString *)annotationString PSPDF_DEPRECATED(3.4.3, "Use PSPDFAnnotationStateManager instead.");
;
@property (nonatomic, copy) NSString *toolbarMode PSPDF_DEPRECATED(3.4.3, "Use PSPDFAnnotationStateManager instead.");
;

@end
