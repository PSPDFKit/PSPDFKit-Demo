//
//  PSPDFThumbnailGridViewCell.h
//  PSPDFKit
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFRoundedLabel.h"

/// The thumbnail cell classed used for the thumbnail grid and thumbnail scroll bar.
@interface PSPDFThumbnailGridViewCell : UICollectionViewCell <PSPDFCacheDelegate>

/// Referenced document.
@property (nonatomic, strong) PSPDFDocument *document;

/// Referenced page.
@property (nonatomic, assign) NSUInteger page;

/// Allow a margin. Defaults to `UIEdgeInsetsZero`.
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

/// Enables thumbnail shadow. defaults to No for iOS 7 flat mode, else YES.
@property (nonatomic, assign, getter=isShadowEnabled) BOOL shadowEnabled;

/// Enable page label.
@property (nonatomic, assign, getter=isPageLabelEnabled) BOOL pageLabelEnabled;

/// This is simply a redeclaration of the property in `UICollectionViewCell`.
/// Modify this to change the look of the selection/highlight state.
@property (nonatomic, strong) UIView *selectedBackgroundView;

/// Bookmark ribbon image color. Defaults to red.
@property (nonatomic, strong) UIColor *bookmarkImageColor UI_APPEARANCE_SELECTOR;

/// Call before re-showing the cell. (will update bookmark status)
- (void)updateCell;

@end


@interface PSPDFThumbnailGridViewCell (SubclassingHooks)

/// Internal image view.
@property (nonatomic, strong) UIImageView *imageView;

/// Page label. (By default a `PSPDFRoundedLabel`, but can be set to any UILabel subclass, simply do a cast.)
@property (nonatomic, strong) PSPDFRoundedLabel *pageLabel;

/// Allows to update the bookmark image.
@property (nonatomic, strong, readonly) UIImageView *bookmarkImageView;

/// Creates the shadow. Subclass to change. Returns a `CGPathRef`.
- (id)pathShadowForView:(UIView *)imgView;

/// Manually set image. use if you override class.
- (void)setImage:(UIImage *)image animated:(BOOL)animated;

/// Called when cell resizes. use in override class to re-position your content.
- (void)setImageSize:(CGSize)imageSize;

/// Updates the page label.
- (void)updatePageLabel;

/// Update bookmark image frame and image visibility.
- (void)updateBookmarkImage;

@end

