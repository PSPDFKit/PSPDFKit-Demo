//
//  PSCVerticalAnnotationToolbar.h
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

// Example how to add a always-visible vertical toolbar
// Internally uses PSPDFAnnotationToolbar for adding the annotations.
@interface PSCVerticalAnnotationToolbar : UIView

- (id)initWithPDFController:(PSPDFViewController *)pdfController;

@property (nonatomic, weak) PSPDFViewController *pdfController;

@end
