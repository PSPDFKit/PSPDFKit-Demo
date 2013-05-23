//
//  PSPDFPopoverController.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>

/// UIPopoverController compatible replacement for the iPhone.
/// This will work well for simple cases, but isn't as advanced as UIPopoverController.
@interface PSPDFPopoverController : UIViewController <UINavigationControllerDelegate>

/// The view controller provided becomes the content view controller for the UIPopoverController. This is the designated initializer for PSPDFPopoverController.
- (id)initWithContentViewController:(UIViewController *)viewController;

/// Delegate for popover dismissal.
@property (nonatomic, weak) IBOutlet id<UIPopoverControllerDelegate> delegate;

/// The content view controller is the `UIViewController` instance in charge of the content view of the displayed popover. This property can be changed while the popover is displayed to allow different view controllers in the same popover session.
@property (nonatomic, strong) UIViewController *contentViewController;

- (void)setContentViewController:(UIViewController *)viewController animated:(BOOL)animated;

/// This property allows direction manipulation of the content size of the popover. Changing the property directly is equivalent to animated=YES. The content size is limited to a minimum width of 320 and a maximum width of 600.
@property (nonatomic) CGSize popoverContentSize;

- (void)setPopoverContentSize:(CGSize)size animated:(BOOL)animated;

/// Returns whether the popover is visible (presented) or not.
@property (nonatomic, readonly, getter=isPopoverVisible) BOOL popoverVisible;

/// UIPopoverArrowDirectionAny, UIPopoverArrowDirectionVertical or UIPopoverArrowDirectionHorizontal for automatic arrow direction.
@property (nonatomic, assign) UIPopoverArrowDirection popoverArrowDirection;

/// An array of views that the user can interact with while the popover is visible.
@property (nonatomic, copy) NSArray *passthroughViews;

/// TintColor for the border. PSPDFKit addition.
@property (nonatomic, strong) UIColor *tintColor;

///  -presentPopoverFromRect:inView:permittedArrowDirections:animated: allows you to present a popover from a rect in a particular view. `arrowDirections` is a bitfield which specifies what arrow directions are allowed when laying out the popover; for most uses, `UIPopoverArrowDirectionAny` is sufficient.
- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)item permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated;

/// Like the above, but is a convenience for presentation from a `UIBarButtonItem` instance. arrowDirection limited to UIPopoverArrowDirectionUp/Down
- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated;

/// Called to dismiss the popover programmatically. The delegate methods for "should" and "did" dismiss are not called when the popover is dismissed in this way.
- (void)dismissPopoverAnimated:(BOOL)animated;

/// Call to manually invoke delegate sending. PSPDFKit extension.
- (void)notifyContentControllerAboutDismissalAnimated:(BOOL)animated;

/// NOP.
@property (nonatomic, readwrite) UIEdgeInsets popoverLayoutMargins;

// NOP.
@property (nonatomic, readwrite, strong) Class popoverBackgroundViewClass;

/// Action that is invoked before the popover hides. (programmatically or via user action)
@property (nonatomic, copy) dispatch_block_t popoverWillDismissAction;

@end
