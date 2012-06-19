//
//  SplitMasterViewController.h
//  EmbeddedExample
//
//  Created by Peter Steinberger on 8/22/11.
//  Copyright (c) 2011-2012 Peter Steinberger. All rights reserved.
//

@interface SplitMasterViewController : UIViewController <UISplitViewControllerDelegate, PSPDFViewControllerDelegate> {
    PSPDFViewController *_pdfController;
    UIPopoverController *masterPopoverController_;
}

- (void)displayDocument:(PSPDFDocument *)document;

@end
