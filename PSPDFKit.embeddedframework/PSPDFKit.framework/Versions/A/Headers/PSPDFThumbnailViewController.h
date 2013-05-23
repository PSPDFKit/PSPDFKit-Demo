//
//  PSPDFThumbnailViewController.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFBaseViewController.h"
#import "PSTCollectionView.h"
#import "PSPDFDocument.h"

@class PSPDFThumbnailViewController, PSPDFThumbnailGridViewCell;

typedef NS_ENUM(NSUInteger, PSPDFThumbnailViewFilter) {
    PSPDFThumbnailViewFilterShowAll,     // Show all thumbnails.
    PSPDFThumbnailViewFilterBookmarks,   // Show bookmarked thumbnails.
    PSPDFThumbnailViewFilterAnnotations, // All annotation types except links. PSPDFKit Annotate only.
};

/// Delegate for thumbnail actions.
@protocol PSPDFThumbnailViewControllerDelegate <NSObject>

@optional

/// A thumbnail has been selected.
- (void)thumbnailViewController:(PSPDFThumbnailViewController *)thumbnailViewController didSelectPage:(NSUInteger)page inDocument:(PSPDFDocument *)document;

@end

/// The thumbnail view controller.
@interface PSPDFThumbnailViewController : PSUICollectionViewController <PSUICollectionViewDataSource, PSUICollectionViewDelegate>

/// Designated initializer.
- (id)initWithDocument:(PSPDFDocument *)document;

/// The collection view used for the thumbnails.
@property (nonatomic, strong) PSUICollectionView *collectionView;

/// Current displayed document.
@property (nonatomic, strong) PSPDFDocument *document;

/// Delegate for the thumbnail controller.
@property (nonatomic, weak) IBOutlet id<PSPDFThumbnailViewControllerDelegate> delegate;

/// Get the cell for certain page. Compensates against open filters.
- (PSUICollectionViewCell *)cellForPage:(NSUInteger)page;

/// Scrolls to specified page in the grid.
- (void)scrollToPage:(NSUInteger)page animated:(BOOL)animated;

/// Stops an ongoing scroll animation.
- (void)stopScrolling;

/// Call to update any filter (if set) all visible cells (e.g. to show bookmark changes)
- (void)updateFilterAndVisibleCells;

/// Should the thumbnails be displayed in a fixed grid, or dynamically adapt to different page sizes?
/// Defaults to YES. Most documents will look better when this is set to NO.
@property (nonatomic, assign) BOOL fixedItemSizeEnabled;

/// Defines the filter options. Set to nil or empty to hide the filter bar.
/// Defaults to PSPDFThumbnailViewFilterShowAll, PSPDFThumbnailViewFilterBookmarks, PSPDFThumbnailViewFilterAnnotations.
@property (nonatomic, copy) NSOrderedSet *filterOptions;

/// Currently active filter. Make sure that one is also set in filterOptions.
@property (nonatomic, assign, readonly) PSPDFThumbnailViewFilter activeFilter;

/// Thumbnail size. Defaults to 170x220.
/// @warning call reloadData on the collectionView after changing this.
@property (nonatomic, assign) CGSize thumbnailSize;

/// Set margin for thumbnail view mode. Defaults to UIEdgeInsetsMake(15, 15, 15, 15).
/// Margin is extra space around the grid of thumbnails (sectionInset of the flow layout).
/// @warning Will be ignored if the layout is not a flow layout or a subclass thereof.
@property (nonatomic, assign) UIEdgeInsets thumbnailMargin;

/// Row margin (minimumLineSpacing property of the flow layout). Defaults to 20.
/// @warning Will be ignored if the layout is not a flow layout or a subclass thereof.
@property (nonatomic, assign) CGFloat thumbnailRowMargin;

/// Class used for thumbnails (defaults to PSPDFThumbnailGridViewCell)
/// @warning Will be ignored if the layout is not a flow layout or a subclass thereof.
@property (nonatomic, strong) Class thumbnailCellClass;

@end

@interface PSPDFThumbnailViewController (SubclassingHooks)

// Subclass to customize thumbnail cell configuration.
- (void)configureCell:(PSPDFThumbnailGridViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;

// Internally used layout. Use this to access/set the layout before the view has been loaded.
// The default layout is a UICollectionViewFlowLayout (PSTCollectionViewFlowLayout on iOS5)
@property (nonatomic, strong) PSUICollectionViewLayout *layout;

// The filter segment to filter bookmarked/annotated documents.
@property (nonatomic, strong, readonly) UISegmentedControl *filterSegment;

@end
