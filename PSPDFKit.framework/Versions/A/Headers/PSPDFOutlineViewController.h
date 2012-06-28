//
//  PSPDFOutlineViewController.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFDocument, PSPDFViewController, PSPDFOutlineElement;

/// Outline (Table of Contents) parser.
@interface PSPDFOutlineViewController : UITableViewController

/// initializes outline parser with document and pdfController. There is only one outline per document.
- (id)initWithDocument:(PSPDFDocument *)document pdfController:(PSPDFViewController *)pdfController;

/// Array of PSPDFOutlineElements
@property(nonatomic, strong) PSPDFOutlineElement *outline;

@end
