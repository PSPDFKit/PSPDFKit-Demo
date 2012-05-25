//
//  PSPDFTabBarView.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PSPDFTabBarViewDelegate, PSPDFTabBarViewDataSource;

@interface PSPDFTabBarView : UIView

/// Reload all tabs.
- (void)reloadData;

/// Scrolls to a certain tab and selects it, animatable.
- (void)selectTabAtIndex:(NSUInteger)index animated:(BOOL)animated;

/// Currently selected tab index. May return NSNotFound if no tabs are loaded.
@property(nonatomic, readonly) NSUInteger selectedTabIndex;

@property(nonatomic, assign) IBOutlet id<PSPDFTabBarViewDelegate> delegate;
@property(nonatomic, assign) IBOutlet id<PSPDFTabBarViewDataSource> dataSource;

//@property(nonatomic,assign) UIEdgeInsets buttonInsets;

@end

@protocol PSPDFTabBarViewDelegate <NSObject>
- (void)tabBarView:(PSPDFTabBarView *)tabBarView didSelectTabAtIndex:(NSUInteger)index;
- (void)tabBarView:(PSPDFTabBarView *)tabBarView didSelectCloseButtonOfTabAtIndex:(NSUInteger)index;
@end

@protocol PSPDFTabBarViewDataSource <NSObject>
- (NSInteger)numberOfTabsInTabBarView:(PSPDFTabBarView *)tabBarView;
- (NSString *)tabBarView:(PSPDFTabBarView *)tabBarView titleForTabAtIndex:(NSUInteger)index;
@end
