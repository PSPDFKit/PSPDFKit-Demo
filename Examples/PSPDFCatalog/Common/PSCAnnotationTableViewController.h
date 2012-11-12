//
//  PSCAnnotationTableViewController.h
//  PSPDFCatalog
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

/// Display all annotations of the current document.
@interface PSCAnnotationTableViewController : UITableViewController

/// Designated initializer.
- (id)initWithPDFViewController:(PSPDFViewController *)pdfController;

/// Attached PDF controller.
@property (nonatomic, weak) PSPDFViewController *pdfController;

/// Enable to hide more common link annotations.
@property (nonatomic, assign) BOOL hideLinkAnnotations;

@end
