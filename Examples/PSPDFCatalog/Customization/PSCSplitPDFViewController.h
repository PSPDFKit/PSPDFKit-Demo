//
//  PSCSplitPDFViewController.h
//  PSPDFCatalog
//
//  Copyright (c) 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

// Enable this to simulate improper document usage and test high-load sitations.
// Only useful for development.
#define PSCEnableDocumentStressTest 0

@interface PSCSplitPDFViewController : PSPDFViewController <UISplitViewControllerDelegate, PSPDFViewControllerDelegate>

@property (nonatomic, strong, readonly) UIPopoverController *masterPopoverController;

- (void)displayDocument:(PSPDFDocument *)document page:(NSUInteger)pageIndex;

@end
