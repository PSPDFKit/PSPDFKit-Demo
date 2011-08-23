//
//  SplitMasterViewController.h
//  EmbeddedExample
//
//  Created by Peter Steinberger on 8/22/11.
//  Copyright (c) 2011 Peter Steinberger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PSPDFKit/PSPDFKit.h>

@interface SplitMasterViewController : UIViewController <UISplitViewControllerDelegate> {
    PSPDFViewController *pdfController_;
    UIPopoverController *masterPopoverController_;
}

- (void)displayDocument:(PSPDFDocument *)document;

@end
