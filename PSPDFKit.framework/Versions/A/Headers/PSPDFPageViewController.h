//
//  PSPDFPageViewController.h
//  PSPDFKit
//
//  Copyright (c) 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PSPDFKitGlobal.h"

@class PSPDFViewController, PSPDFPagedScrollView;

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

@end
