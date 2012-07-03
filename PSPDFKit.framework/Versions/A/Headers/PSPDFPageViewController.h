//
//  PSPDFPageViewController.h
//  PSPDFKit
//
//  Copyright (c) 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFTransitionViewController.h"

/// Implements the iOS5-only pageCurl-style famously presented in iBooks.
/// Note: Due to the nature of the animation, it doesn't look well with non-equal sized documents.
@interface PSPDFPageViewController : UIPageViewController <PSPDFTransitionViewControllerDelegate, UIPageViewControllerDelegate, UIPageViewControllerDataSource>

- (id)initWithTransitionController:(PSPDFTransitionViewController *)transitionController;

@property(nonatomic, ps_weak) PSPDFTransitionViewController *transitionController;

/// If set to YES, the background of the UIViewController is used. Else you may get some animation artifacts. Defaults to NO.
@property(nonatomic, assign) BOOL useSolidBackground;

/// Clips the page to its boundaries, not showing a pageCurl on empty background. Defaults to YES.
/// Usually you want this, unless your document is variable sized.
@property(nonatomic, assign) BOOL clipToPageBoundaries;

@end
