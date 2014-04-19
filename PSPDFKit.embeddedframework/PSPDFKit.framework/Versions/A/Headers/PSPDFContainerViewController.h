//
//  PSPDFContainerViewController.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFBaseViewController.h"
#import "PSPDFStyleable.h"

@class PSPDFContainerViewController;

@protocol PSPDFContainerViewControllerDelegate <NSObject>

@optional

/// Called every time the index is changed.
- (void)containerViewController:(PSPDFContainerViewController *)controller didUpdateSelectedIndex:(NSUInteger)selectedIndex;

@end

/// Can embed other view controllers and transition between them.
@interface PSPDFContainerViewController : PSPDFBaseViewController <PSPDFStyleable>

/// Designated initializer.
- (id)initWithControllers:(NSArray *)controllers titles:(NSArray *)titles delegate:(id<PSPDFContainerViewControllerDelegate>)delegate;

/// The container controller delegate, notifies when the index changes.
@property (nonatomic, weak) id<PSPDFContainerViewControllerDelegate> delegate;

/// @name View Controller adding/removing

/// Add view controller to the list.
- (void)addViewController:(UIViewController *)controller withTitle:(NSString *)title;
- (void)addViewController:(UIViewController *)controller; // uses the default controller title.

/// Remove view controller from the list.
- (void)removeViewController:(UIViewController *)controller;

/// All added view controllers.
@property (nonatomic, copy, readonly) NSArray *viewControllers;

/// @name State

/// The currently visible view controller index.
@property (nonatomic, assign) NSUInteger visibleViewControllerIndex;

/// Set the currently visible view controller index.
- (void)setVisibleViewControllerIndex:(NSUInteger)visibleViewControllerIndex animated:(BOOL)animated;

/// @name Settings

/// Set to YES if you want to animate controller changes. Defaults to NO.
/// @note Popover size change animation can't be blocked on iOS 6.
@property (nonatomic, assign) BOOL shouldAnimateChanges;

@end

@interface PSPDFContainerViewController (SubclassingHooks)

/// Internally used segment.
@property (nonatomic, strong, readonly) UISegmentedControl *filterSegment;

@end
