//
//  PSPDFThumbnailBar.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFCache.h"
#import "PSTCollectionView.h"

@class PSPDFThumbnailBar;

/// Delegate for thumbnail actions.
@protocol PSPDFThumbnailBarDelegate <NSObject>

@optional

/// A thumbnail has been selected.
- (void)thumbnailBar:(PSPDFThumbnailBar *)thumbnailBar didSelectPage:(NSUInteger)page;

@end

/// Bottom bar that shows a scrollable list of thumbnails.
@interface PSPDFThumbnailBar : PSUICollectionView <PSUICollectionViewDataSource, PSUICollectionViewDelegate>

/// Designated initializer.
- (id)initWithDocument:(PSPDFDocument *)document;

/// The associated document.
@property (nonatomic, strong) PSPDFDocument *document;

/// Delegate for the thumbnail controller.
@property (nonatomic, weak) id<PSPDFThumbnailBarDelegate> thumbnailBarDelegate;

/// Scrolls to specified page in the grid and centers the selected page.
- (void)scrollToPage:(NSUInteger)page animated:(BOOL)animated;

/// Stops an ongoing scroll animation.
- (void)stopScrolling;

/// Thumbnail size. Defaults to 100x130.
@property (nonatomic, assign) CGSize thumbnailSize;

/// Class used for thumbnails (defaults to PSPDFThumbnailGridViewCell)
@property (nonatomic, strong) Class thumbnailCellClass;

@end
