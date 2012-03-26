//
//  PSPDFOutlineViewController.h
//  PSPDFKit
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSPDFCache.h"

@class PSPDFDocument, PSPDFViewController;

/// Outline (Table of Contents) parser.
@interface PSPDFOutlineViewController : UITableViewController

/// initializes outline parser with document and pdfController. There is only one outline per document.
- (id)initWithDocument:(PSPDFDocument *)document pdfController:(PSPDFViewController *)pdfController;

/// Array of PSPDFOutlineElements
@property(nonatomic, strong) PSPDFOutlineElement *outline;

/// If presented within a popoverController, it can be accessed here.
@property(nonatomic, ps_weak) UIPopoverController *popoverController;

@end
