//
//  PSCVerticalAnnotationToolbar.h
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

// Example how to add a always-visible vertical toolbar
// Internally uses PSPDFAnnotationToolbar for adding the annotations.
@interface PSCVerticalAnnotationToolbar : UIView

- (id)initWithPDFController:(PSPDFViewController *)pdfController;

@property (nonatomic, weak) PSPDFViewController *pdfController;

@end
