//
//  PSCMergeDocumentsViewController.h
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

@import UIKit;

// Simple variant of a document merge UI to get you started.
// Designed for iOS 6 and iOS 7.
@interface PSCMergeDocumentsViewController : UIViewController

// Initialize with two documents, show them side-by-side
- (id)initWithLeftDocument:(PSPDFDocument *)leftDocument rightDocument:(PSPDFDocument *)rightDocument;

@property (nonatomic, strong, readonly) PSPDFDocument *leftDocument;
@property (nonatomic, strong, readonly) PSPDFDocument *rightDocument;

@end
