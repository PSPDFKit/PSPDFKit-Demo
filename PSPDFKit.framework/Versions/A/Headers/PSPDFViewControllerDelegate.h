//
//  PSPDFViewControllerDelegate.h
//  PSPDFKit
//
//  Created by Peter Steinberger on 7/14/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

@class PSPDFViewController, PSPDFDocument, PSPDFPageInfo, PSPDFPageCoordinates, PSPDFLinkAnnotation;

/// register to this delegate in PSPDFViewController
/// Note: page is based of 1 till pageCount
@protocol PSPDFViewControllerDelegate <NSObject>

@optional

#pragma global document handling
/// time to adjust PSPDFViewController before a PSPDFDocument is displayed
- (void)pdfViewController:(PSPDFViewController *)pdfController willDisplayDocument:(PSPDFDocument *)document;

/// delegate to be notified when pdfController finished loading
- (void)pdfViewController:(PSPDFViewController *)pdfController didDisplayDocument:(PSPDFDocument *)document;

#pragma events, annotations

/// deprecated. called same time as didShowPage
- (void)pdfViewController:(PSPDFViewController *)pdfController willShowPage:(NSUInteger)page __attribute__((deprecated)); // "use didShowPage instead, same functionality"

/// controller did show/scrolled to a new page (at least 51% of it is visible)
- (void)pdfViewController:(PSPDFViewController *)pdfController didShowPage:(NSUInteger)page;

/// page was fully rendered at zoomlevel = 1
- (void)pdfViewController:(PSPDFViewController *)pdfController didRenderPage:(NSUInteger)page pdfScrollView:(PSPDFScrollView *)pdfScrollView;

/// will be called when viewMode changes
- (void)pdfViewController:(PSPDFViewController *)pdfController didChangeViewMode:(PSPDFViewMode)viewMode;

/// if user tapped within page bounds, this will notify you.
/// return YES if this touch was processed by you and need no further checking by PSPDFKit.
/// Note that PSPDFPageInfo may has only page=1 if the optimization isAspectRatioEqual is enabled.
- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didTapOnPage:(NSUInteger)page info:(PSPDFPageInfo *)pageInfo coordinates:(PSPDFPageCoordinates *)pageCoordinates;

/// delegate for tapping on an annotation. If you don't implement this or return false, it will be processed by default action (scroll to page, ask to open Safari)
- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didTapOnAnnotation:(PSPDFLinkAnnotation *)annotation page:(NSUInteger)page info:(PSPDFPageInfo *)pageInfo coordinates:(PSPDFPageCoordinates *)pageCoordinates;

#pragma detailed control for page loading/unloading

/// called before a pdf page will be loaded and added to the pagingScrollView
- (void)pdfViewController:(PSPDFViewController *)pdfController willLoadPage:(NSUInteger)page pdfScrollView:(PSPDFScrollView *)pdfScrollView;

/// called after pdf page has been loaded and added to the pagingScrollView
- (void)pdfViewController:(PSPDFViewController *)pdfController didLoadPage:(NSUInteger)page pdfScrollView:(PSPDFScrollView *)pdfScrollView;

/// called before a pdf page will be unloaded and removed from the pagingScrollView
- (void)pdfViewController:(PSPDFViewController *)pdfController willUnloadPage:(NSUInteger)page pdfScrollView:(PSPDFScrollView *)pdfScrollView;

/// called after pdf page has been unloaded and removed from the pagingScrollView
- (void)pdfViewController:(PSPDFViewController *)pdfController didUnloadPage:(NSUInteger)page pdfScrollView:(PSPDFScrollView *)pdfScrollView;

@end
