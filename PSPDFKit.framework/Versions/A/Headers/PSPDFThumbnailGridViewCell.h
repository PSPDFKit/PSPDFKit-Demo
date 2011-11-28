//
//  PSPDFThumbnailGridViewCell.h
//  PSPDFKit
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "PSPDFKit.h"
#import "AQGridViewCell.h"

// if own thumbs are provided and they are larger than the cell, apply shrinking before setting
#define kPSPDFShrinkOwnImagesTresholdFactor 1.5

/// Thumbnail cell.
@interface PSPDFThumbnailGridViewCell : AQGridViewCell <PSPDFCacheDelegate>

/// manually set image. use if you override class.
- (void)setImage:(UIImage *)image animated:(BOOL)animated;

/// called when cell resizes. use in override class to re-positionize your content.
- (void)setImageSize:(CGSize)imageSize;

/// internal image view.
@property(nonatomic, retain) UIImageView *imageView;

/// referenced document.
@property(nonatomic, retain) PSPDFDocument *document;

/// site label.
@property(nonatomic, retain) UILabel *siteLabel;

/// referenced page.
@property(nonatomic, assign) NSUInteger page;

/// enables thumbnail shadow. defaults to YES.
@property(nonatomic, assign, getter=isShadowEnabled) BOOL shadowEnabled;

/// enable page label.
@property(nonatomic, assign, getter=isShowingSiteLabel) BOOL showingSiteLabel;

@end
