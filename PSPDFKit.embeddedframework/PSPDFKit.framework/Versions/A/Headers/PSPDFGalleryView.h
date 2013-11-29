//
//  PSPDFGalleryView.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>

@class PSPDFGalleryContentView;
@protocol PSPDFGalleryViewDataSource, PSPDFGalleryViewDelegate;

/// A gallery view works a lot like a `UITableView`. It has content views, which need to be provided by
/// a data source and can be reused. It is built on top of a `UIScrollView`.
@interface PSPDFGalleryView : UIScrollView

/// The data source of the gallery view.
@property (nonatomic, weak) id <PSPDFGalleryViewDataSource> dataSource;

/// The currently visible item index.
@property (nonatomic, assign) NSUInteger currentItemIndex;

/// The padding between successive content views. Defaults to 5.0.
@property (nonatomic, assign) CGFloat contentPadding;

/// The delegate of the gallery view (same as `UIScrollView`)
- (void)setDelegate:(id <PSPDFGalleryViewDelegate>)delegate;
- (id <PSPDFGalleryViewDelegate>)delegate;

/// Reloads the gallery view.
- (void)reload;

/// Returns the PSPDFGalleryContentView for the given item index or nil if does not exist or is not part of activeContentViews.
- (PSPDFGalleryContentView *)contentViewForItemAtIndex:(NSUInteger)index;

/// Returns the index for a given content view or NSNotFound if the content view cannot be matched to an index.
- (NSUInteger)itemIndexForContentView:(PSPDFGalleryContentView *)contentView;

/// Returns a reusable content view for a given identifier.
- (PSPDFGalleryContentView *)dequeueReusableContentViewWithIdentifier:(NSString *)identifier;

/// Moves to a given item index with or without animating.
- (void)setCurrentItemIndex:(NSUInteger)currentItemIndex animated:(BOOL)animated;

/// The currently active content views, that is the content views that are visible or are next to a visible content view.
- (NSSet *)activeContentViews;

@end

@protocol PSPDFGalleryViewDataSource <NSObject>

/// The number if items in a gallery.
- (NSUInteger)numberOfItemsInGalleryView:(PSPDFGalleryView *)galleryView;

/// The content view for the given index.
- (PSPDFGalleryContentView *)galleryView:(PSPDFGalleryView *)galleryView contentViewForItemAtIndex:(NSUInteger)index;

@end

@protocol PSPDFGalleryViewDelegate <UIScrollViewDelegate>

@optional

/// Called when currentItemIndex changes.
- (void)galleryView:(PSPDFGalleryView *)galleryView didScrollToItemAtIndex:(NSUInteger)index;

@end
