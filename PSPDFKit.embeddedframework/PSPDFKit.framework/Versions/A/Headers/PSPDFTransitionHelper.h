//
//  PSPDFTransitionHelper.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFBaseViewController.h"
#import "PSPDFSinglePageViewController.h"
#import "PSPDFTransitionProtocol.h"

@class PSPDFTransitionHelper, PSPDFViewController, PSPDFContentScrollView, PSPDFSinglePageViewController;

// Helper to communicate with the transition viewController.
@protocol PSPDFTransitionHelperDelegate <NSObject>

- (PSPDFViewController *)pdfController;

- (NSArray *)viewControllers;

- (void)transitionHelper:(PSPDFTransitionHelper *)transitionHelper changedToPage:(NSUInteger)page doublePageMode:(BOOL)doublePageMode forwardTransition:(BOOL)forwardTransition animated:(BOOL)animated;

@end

/// Helper for creating/reusing PSPDFSinglePageViewController's.
/// Is used for more complex animation like the PSPDFPageViewController.
@interface PSPDFTransitionHelper : NSObject <PSPDFSinglePageViewControllerDelegate>

/// Create page controller using the master pdf controller.
- (id)initWithDelegate:(UIViewController <PSPDFTransitionHelperDelegate> *)delegate;

@property (nonatomic, weak, readonly) UIViewController <PSPDFTransitionHelperDelegate> *delegate;

/// Set new page.
@property (nonatomic, assign) NSUInteger page;

- (void)setPage:(NSUInteger)page animated:(BOOL)animated;

- (NSArray *)visiblePageNumbers;

- (PSPDFPageView *)pageViewForPage:(NSUInteger)page;

@end

@interface PSPDFTransitionHelper (PSPDFChildControllerHelpers)

- (PSPDFSinglePageViewController *)singlePageControllerForPage:(NSUInteger)page;

- (NSUInteger)fixPageNumberForDoublePageMode:(NSUInteger)page forceDoublePageMode:(BOOL)forceDualPageMode;

- (PSPDFSinglePageViewController *)viewControllerAfterViewController:(UIViewController *)viewController;

- (PSPDFSinglePageViewController *)viewControllerBeforeViewController:(UIViewController *)viewController;

- (void)setPageInternal:(NSUInteger)page;

@end
