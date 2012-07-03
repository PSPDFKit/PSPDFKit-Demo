//
//  PSPDFTransitionViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFBaseViewController.h"
#import "PSPDFSinglePageViewController.h"
#import "PSPDFTransitionProtocol.h"

@class PSPDFTransitionViewController, PSPDFViewController, PSPDFPagedScrollView, PSPDFSinglePageViewController;

@protocol PSPDFTransitionViewControllerDelegate <NSObject>

@property(nonatomic, ps_weak) PSPDFTransitionViewController *transitionController;

// might differ from childViewControllers
- (NSArray *)viewControllers;

- (void)transitionViewController:(PSPDFTransitionViewController *)transitionController changedToPage:(NSUInteger)page dualPageMode:(BOOL)dualPageMode forwardTransition:(BOOL)forwardTransition animated:(BOOL)animated;

@end

/// Encapsulates more complex page transition view controllers like pageCurl.
/// Assumes that there's a global scrollView to zoom into the contentController view.
@interface PSPDFTransitionViewController : PSPDFBaseViewController <PSPDFTransitionProtocol, PSPDFSinglePageViewControllerDelegate>

/// Create page controller using the master pdf controller.
- (id)initWithPDFController:(PSPDFViewController *)pdfController contentControllerClass:(Class)contentControllerClass;

/// Associated pdfController class (hosts the UIPageViewController).
@property(nonatomic, unsafe_unretained) PSPDFViewController *pdfController;

/// Associated scrollview
@property(nonatomic, ps_weak) PSPDFPagedScrollView *scrollView;

@property(nonatomic, strong) UIViewController<PSPDFTransitionViewControllerDelegate> *contentController;

@property(nonatomic, strong, readonly) NSArray *viewControllers;

/// Set new page.
@property(nonatomic, assign) NSUInteger page;
- (void)setPage:(NSUInteger)page animated:(BOOL)animated;

@end

@interface PSPDFTransitionViewController (PSPDFChildControllerHelpers)

- (PSPDFSinglePageViewController *)singlePageControllerForPage:(NSUInteger)page;

- (NSUInteger)fixPageNumberForDoublePageMode:(NSUInteger)page forceDualPageMode:(BOOL)forceDualPageMode;

- (PSPDFSinglePageViewController *)viewControllerAfterViewController:(UIViewController *)viewController;
- (PSPDFSinglePageViewController *)viewControllerBeforeViewController:(UIViewController *)viewController;

- (void)setPageInternal:(NSUInteger)page;

- (void)hideControls;

@end
