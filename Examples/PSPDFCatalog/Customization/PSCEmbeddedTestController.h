//
//  PSPDFEmbeddedTestController.h
//  PSPDFCatalog
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

/// Example of how to correctly embed the view controller within another view controller.
@interface PSCEmbeddedTestController : UIViewController

- (IBAction)appendDocument;
- (IBAction)replaceDocument;
- (IBAction)clearCache;

@property (nonatomic, strong, readonly) PSPDFViewController *pdfController;

@end
