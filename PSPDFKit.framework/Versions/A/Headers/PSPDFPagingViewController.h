//
//  PSPDFPagingViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFBaseViewController.h"
#import "PSPDFKitGlobal.h"
#import "PSPDFTransitionProtocol.h"

@class PSPDFViewController, PSPDFPageView, PSPDFPagingScrollView;

@interface PSPDFPagingViewController : PSPDFBaseViewController <PSPDFTransitionProtocol, UIScrollViewDelegate>

/// Designated initializer.
- (id)initWithPDFController:(PSPDFViewController *)pdfController;

/// Associated pdfController class (hosts the UIPageViewController).
@property(nonatomic, unsafe_unretained) PSPDFViewController *pdfController;

/// Main view.
@property(nonatomic, strong, readonly) PSPDFPagingScrollView *pagingScrollView;

/// Page padding width between single/double pages.
@property(nonatomic, assign) CGFloat pagePadding;

- (NSArray *)visiblePageNumbers;
- (PSPDFPageView *)pageViewForPage:(NSUInteger)page;

- (void)setPage:(NSUInteger)page animated:(BOOL)animated;

@end


@interface PSPDFPagingViewController (PSPDFInternal)

// Rotation Helper.
@property(nonatomic, assign) NSUInteger targetPageAfterRotation;

@end

// Internally used scrollview.
@interface PSPDFPagingScrollView : UIScrollView
@end
