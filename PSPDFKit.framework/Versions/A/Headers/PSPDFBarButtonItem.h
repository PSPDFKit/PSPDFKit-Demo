//
//  PSPDFBarButtonItem.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import <UIKit/UIKit.h>

@class PSPDFViewController;

@interface PSPDFBarButtonItem : UIBarButtonItem <UIPopoverControllerDelegate>

+ (void)dismissPopoverAnimated:(BOOL)animated;
+ (BOOL)isPopoverVisible;

/// Init with pdfController reference (later calls presentModalViewController:withCloseButton:animated:)
- (id)initWithPDFViewController:(PSPDFViewController *)pdfViewController;

@property (nonatomic, ps_weak, readonly) PSPDFViewController *pdfViewController;

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

@end
