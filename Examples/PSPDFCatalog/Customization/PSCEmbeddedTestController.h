//
//  PSPDFEmbeddedTestController.h
//  PSPDFCatalog
//
//  Copyright 2011-2013 Peter Steinberger. All rights reserved.
//

/// Example of how to correctly embed the view controller within another view controller.
@interface PSCEmbeddedTestController : UIViewController

- (IBAction)appendDocument;
- (IBAction)replaceDocument;
- (IBAction)clearCache;

@property (nonatomic, strong) PSPDFViewController *pdfController;

@end
