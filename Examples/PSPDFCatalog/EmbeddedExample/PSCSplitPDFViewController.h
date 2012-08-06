//
//  SplitMasterViewController.h
//  PSPDFCatalog
//
//  Copyright (c) 2011-2012 Peter Steinberger. All rights reserved.
//

@interface PSCSplitPDFViewController : PSPDFViewController <UISplitViewControllerDelegate, PSPDFViewControllerDelegate>

- (void)displayDocument:(PSPDFDocument *)document;

@end
