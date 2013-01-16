//
//  PSPDFViewController+Delegates.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFViewController.h"

@protocol PSPDFAnnotationView;
@class PSPDFPageView, PSPDFAnnotation, PSPDFPageCoordinates, PSPDFPageInfo, PSPDFImageInfo;

@interface PSPDFViewController (Delegates)

- (BOOL)delegateShouldSetDocument:(PSPDFDocument *)document;
- (void)delegateWillDisplayDocument;
- (void)delegateDidDisplayDocument;

- (void)delegateDidShowPage:(NSUInteger)page; // legacy bridge
- (void)delegateDidShowPageView:(PSPDFPageView *)pageView;
- (void)delegateDidRenderPageView:(PSPDFPageView *)pageView;
- (void)delegateDidChangeViewMode:(PSPDFViewMode)viewMode;
- (BOOL)delegateShouldScrollToPage:(NSUInteger)page;

- (BOOL)delegateDidTapOnPageView:(PSPDFPageView *)pageView atPoint:(CGPoint)viewPoint;
- (BOOL)delegateDidLongPressOnPageView:(PSPDFPageView *)pageView atPoint:(CGPoint)viewPoint gestureRecognizer:(UILongPressGestureRecognizer *)gestureRecognizer;

// text selection
- (BOOL)delegateShouldSelectText:(NSString *)text withGlyphs:(NSArray *)glyphs atRect:(CGRect)rect onPageView:(PSPDFPageView *)pageView;
- (void)delegateDidSelectText:(NSString *)text withGlyphs:(NSArray *)glyphs atRect:(CGRect)rect onPageView:(PSPDFPageView *)pageView;

- (NSArray *)delegateShouldShowMenuItems:(NSArray *)menuItems atSuggestedTargetRect:(CGRect)rect forSelectedText:(NSString *)selectedText inRect:(CGRect)textRect onPageView:(PSPDFPageView *)pageView;
- (NSArray *)delegateShouldShowMenuItems:(NSArray *)menuItems atSuggestedTargetRect:(CGRect)rect forSelectedImage:(PSPDFImageInfo *)selectedImage inRect:(CGRect)textRect onPageView:(PSPDFPageView *)pageView;

// annotations
- (BOOL)delegateDidTapOnAnnotation:(PSPDFAnnotation *)annotation annotationPoint:(CGPoint)annotationPoint annotationView:(UIView<PSPDFAnnotationView> *)annotationView pageView:(PSPDFPageView *)pageView viewPoint:(CGPoint)viewPoint;
- (BOOL)delegateShouldSelectAnnotation:(PSPDFAnnotation *)annotation onPageView:(PSPDFPageView *)pageView;
- (void)delegateDidSelectAnnotation:(PSPDFAnnotation *)annotation onPageView:(PSPDFPageView *)pageView;
- (NSArray *)delegateShouldShowMenuItems:(NSArray *)menuItems atSuggestedTargetRect:(CGRect)rect forAnnotation:(PSPDFAnnotation *)annotation inRect:(CGRect)textRect onPageView:(PSPDFPageView *)pageView;

- (BOOL)delegateShouldDisplayAnnotation:(PSPDFAnnotation *)annotation onPageView:(PSPDFPageView *)pageView;

- (UIView <PSPDFAnnotationView> *)delegateAnnotationView:(UIView <PSPDFAnnotationView> *)annotationView forAnnotation:(PSPDFAnnotation *)annotation onPageView:(PSPDFPageView *)pageView;
- (void)delegateWillShowAnnotationView:(UIView <PSPDFAnnotationView> *)annotationView onPageView:(PSPDFPageView *)pageView;
- (void)delegateDidShowAnnotationView:(UIView <PSPDFAnnotationView> *)annotationView onPageView:(PSPDFPageView *)pageView;

- (void)delegateDidEndPageScrollingAnimation:(UIScrollView *)scrollView;
- (void)delegateDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale;
- (void)delegateDidEndPageDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;

- (PSPDFDocument *)delegateDocumentForRelativePath:(NSString *)relativePath;

- (void)delegateDidLoadPageView:(PSPDFPageView *)pageView;
- (void)delegateWillUnloadPageView:(PSPDFPageView *)pageView;

- (BOOL)delegateShouldShowController:(id)viewController embeddedInController:(id)controller animated:(BOOL)animated;
- (void)delegateDidShowController:(id)viewController embeddedInController:(id)controller animated:(BOOL)animated;

- (void)updateDelegateFlags; // implemented in PSPDFViewController (Delegates)

@end

typedef struct {
    unsigned int delegateShouldSetDocument:1;
    unsigned int delegateWillDisplayDocument:1;
    unsigned int delegateDidDisplayDocument:1;
    unsigned int delegateDidShowPageView:1;
    unsigned int delegateDidRenderPageView:1;
    unsigned int delegateDidChangeViewMode:1;
    unsigned int delegateDidTapOnPageView:1;
    unsigned int delegateDidLongPressOnPageView:1;
    unsigned int delegateShouldSelectText:1;
    unsigned int delegateDidSelectText:1;
    unsigned int delegateShouldShowMenuItemsForSelectedText:1;
    unsigned int delegateShouldShowMenuItemsForSelectedImage:1;
    unsigned int delegateShouldSelectAnnotation:1;
    unsigned int delegateDidSelectAnnotation:1;
    unsigned int delegateShouldShowMenuItemsForAnnotation:1;
    unsigned int delegateDidTapOnAnnotation:1;
    unsigned int delegateShouldDisplayAnnotation:1;
    unsigned int delegateShouldScrollToPage:1;
    unsigned int delegateAnnotationViewForAnnotation:1;
    unsigned int delegateWillShowAnnotationView:1;
    unsigned int delegateDidShowAnnotationView:1;
    unsigned int delegateDidLoadPageView:1;
    unsigned int delegateWillUnloadPageView:1;
    unsigned int delegateDidEndPageDraggingWillDecelerate:1;
    unsigned int delegateDidEndPageScrollingAnimation:1;
    unsigned int delegateDidEndZoomingAtScale:1;
    unsigned int delegateShouldShowControllerAnimated:1;
    unsigned int delegateDidShowControllerAnimated:1;
    unsigned int delegateDocumentForRelativePath:1;
}PSPDFDelegateFlags;
