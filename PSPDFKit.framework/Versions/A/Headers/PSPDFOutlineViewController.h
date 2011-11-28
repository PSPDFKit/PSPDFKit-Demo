//
//  PSPDFOutlineViewController.h
//  PSPDFKit
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

/// Outline (Table of Contents) parser.
@interface PSPDFOutlineViewController : UITableViewController <PSPDFCacheDelegate>

/// initializes outline parser with document and pdfController. There is only one outline per document.
- (id)initWithDocument:(PSPDFDocument *)document pdfController:(PSPDFViewController *)pdfController;

/// Array of PSPDFOutlineElements
@property(nonatomic, retain) NSArray *outline;

@end
