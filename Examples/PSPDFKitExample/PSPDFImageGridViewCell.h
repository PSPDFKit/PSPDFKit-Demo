//
//  PSPDFImageGridViewCell.h
//  PSPDFKitExample
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

@class PSPDFMagazine, PSPDFMagazineFolder;

@interface PSPDFImageGridViewCell : PSPDFThumbnailGridViewCell {
    UIView *progressViewBackground_;
    UILabel *magazineCounter_;
    UIImageView *magazineCounterBadgeImage_;
    NSMutableSet *observedMagazineDownloads_;
    UIImageView *deleteImage_;
}

@property(nonatomic, strong) UIImage *image;
@property(nonatomic, assign) NSUInteger magazineCount;

@property(nonatomic, assign) BOOL showDeleteImage;

// don't set both
@property (nonatomic, strong) PSPDFMagazine *magazine;
@property (nonatomic, strong) PSPDFMagazineFolder *magazineFolder;

@end
