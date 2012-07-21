//
//  PSPDFBarButtonItem.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFViewController;

@interface PSPDFBarButtonItem : UIBarButtonItem <UIPopoverControllerDelegate>

+ (void)dismissPopoverAnimated:(BOOL)animated;
+ (BOOL)isPopoverVisible;

/// Init with pdfController reference (later calls presentModalViewController:embeddedInNavigationController:withCloseButton:animated:)
- (id)initWithPDFViewController:(PSPDFViewController *)pdfViewController;

@property (nonatomic, unsafe_unretained, readonly) PSPDFViewController *pdfController;

/// Implement customView, image or systemItem in your subclass. Falls back to actionName.
- (UIView *)customView;
- (UIImage *)image;
- (UIBarButtonSystemItem)systemItem;

/// Optional. Used if image is set and iOS >= 5.
- (UIImage *)landscapeImagePhone;

/// Always implement actionName in your subclass.
- (NSString *)actionName;

/// Override if you want something diffent than UIBarButtonItemStylePlain
- (UIBarButtonItemStyle)itemStyle;

/// Defaults to YES. Override if the bar button may not be available.
/// Unavailable buttons will not be displayed in the toolbar.
- (BOOL)isAvailable;

/// Will be called when the pdfViewController updates the toolbar.
/// Default implementation determines if the button action can currently be invoked.
/// Defaults to enabled, as long as a document is set and valid on pdfViewController.
- (void)updateBarButtonItem;

/// must call super in subclasses if a popover is presented or dismissed
/// Return a UIPopoverController if you presented a popover or a "parent" object if you indirectly presented a popover controller
- (id)presentAnimated:(BOOL)animated sender:(PSPDFBarButtonItem *)sender;
- (void)dismissAnimated:(BOOL)animated;
- (void)didDismiss;

/// Helper method to present and dismiss a view controller inside a popover controller on iPad or modally on iPhone.
- (id)presentModalOrInPopover:(UIViewController *)viewController sender:(id)sender;
- (void)dismissModalOrPopoverAnimated:(BOOL)animated;

/// Peaks into certain Apple classes to get the internal UIPopoverController.
/// Note: returns nil if operation fails or PSPDFKIT_DONT_USE_OBFUSCATED_PRIVATE_API is set.
+ (UIPopoverController *)popoverControllerForObject:(id)object;

/// Subclass this to build a complete custom action.
/// By default, this calls present/dismissAnimated.
- (void)action:(PSPDFBarButtonItem *)sender;

@end
