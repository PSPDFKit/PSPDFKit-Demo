//
//  PSPDFDocumentSelectorController.h
//  TabbedExample
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

@class PSPDFDocumentSelectorController;
@class PSPDFDocument;

@protocol PSPDFDocumentSelectorControllerDelegate <NSObject>

- (void)PDFDocumentSelectorController:(PSPDFDocumentSelectorController *)controller didSelectDocument:(PSPDFDocument *)document;

@end

/// Shows all documents available in the Sample directory.
@interface PSPDFDocumentSelectorController : UITableViewController

@property (nonatomic, weak) id<PSPDFDocumentSelectorControllerDelegate> delegate;

@end
