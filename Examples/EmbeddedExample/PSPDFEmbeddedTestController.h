//
//  PSPDFEmbeddedTestController.h
//  EmbeddedExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

/// Exmaple how to correctly embedd (in an iOS4 compatible way) the view controller within another view controller.
@interface PSPDFEmbeddedTestController : UIViewController

- (IBAction)appendDocument;
- (IBAction)replaceDocument;
- (IBAction)clearCache;
- (IBAction)oldContainmentTest;

@property(nonatomic, strong) PSPDFViewController *pdfController;

@end
