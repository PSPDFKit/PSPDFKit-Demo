//
//  PSCBasicViewController.h
//  PSPDFCatalog
//
//  Copyright (c) 2011-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#define kDismissActivePopover @"kDismissActivePopover"

// Basic viewController subclass that handles popovers.
@interface PSCBasicViewController : PSPDFBaseViewController <UIPopoverControllerDelegate>

// The popover controller.
@property (nonatomic, strong) UIPopoverController *popoverController;

// Helper to close a modal view
- (void)closeModalView;

@end
