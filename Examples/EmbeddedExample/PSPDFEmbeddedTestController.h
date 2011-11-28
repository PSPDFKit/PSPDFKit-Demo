//
//  PSPDFEmbeddedTestController.h
//  EmbeddedExample
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

@interface PSPDFEmbeddedTestController : UIViewController

- (IBAction)appendDocument;
- (IBAction)replaceDocument;
- (IBAction)clearCache;

@property(nonatomic, retain) PSPDFViewController *pdfController;

@end
