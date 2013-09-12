//
//  PSPDFViewController+Delegates.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFViewController.h"

@protocol PSPDFAnnotationViewProtocol;
@class PSPDFPageView, PSPDFAnnotation, PSPDFPageInfo, PSPDFImageInfo;

// NSNotification equivalent to didLoadPageView: delegate.
extern NSString *const PSPDFViewControllerDidLoadPageViewNotification;

// NSNotification equivalent to didShowPageView: delegate.
extern NSString *const PSPDFViewControllerDidShowPageViewNotification;


@interface PSPDFViewController (Delegates)

- (BOOL)delegateShouldChangeDocument:(PSPDFDocument *)document;
- (void)delegateDidChangeDocument;

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
- (BOOL)delegateDidTapOnAnnotation:(PSPDFAnnotation *)annotation annotationPoint:(CGPoint)annotationPoint annotationView:(UIView <PSPDFAnnotationViewProtocol> *)annotationView pageView:(PSPDFPageView *)pageView viewPoint:(CGPoint)viewPoint;

- (NSArray *)delegateShouldSelectAnnotations:(NSArray *)annotations onPageView:(PSPDFPageView *)pageView;
- (void)delegateDidSelectAnnotations:(NSArray *)annotations onPageView:(PSPDFPageView *)pageView;

- (NSArray *)delegateShouldShowMenuItems:(NSArray *)menuItems atSuggestedTargetRect:(CGRect)rect forAnnotations:(NSArray *)annotations inRect:(CGRect)textRect onPageView:(PSPDFPageView *)pageView;

- (BOOL)delegateShouldDisplayAnnotation:(PSPDFAnnotation *)annotation onPageView:(PSPDFPageView *)pageView;

- (UIView <PSPDFAnnotationViewProtocol> *)delegateAnnotationView:(UIView <PSPDFAnnotationViewProtocol> *)annotationView forAnnotation:(PSPDFAnnotation *)annotation onPageView:(PSPDFPageView *)pageView;

- (void)delegateWillShowAnnotationView:(UIView <PSPDFAnnotationViewProtocol> *)annotationView onPageView:(PSPDFPageView *)pageView;
- (void)delegateDidShowAnnotationView:(UIView <PSPDFAnnotationViewProtocol> *)annotationView onPageView:(PSPDFPageView *)pageView;
- (void)delegateDidEndPageScrollingAnimation:(UIScrollView *)scrollView;
- (void)delegateDidBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view;
- (void)delegateDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale;
- (void)delegateDidBeginPageDragging:(UIScrollView *)scrollView;
- (void)delegateDidEndPageDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;

- (PSPDFDocument *)delegateDocumentForRelativePath:(NSString *)relativePath;

- (void)delegateDidLoadPageView:(PSPDFPageView *)pageView;
- (void)delegateWillUnloadPageView:(PSPDFPageView *)pageView;

- (BOOL)delegateShouldShowController:(id)viewController embeddedInController:(id)controller options:(NSDictionary *)options animated:(BOOL)animated;
- (void)delegateDidShowController:(id)viewController embeddedInController:(id)controller options:(NSDictionary *)options animated:(BOOL)animated;

- (void)updateDelegateFlags; // implemented in PSPDFViewController (Delegates)

@end

typedef struct {
    unsigned int shouldChangeDocument:1;
    unsigned int didChangeDocument:1;
    unsigned int didShowPageView:1;
    unsigned int didRenderPageView:1;
    unsigned int didChangeViewMode:1;
    unsigned int didTapOnPageView:1;
    unsigned int didLongPressOnPageView:1;
    unsigned int shouldSelectText:1;
    unsigned int didSelectText:1;
    unsigned int shouldShowMenuItemsForSelectedText:1;
    unsigned int shouldShowMenuItemsForSelectedImage:1;
    unsigned int shouldSelectAnnotations:1;
    unsigned int didSelectAnnotations:1;
    unsigned int shouldShowMenuItemsForAnnotation:1;
    unsigned int didTapOnAnnotation:1;
    unsigned int shouldDisplayAnnotation:1;
    unsigned int shouldScrollToPage:1;
    unsigned int annotationViewForAnnotations:1;
    unsigned int willShowAnnotationView:1;
    unsigned int didShowAnnotationView:1;
    unsigned int didLoadPageView:1;
    unsigned int willUnloadPageView:1;
    unsigned int didBeginPageDragging:1;
    unsigned int didEndPageDraggingWillDecelerate:1;
    unsigned int didEndPageScrollingAnimation:1;
    unsigned int didBeginZooming:1;
    unsigned int didEndZoomingAtScale:1;
    unsigned int shouldShowControllerAnimated:1;
    unsigned int didShowControllerAnimated:1;
    unsigned int documentForRelativePath:1;
}PSPDFDelegateFlags;
