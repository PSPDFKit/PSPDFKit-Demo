//
//  PSPDFExtendedPopoverController.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

@protocol PSPDFPopoverControllerDismissable <NSObject>

/// Called *before* the popover dismiss animation starts.
- (void)willDismissPopover:(UIPopoverController *)popover animated:(BOOL)animated;

@end

/// Supports early notifying of the content controller that we're going to be dismissed.
/// e.g. Used to improve animation of the keyboard dismissing.
@interface PSPDFExtendedPopoverController : UIPopoverController

/// Action that is invoked before the popover hides. (programmatially or via user action)
@property (nonatomic, copy) dispatch_block_t popoverWillDismissAction;

/// Call to manually invoke delegate sending.
/// Due to the nature of the callback we currently don't actually know the animated state.
- (void)notifyContentControllerAboutDismissalAnimated:(BOOL)animated;

@end
