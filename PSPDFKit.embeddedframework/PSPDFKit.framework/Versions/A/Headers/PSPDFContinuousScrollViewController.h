//
//  PSPDFContinuousScrollViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFBaseViewController.h"
#import "PSPDFKitGlobal.h"
#import "PSPDFTransitionProtocol.h"
#import "PSPDFViewController.h"

@class PSPDFPageView, PSPDFPagingScrollView;

///
/// Controller for Safari-like continuous scrolling.
///
@interface PSPDFContinuousScrollViewController : PSPDFBaseViewController <PSPDFTransitionProtocol, UIScrollViewDelegate>

/// Designated initializer.
- (id)initWithPDFController:(PSPDFViewController *)pdfController;

/// Associated pdfController. (unsafe_unretained because we observe KVO on this)
@property (nonatomic, unsafe_unretained) PSPDFViewController *pdfController;

/// Associated scroll view. Might be nil if transition doesn't support zooming.
@property (nonatomic, weak) PSPDFContentScrollView *scrollView;

/// Page padding width between single/double pages.
@property (nonatomic, assign) CGFloat pagePadding;

/// Customized content offset for PSPDFViewState.
- (CGPoint)compensatedContentOffset;

@end
