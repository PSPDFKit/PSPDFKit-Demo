//
//  PSCSplitPDFViewController.h
//  PSPDFCatalog
//
//  Copyright (c) 2011-2013 Peter Steinberger. All rights reserved.
//

@interface PSCSplitPDFViewController : PSPDFViewController <UISplitViewControllerDelegate, PSPDFViewControllerDelegate>

@property (nonatomic, strong, readonly) UIPopoverController *masterPopoverController;

- (void)displayDocument:(PSPDFDocument *)document;

@end
