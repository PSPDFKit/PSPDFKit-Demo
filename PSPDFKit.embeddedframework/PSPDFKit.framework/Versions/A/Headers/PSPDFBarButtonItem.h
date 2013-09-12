//
//  PSPDFBarButtonItem.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"

@class PSPDFViewController;

/**
 Custom subclass that handles a UIBarButtonItem within the UINavigationBar of PSPDFViewController.

 The toolbar system in PSPDFViewController is designed to work with both stock UIBarButtonItem and PSPDFBarButtonItem; but if you want to use additionalRightBarButtonItems (where the items are listed inside a UIActionSheet) you must use a subclass of PSPDFBarButtonItem.

 PSPDFBarButtonItem also gives you access to the pdfController and ways to dynamically enable/disable your icon.

 Call updateBarButtonItem:animated: if you need to change tie image/customView/systemImage after the barButton has been displayed.

 Do not change target/selector - if the case of UIActionSheet/moreButton we call target/selector of the selected barButtonItem but with the sender argument of the PSPDFMoreBarButtonItem. This is needed to get the correct coordinates in case a UIPopoverController follows (which will originate from that moreBarButtonItem). If you override target/selector to something generic, you'll never know what button has been selected.
 */
@interface PSPDFBarButtonItem : UIBarButtonItem <NSCopying>

/// Global helper to dismiss any open popover handled by PSPDFViewController.
/// This will even dismiss popovers that don't expose their popover, such as UIActionSheet or UIPrintInteractionController.
+ (BOOL)dismissPopoverAnimated:(BOOL)animated completion:(dispatch_block_t)completion;

/// Returns if any of the bar button items is active. Takes UIKit-managed popovers into account.
+ (BOOL)isPopoverVisible;

/// Init with pdfController reference (later calls presentModalViewController:embeddedInNavigationController:withCloseButton:animated:)
- (id)initWithPDFViewController:(PSPDFViewController *)pdfViewController;

/// Attached PDF controller. (weak, do not use KVO on it!)
@property (nonatomic, weak) PSPDFViewController *pdfController;

/// Implement customView, image or systemItem in your subclass. (via overriding the method)
- (UIView *)customView;
- (UIImage *)image;

/// Defaults to (UIBarButtonSystemItem)-1. If you want to e.g. override the searchBarButtonItem that uses a system item, you need to override the PSPDFSearchBarButtonItem class, register it at overrideClassNames, return (UIBarButtonSystemItem)-1 here and implement image/landscapeImagePhone.
- (UIBarButtonSystemItem)systemItem;

/// Optional. Used if image is set.
- (UIImage *)landscapeImagePhone;

/// Always implement actionName in your subclass.
/// This is needed to list the action in additionalRightBarButtonItems in an ActionSheet.
- (NSString *)actionName;

/// Override if you want something different than UIBarButtonItemStylePlain
- (UIBarButtonItemStyle)itemStyle;

/// Defaults to YES. Override if the bar button may not be available.
/// Unavailable buttons will not be displayed in the toolbar.
/// Can also be used to hide some options when the grid is displayed.
/// e.g. return self.pdfController.document.isValid && self.pdfController.viewMode == PSPDFViewModeDocument;
- (BOOL)isAvailable;

/// PSPDFBarButtonItem also supports long-press actions. Defaults to NO.
- (BOOL)isLongPressActionAvailable;

/// Will be called when the pdfViewController updates the toolbar.
/// Default implementation determines if the button action can currently be invoked.
/// Defaults to enabled, as long as a document is set and valid on pdfViewController.
- (void)updateBarButtonItem;

// LongPresses are handled in the same way as default presses (call presentAnimated:sender: and dismissAnimated:), just while the long press action is going the flag isLongPressActionActive is set to YES.
- (BOOL)isLongPressActionActive;

/// Return a UIPopoverController if you presented a popover or a "parent" object if you indirectly presented a popover controller
/// Sender can be either a UIBarButtonItem or a generic view.
- (id)presentAnimated:(BOOL)animated sender:(id)sender;
- (BOOL)dismissAnimated:(BOOL)animated completion:(dispatch_block_t)completion;
- (void)didDismiss;

/// Use if presentModal needs to return nil because of a long-running process.
/// Use this to correctly set up barButton dismissal logic for non-popover controls (e.g. UIDocumentInteractionController)
- (void)setPresentedObject:(id)presentedObject sender:(id)sender;

/// Helper method to present and dismiss a view controller inside a popover controller on iPad or modally on iPhone.
- (id)presentModalOrInPopover:(UIViewController *)viewController sender:(id)sender;
- (BOOL)dismissModalOrPopoverAnimated:(BOOL)animated completion:(dispatch_block_t)completion;

/**
 Peeks into certain Apple classes to get the internal UIPopoverController. (e.g. UIPrintInteractionController. I've written rdars to allow access to the internal popoverController - but this is the best way in the mean time)

 @warning Returns nil if operation fails or PSPDFKIT_DONT_USE_OBFUSCATED_PRIVATE_API is set. (It's coded very defensively and this failing will just result in a minor UX degradation)
 */
+ (UIPopoverController *)popoverControllerForObject:(id)object;

/// Subclass to build a completely custom action, overriding the default present/dismiss calls.
/// @warning sender needs to be a *visible* bar button item or view.
- (void)action:(id)sender;

/// Subclass to react on long press events. Only invoked if isLongPressActionAvailable is set to YES.
- (void)longPressAction:(PSPDFBarButtonItem *)sender;

// UIActionSheet support.
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, assign, getter=isDismissingSheet) BOOL dismissingSheet;

@end
