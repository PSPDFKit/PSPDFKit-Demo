//
//  PSCSplitPDFViewController.h
//  PSPDFCatalog
//
//  Copyright (c) 2011-2013 Peter Steinberger. All rights reserved.
//

// Enable this to simulate improper document usage and test high-load sitations.
// Only useful for development.
#define kPSPDFEnableDocumentStressTest 0

@interface PSCSplitPDFViewController : PSPDFViewController <UISplitViewControllerDelegate, PSPDFViewControllerDelegate>

@property (nonatomic, strong, readonly) UIPopoverController *masterPopoverController;

- (void)displayDocument:(PSPDFDocument *)document;

@end
