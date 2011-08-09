//
//  PSPDFViewControllerDelegate.h
//  PSPDFKit
//
//  Created by Peter Steinberger on 7/14/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

@class PSPDFViewController, PSPDFDocument, PSPDFPageInfo, PSPDFPageCoordinates, PSPDFLinkAnnotation;

/// register to this delegate in PSPDFViewController
@protocol PSPDFViewControllerDelegate <NSObject>

@optional

/// time to adjust PSPDFViewController before a PSPDFDocument is displayed
- (void)pdfViewController:(PSPDFViewController *)pdfController willDisplayDocument:(PSPDFDocument *)document;

/// controller will be displaying a certain page
- (void)pdfViewController:(PSPDFViewController *)pdfController willShowPage:(NSUInteger)page;

/// if user tapped within page bounds, this will notify you.
/// return YES if this touch was processed by you and need no further checking by PSPDFKit.
/// Note that PSPDFPageInfo may has only page=1 if the optimization isAspectRatioEqual is enabled.
- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didTapOnPage:(NSUInteger)page info:(PSPDFPageInfo *)pageInfo coordinates:(PSPDFPageCoordinates *)pageCoordinates;

/// delegate for tapping on an annotation. If you don't implement this or return false, it will be processed by default action (scroll to page, ask to open Safari)
- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didTapOnAnnotation:(PSPDFLinkAnnotation *)annotation page:(NSUInteger)page info:(PSPDFPageInfo *)pageInfo coordinates:(PSPDFPageCoordinates *)pageCoordinates;

/// will be called when viewMode changes
- (void)pdfViewController:(PSPDFViewController *)pdfController didChangeViewMode:(PSPDFViewMode)viewMode;

@end
