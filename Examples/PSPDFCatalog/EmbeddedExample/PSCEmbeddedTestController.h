//
//  PSPDFEmbeddedTestController.h
//  PSPDFCatalog
//
//  Copyright 2011-2013 Peter Steinberger. All rights reserved.
//

/// Exmaple how to correctly embedd (in an iOS4 compatible way) the view controller within another view controller.
@interface PSCEmbeddedTestController : UIViewController

- (IBAction)appendDocument;
- (IBAction)replaceDocument;
- (IBAction)clearCache;

@property (nonatomic, strong) PSPDFViewController *pdfController;

@end
