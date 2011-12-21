//
//  PSPDFViewControllerDelegate.h
//  PSPDFKit
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PSPDFKitGlobal.h"
#import "PSPDFViewController.h"

@protocol PSPDFAnnotationView;
@class PSPDFDocument, PSPDFPageInfo, PSPDFPageCoordinates, PSPDFAnnotation, PSPDFPageView, PSPDFScrollView;

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
- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didTapOnPageView:(PSPDFPageView *)pageView info:(PSPDFPageInfo *)pageInfo coordinates:(PSPDFPageCoordinates *)pageCoordinates;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma - annotations

/// Delegate for tapping on an annotation. If you don't implement this or return false, it will be processed by default action (scroll to page, ask to open Safari)
- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didTapOnAnnotation:(PSPDFAnnotation *)annotation page:(NSUInteger)page info:(PSPDFPageInfo *)pageInfo coordinates:(PSPDFPageCoordinates *)pageCoordinates;

/// called before a annotation view is created and added to a page. Defaults to YES if not implemented.
/// if NO is returned, viewForAnnotation will not be called.
- (BOOL)pdfViewController:(PSPDFViewController *)pdfController shouldDisplayAnnotation:(PSPDFAnnotation *)annotation onPageView:(PSPDFPageView *)pageView;

/// Returns a pre-generated annotationView that can be modified before being added to the view.
/// If no generator for a custom annotation is found, annotationView will be nil (as a replacement to viewForAnnotation)
/// To get the targeted rect use [annotation rectForPageRect:pageView.bounds];
- (UIView <PSPDFAnnotationView> *)pdfViewController:(PSPDFViewController *)pdfController annotationView:(UIView <PSPDFAnnotationView> *)annotationView forAnnotation:(PSPDFAnnotation *)annotation onPageView:(PSPDFPageView *)pageView;

// invoked prior to the presentation of the annotation view: use this to configure actions etc
- (void)pdfViewController:(PSPDFViewController *)pdfController willShowAnnotationView:(UIView <PSPDFAnnotationView> *)annotationView onPageView:(PSPDFPageView *)pageView;

// invoked after animation used to present the annotation view
- (void)pdfViewController:(PSPDFViewController *)pdfController didShowAnnotationView:(UIView <PSPDFAnnotationView> *)annotationView onPageView:(PSPDFPageView *)pageView;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma - detailed control for page loading/unloading

/// called after pdf page has been loaded and added to the pagingScrollView.
- (void)pdfViewController:(PSPDFViewController *)pdfController didLoadPageView:(PSPDFPageView *)pageView;

/// called before a pdf page will be unloaded and removed from the pagingScrollView.
- (void)pdfViewController:(PSPDFViewController *)pdfController willUnloadPageView:(PSPDFPageView *)pageView;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma - deprecated

/// allows adding custom annotations. Called on any handler that is not recognized by PSPDFKit.
- (UIView <PSPDFAnnotationView> *)pdfViewController:(PSPDFViewController *)pdfController viewForAnnotation:(PSPDFAnnotation *)annotation onPageView:(PSPDFPageView *)pageView __attribute__((deprecated("Deprecated. Use annotationViewForAnnotation instead.")));

- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didTapOnPage:(NSUInteger)page info:(PSPDFPageInfo *)pageInfo coordinates:(PSPDFPageCoordinates *)pageCoordinates __attribute__((deprecated("Deprecated. Use variant with pageView instead.")));

@end
