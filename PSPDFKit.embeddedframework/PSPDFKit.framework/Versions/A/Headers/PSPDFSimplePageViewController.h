//
//  PSPDFSimplePageViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFBaseViewController.h"

@protocol PSPDFSimplePageViewControllerDelegate <NSObject>

@optional
// sets scrollview property. Defaults to YES.
- (BOOL)shouldDelayContentTouches;

@end

/// Simple view controller that paginates a set of viewControllers.
/// (Apple added something like this in iOS6, but we can't use that yet)
@interface PSPDFSimplePageViewController : PSPDFBaseViewController <UIScrollViewDelegate>

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
