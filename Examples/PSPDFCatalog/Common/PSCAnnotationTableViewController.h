//
//  PSCAnnotationTableViewController.h
//  PSPDFCatalog
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

/// Display all annotations in the document
@interface PSCAnnotationTableViewController : UITableViewController

/// Designated initializer.
- (id)initWithPDFViewController:(PSPDFViewController *)pdfController;

/// Attached PDF controller.
@property (nonatomic, weak) PSPDFViewController *pdfController;

@end
