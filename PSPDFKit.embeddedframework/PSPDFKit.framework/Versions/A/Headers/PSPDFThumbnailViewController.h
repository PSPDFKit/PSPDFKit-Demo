//
//  PSPDFThumbnailViewController.h
//  PSPDFKit
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFBaseViewController.h"
#import "PSTCollectionView.h"
#import "PSPDFDocument.h"

@class PSPDFThumbnailViewController, PSPDFThumbnailGridViewCell;

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
@property (nonatomic, weak) id<PSPDFThumbnailViewControllerDelegate> delegate;

/// Scrolls to specified page in the grid.
- (void)scrollToPage:(NSUInteger)page animated:(BOOL)animated;

/// Stops an ongoing scroll animation.
- (void)stopScrolling;

/// Call to update all cells (e.g. to show bookmark changes)
- (void)updateVisibleCells;

/// Thumbnail size. Defaults to 170x220.
/// @warning call reloadData on the collectionView after changing this.
@property (nonatomic, assign) CGSize thumbnailSize;

/// Set margin for thumbnail view mode. Defaults to UIEdgeInsetsMake(15, 15, 15, 15).
/// Margin is extra space around the grid of thumbnails (sectionInset of the flow layout).
/// @warning Will be ignored if the layout is not a flow layout or a subclass thereof.
@property (nonatomic, assign) UIEdgeInsets thumbnailMargin;

/// Row margin (minimumLineSpacing property of the flow layout). Defaults to 10.
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

@end
