//
//  PSPDFAnnotationViewProtocol.h
//  PSPDFKit
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"

@class PSPDFAnnotation, PSPDFPageView;

/// Conforming to this protocol indicates instances can present an annotation and react events such as page show/hide (to pause video, for example)
@protocol PSPDFAnnotationViewProtocol <NSObject>

@optional

/// Represented annotation this object is presenting.
@property (nonatomic, strong) PSPDFAnnotation *annotation;

/// Allows ordering of annotation views.
@property (nonatomic, assign) NSUInteger zIndex;

/// Allows adapting to the outer zoomScale. Re-set after zooming.
@property (nonatomic, assign) CGFloat zoomScale;

/// Allows adapting to the initial pdfScale
@property (nonatomic, assign) CGFloat PDFScale;

/// Called when `pageView` is displayed.
- (void)didShowPageView:(PSPDFPageView *)pageView;

/// Called when `pageView` is hidden.
- (void)didHidePageView:(PSPDFPageView *)pageView;

/// Called initially and when the parent page size is changed. (e.g. rotation)
- (void)didChangePageBounds:(CGRect)bounds;

/// Called when the user taps on an annotation and the tap wasn't processed otherwise.
- (void)didTapAtPoint:(CGPoint)point;

/// Queries the view if removing should be in sync or happen instantly.
/// If not implemented, return YES is assumed.
- (BOOL)shouldSyncRemovalFromSuperview;

/// View is queued for being removed, but still waits for a page sync.
/// This is called regardles of what is returned in `shouldSyncRemovalFromSuperview`.
- (void)willRemoveFromSuperview;

/// A weak reference to the page view responsible for this view.
@property (nonatomic, weak) PSPDFPageView *pageView;

/// Indicates if the view is selected.
@property (nonatomic, assign, getter=isSelected) BOOL selected;

@end
