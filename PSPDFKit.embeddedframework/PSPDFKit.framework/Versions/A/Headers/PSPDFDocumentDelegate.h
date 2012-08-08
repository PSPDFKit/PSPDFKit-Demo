//
//  PSPDFDocumentDelegate.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
@class PSPDFViewController;

@protocol PSPDFDocumentDelegate <NSObject>

/// Allow resolving custom path tokens (Documents, Bundle are automatically resolved; you can add e.g. Book and resolve this here). Will only get called for unknown tokens.
- (NSString *)pdfDocument:(PSPDFDocument *)document resolveCustomAnnotationPathToken:(NSString *)pathToken; // return nil if unknown.

/*
 /// Called after an annotation has been created.
 - (void)pdfViewController:(PSPDFViewController *)pdfController didCreateAnnotation:(PSPDFAnnotation *)annotation onPageView:(PSPDFPageView *)pageView;

 /// Called after an annotation has been changed.
 - (void)pdfViewController:(PSPDFViewController *)pdfController didChangeAnnotation:(PSPDFAnnotation *)annotation onPageView:(PSPDFPageView *)pageView;

 /// Called after an annotation has been deleted.
 - (void)pdfViewController:(PSPDFViewController *)pdfController didDeleteAnnotation:(PSPDFAnnotation *)annotation onPageView:(PSPDFPageView *)pageView;
 */

@end
