//
//  PSPDFSimplePageViewController.h
//  PSPDFKit
//
//  Copyright 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

/// Simple view controller that paginates a set of viewControllers.
/// (Apple added something like this in iOS6, but we can't use that yet)
@interface PSPDFSimplePageViewController : UIViewController <UIScrollViewDelegate>

/// Designated initializer.
- (id)initWithViewControllers:(NSArray *)viewControllers;

/// Get/set current page, optionally animated. Page starts at 0.
@property (nonatomic, assign) NSUInteger page;
- (void)setPage:(NSUInteger)page animated:(BOOL)animated;

@end


@interface PSPDFSimplePageViewController (SubclassingHooks)

@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) UIPageControl *pageControl;

@end