//
//  PSPDFPageScrollViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFBaseViewController.h"
#import "PSPDFKitGlobal.h"
#import "PSPDFTransitionProtocol.h"
#import "PSPDFViewController.h"

@interface PSPDFPagingScrollView : UIScrollView @end

@class PSPDFPageView;

/// Handles the default per-page side-scrolling.
@interface PSPDFPageScrollViewController : PSPDFBaseViewController <PSPDFTransitionProtocol, UIScrollViewDelegate>

/// Designated initializer.
- (id)initWithPDFController:(PSPDFViewController *)pdfController;

/// Associated `PSPDFViewController` class.
@property (nonatomic, unsafe_unretained) PSPDFViewController *pdfController;

/// Main view.
@property (nonatomic, strong, readonly) UIScrollView *pagingScrollView;

/// Page padding width between single/double pages.
@property (nonatomic, assign) CGFloat pagePadding;

/// Access visible page numbers.
- (NSOrderedSet *)visiblePageNumbers;

/// Access the `PSPDFPageView` object for a page, if loaded.
- (PSPDFPageView *)pageViewForPage:(NSUInteger)page;

/// Set Page, animated.
- (void)setPage:(NSUInteger)page animated:(BOOL)animated;

/// Explicitly reload the view.
- (void)reloadData;

@end
