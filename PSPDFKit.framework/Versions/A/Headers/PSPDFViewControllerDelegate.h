//
//  PSPDFViewControllerDelegate.h
//  PSPDFKit
//
//  Created by Peter Steinberger on 7/14/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

@class PSPDFViewController, PSPDFDocument;

@protocol PSPDFViewControllerDelegate

// time to adjust PSPDFViewController before a PSPDFDocument is displayed
- (void)pdfViewController:(PSPDFViewController *)pdfController willDisplayDocument:(PSPDFDocument *)document;

// controller will be displaying a certain page
- (void)pdfViewController:(PSPDFViewController *)pdfController willShowPage:(NSUInteger)page;

// if user tapped within page bounds, this will notify you.
// return YES if this touch was processed by you and need no further checking by PSPDFKit.
- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didTapOnPage:(NSUInteger)page atPoint:(CGPoint)point pageSize:(CGSize)pageSize;

@end
