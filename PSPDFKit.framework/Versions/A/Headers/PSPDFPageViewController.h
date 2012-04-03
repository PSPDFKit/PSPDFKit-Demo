//
//  PSPDFPageViewController.h
//  PSPDFKit
//
//  Copyright (c) 2011-2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PSPDFKitGlobal.h"

@class PSPDFViewController, PSPDFPagedScrollView, PSPDFSinglePageViewController;

/// Implements the iOS5-only pageCurl-style famously presented in iBooks.
/// Note: doesn't work well with non-equal sized documents.
@interface PSPDFPageViewController : UIPageViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

/// Create page controller using the master pdf controller.
- (id)initWithPDFController:(PSPDFViewController *)pdfController;

/// Associated pdfController class (hosts the UIPageViewController).
@property(nonatomic, ps_weak) PSPDFViewController *pdfController;

/// Associated scrollview
@property(nonatomic, ps_weak) PSPDFPagedScrollView *scrollView;

/// Set new page.
@property(nonatomic, assign) NSUInteger page;
- (void)setPage:(NSUInteger)page animated:(BOOL)animated;

/// If set to YES, the background of the UIViewController is used. Else you may get some animation artifacts. Defaults to NO.
@property(nonatomic, assign) BOOL useSolidBackground;

/// Clips the page to its boundaries, not showing a pageCurl on empty background. Defaults to YES.
/// Usually you want this, unless your document is variable sized.
@property(nonatomic, assign) BOOL clipToPageBoundaries;

@end
