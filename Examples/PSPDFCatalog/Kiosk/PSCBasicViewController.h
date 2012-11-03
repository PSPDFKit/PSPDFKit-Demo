//
//  PSCBasicViewController.h
//  PSPDFCatalog
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#define kDismissActivePopover @"kDismissActivePopover"

// Basic viewController subclass that haldes popovers.
@interface PSCBasicViewController : PSPDFBaseViewController <UIPopoverControllerDelegate>

@property (nonatomic, strong) UIPopoverController *popoverController;

// Helper to close a modal view
- (void)closeModalView;

@end
