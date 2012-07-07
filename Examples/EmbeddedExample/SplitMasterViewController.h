//
//  SplitMasterViewController.h
//  EmbeddedExample
//
//  Copyright (c) 2011-2012 Peter Steinberger. All rights reserved.
//

@interface SplitMasterViewController : PSPDFViewController <UISplitViewControllerDelegate, PSPDFViewControllerDelegate>

- (void)displayDocument:(PSPDFDocument *)document;

@end
