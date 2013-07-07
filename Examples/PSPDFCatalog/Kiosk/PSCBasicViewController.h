//
//  PSCBasicViewController.h
//  PSPDFCatalog
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#define kDismissActivePopover @"kDismissActivePopover"

// Basic viewController subclass that handles popovers.
@interface PSCBasicViewController : PSPDFBaseViewController <UIPopoverControllerDelegate>

@property (nonatomic, strong) UIPopoverController *popoverController;

// Helper to close a modal view
- (void)closeModalView;

@end
