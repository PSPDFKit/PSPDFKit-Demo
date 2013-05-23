//
//  PSPDFThumbnailGridViewCell.h
//  PSPDFKit
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
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

/// Allow a margin. Defaults to UIEdgeInsetsZero.
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

/// Enables thumbnail shadow. defaults to YES, except on old devices.
@property (nonatomic, assign, getter=isShadowEnabled) BOOL shadowEnabled;

/// Enable page label.
@property (nonatomic, assign, getter=isShowingPageLabel) BOOL showingPageLabel;

/// This is simply a redeclaration of the property in UICollectionViewCell.
/// Modify this to change the look of the selection/highlight state.
@property (nonatomic, strong) UIView *selectedBackgroundView;

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

