//
//  PSPDFViewControllerDelegate.h
//  PSPDFKit
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

@class PSPDFViewController, PSPDFDocument, PSPDFPageInfo, PSPDFPageCoordinates, PSPDFAnnotation, PSPDFPageView;

/// register to this delegate in PSPDFViewController. Page is based of 1 till pageCount.
@protocol PSPDFViewControllerDelegate <NSObject>

@optional

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma - global document handling

/// time to adjust PSPDFViewController before a PSPDFDocument is displayed
- (void)pdfViewController:(PSPDFViewController *)pdfController willDisplayDocument:(PSPDFDocument *)document;

/// delegate to be notified when pdfController finished loading
- (void)pdfViewController:(PSPDFViewController *)pdfController didDisplayDocument:(PSPDFDocument *)document;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma - events

/// controller did show/scrolled to a new page (at least 51% of it is visible)
- (void)pdfViewController:(PSPDFViewController *)pdfController didShowPageView:(PSPDFPageView *)pageView;

/// page was fully rendered at zoomlevel = 1
- (void)pdfViewController:(PSPDFViewController *)pdfController didRenderPageView:(PSPDFPageView *)pageView;

/// will be called when viewMode changes
- (void)pdfViewController:(PSPDFViewController *)pdfController didChangeViewMode:(PSPDFViewMode)viewMode;

/// if user tapped within page bounds, this will notify you.
/// return YES if this touch was processed by you and need no further checking by PSPDFKit.
/// Note that PSPDFPageInfo may has only page=1 if the optimization isAspectRatioEqual is enabled.
- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didTapOnPage:(NSUInteger)page info:(PSPDFPageInfo *)pageInfo coordinates:(PSPDFPageCoordinates *)pageCoordinates;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma - annotations

/// delegate for tapping on an annotation. If you don't implement this or return false, it will be processed by default action (scroll to page, ask to open Safari)
- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didTapOnAnnotation:(PSPDFAnnotation *)annotation page:(NSUInteger)page info:(PSPDFPageInfo *)pageInfo coordinates:(PSPDFPageCoordinates *)pageCoordinates;

/// called before a annotation view is created and added to a page. Defaults to YES if not implemented.
/// if NO is returned, viewForAnnotation will not be called.
- (BOOL)pdfViewController:(PSPDFViewController *)pdfController shouldDisplayAnnotation:(PSPDFAnnotation *)annotation onPageView:(PSPDFPageView *)pageView;

/// allows adding custom annotations. Called on any handler that is not recognized by PSPDFKit.
/// If you want to replace PSPDFKit-Handler, use shouldDisplayAnnotation, return NO and add your annotation view to the pageView.
- (UIView *)pdfViewController:(PSPDFViewController *)pdfController viewForAnnotation:(PSPDFAnnotation *)annotation onPageView:(PSPDFPageView *)pageView;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma - detailed control for page loading/unloading

/// called after pdf page has been loaded and added to the pagingScrollView.
- (void)pdfViewController:(PSPDFViewController *)pdfController didLoadPageView:(PSPDFPageView *)pageView;

/// called before a pdf page will be unloaded and removed from the pagingScrollView.
- (void)pdfViewController:(PSPDFViewController *)pdfController willUnloadPageView:(PSPDFPageView *)pageView;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma - deprecated

/// Deprecated. Use the variant with PSPDFPageView instead.
- (void)pdfViewController:(PSPDFViewController *)pdfController didShowPage:(NSUInteger)page  __attribute__((deprecated));

/// Deprecated. Use the variant with PSPDFPageView instead.
- (void)pdfViewController:(PSPDFViewController *)pdfController didRenderPage:(NSUInteger)page pdfScrollView:(PSPDFScrollView *)pdfScrollView __attribute__((deprecated));

/// called before a pdf page will be loaded and added to the pagingScrollView
- (void)pdfViewController:(PSPDFViewController *)pdfController willLoadPage:(NSUInteger)page pdfScrollView:(PSPDFScrollView *)pdfScrollView __attribute__((deprecated)); // use the variant with PSPDFPageView instead.

/// called after pdf page has been loaded and added to the pagingScrollView
- (void)pdfViewController:(PSPDFViewController *)pdfController didLoadPage:(NSUInteger)page pdfScrollView:(PSPDFScrollView *)pdfScrollView __attribute__((deprecated)); // use the variant with PSPDFPageView instead.

/// called before a pdf page will be unloaded and removed from the pagingScrollView
- (void)pdfViewController:(PSPDFViewController *)pdfController willUnloadPage:(NSUInteger)page pdfScrollView:(PSPDFScrollView *)pdfScrollView __attribute__((deprecated)); // use the variant with PSPDFPageView instead.

/// called after pdf page has been unloaded and removed from the pagingScrollView
- (void)pdfViewController:(PSPDFViewController *)pdfController didUnloadPage:(NSUInteger)page pdfScrollView:(PSPDFScrollView *)pdfScrollView __attribute__((deprecated)); // use the variant with PSPDFPageView instead.


@end
