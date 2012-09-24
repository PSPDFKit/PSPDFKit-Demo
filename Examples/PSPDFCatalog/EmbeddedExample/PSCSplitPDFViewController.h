//
//  SplitMasterViewController.h
//  PSPDFCatalog
//
//  Copyright (c) 2011-2012 Peter Steinberger. All rights reserved.
//

@interface PSCSplitPDFViewController : PSPDFViewController <UISplitViewControllerDelegate, PSPDFViewControllerDelegate>

@property (nonatomic, strong, readonly) UIPopoverController *masterPopoverController;

- (void)displayDocument:(PSPDFDocument *)document;

@end
