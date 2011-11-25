//
//  PSPDFBasicViewController.h
//  PSPDFKitExample
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#define kDismissActivePopover @"kDismissActivePopover"

@interface PSPDFBasicViewController : UIViewController <UIPopoverControllerDelegate>

@property (nonatomic, assign, readonly, getter=isVisible) BOOL visible;

@property (nonatomic, strong) UIPopoverController *popoverController;

@end
