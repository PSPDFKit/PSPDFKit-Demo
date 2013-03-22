//
//  PSPDFThumbnailGridViewCell.h
//  PSPDFKit
//
//  Copyright 2011-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFRoundedLabel.h"
#import "PSTCollectionViewCell.h"

/// Simple thumbnail cell.
@interface PSPDFThumbnailGridViewCell : PSUICollectionViewCell <PSPDFCacheDelegate>

/// Referenced document.
@property (nonatomic, strong) PSPDFDocument *document;

/// Referenced page.
@property (nonatomic, assign) NSUInteger page;

/// Allow a margin. Defaults to 0,0,0,0.
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

/// Enables thumbnail shadow. defaults to YES, except on old devices.
@property (nonatomic, assign, getter=isShadowEnabled) BOOL shadowEnabled;

/// Enable page label.
@property (nonatomic, assign, getter=isShowingPageLabel) BOOL showingPageLabel;

/// Call before re-showing (will update bookmark status)
- (void)updateCell;

@end


@interface PSPDFThumbnailGridViewCell (Subclassing)

/// Internal image view.
@property (nonatomic, strong) UIImageView *imageView;

/// Page label. (By default a PSPDFRoundedLabel, but can be set to any UILabel subclass, simply do a cast)
@property (nonatomic, strong) PSPDFRoundedLabel *pageLabel;

/// Creates the shadow. Subclass to change. Returns a CGPathRef.
- (id)pathShadowForView:(UIView *)imgView;

/// Manually set image. use if you override class.
- (void)setImage:(UIImage *)image animated:(BOOL)animated;

/// Called when cell resizes. use in override class to re-position your content.
- (void)setImageSize:(CGSize)imageSize;

/// Updates the page label.
- (void)updatePageLabel;

@end

