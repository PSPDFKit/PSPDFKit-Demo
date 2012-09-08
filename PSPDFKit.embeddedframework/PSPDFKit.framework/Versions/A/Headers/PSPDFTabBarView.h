//
//  PSPDFTabBarView.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@protocol PSPDFTabBarViewDelegate, PSPDFTabBarViewDataSource;

/// The TabBar used in PSPDFTabbedViewController
@interface PSPDFTabBarView : UIView <UIScrollViewDelegate>

/// Reload all tabs.
- (void)reloadData;

/// Selects a certain tab, animatable.
- (void)selectTabAtIndex:(NSUInteger)index animated:(BOOL)animated;

/// Scrolls to a certain tab, animatable.
- (void)scrollToTabAtIndex:(NSUInteger)index animated:(BOOL)animated;

/// Currently selected tab index. May return NSNotFound if no tabs are loaded.
@property(nonatomic, readonly) NSUInteger selectedTabIndex;

/// Minimum tab width. Defaults to 0.
@property(nonatomic, assign) CGFloat minTabWidth;

@property(nonatomic, assign) IBOutlet id<PSPDFTabBarViewDelegate> delegate;
@property(nonatomic, assign) IBOutlet id<PSPDFTabBarViewDataSource> dataSource;

@end

/// The TabBar delegate.
@protocol PSPDFTabBarViewDelegate <NSObject>
- (void)tabBarView:(PSPDFTabBarView *)tabBarView didSelectTabAtIndex:(NSUInteger)index;
- (void)tabBarView:(PSPDFTabBarView *)tabBarView didSelectCloseButtonOfTabAtIndex:(NSUInteger)index;
@end

/// The TabBar dataSource.
@protocol PSPDFTabBarViewDataSource <NSObject>
- (NSInteger)numberOfTabsInTabBarView:(PSPDFTabBarView *)tabBarView;
- (NSString *)tabBarView:(PSPDFTabBarView *)tabBarView titleForTabAtIndex:(NSUInteger)index;
@end
