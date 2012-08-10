//
//  PSPDFThumbnailGridViewCell.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSCollectionViewCell.h"

// if own thumbs are provided and they are larger than the cell, apply shrinking before setting
#define kPSPDFShrinkOwnImagesTresholdFactor 1.5

/// Thumbnail cell.
@interface PSPDFThumbnailGridViewCell : PSCollectionViewCell <PSPDFCacheDelegate>

/// Referenced document.
@property(nonatomic, strong) PSPDFDocument *document;

/// Referenced page.
@property(nonatomic, assign) NSUInteger page;

/// Allow a margin. Defaults to 0,0,0,0.
@property(nonatomic, assign) UIEdgeInsets edgeInsets;

/// Enables thumbnail shadow. defaults to YES, except on old devices.
@property(nonatomic, assign, getter=isShadowEnabled) BOOL shadowEnabled;

/// Enable page label.
@property(nonatomic, assign, getter=isShowingSiteLabel) BOOL showingSiteLabel;

/// Call before re-showing (will update bookmark status)
- (void)updateCell;

@end


@interface PSPDFThumbnailGridViewCell (Subclassing)

/// Internal image view.
@property(nonatomic, strong) UIImageView *imageView;

/// Site label.
@property(nonatomic, strong) UILabel *siteLabel;

/// Creates the shadow. Subclass to change. Returns a CGPathRef.
- (id)pathShadowForView:(UIView *)imgView;

/// Manually set image. use if you override class.
- (void)setImage:(UIImage *)image animated:(BOOL)animated;

/// Called when cell resizes. use in override class to re-positionize your content.
- (void)setImageSize:(CGSize)imageSize;

/// Internal static queue for thumbnail parsing.
+ (NSOperationQueue *)thumbnailQueue;

- (void)updateSiteLabel;

@end
