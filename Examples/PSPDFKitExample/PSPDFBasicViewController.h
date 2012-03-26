//
//  PSPDFBasicViewController.h
//  PSPDFKitExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#define kDismissActivePopover @"kDismissActivePopover"

@interface PSPDFBasicViewController : PSPDFBaseViewController <UIPopoverControllerDelegate>

@property (nonatomic, strong) UIPopoverController *popoverController;

@end
