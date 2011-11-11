//
//  PSPDFImageGridViewCell.h
//  PSPDFKitExample
//
//  Created by Peter Steinberger on 7/22/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

@class PSPDFMagazine, PSPDFMagazineFolder;

@interface PSPDFImageGridViewCell : PSPDFThumbnailGridViewCell {
    UIProgressView *progressView_;
    UIView *progressViewBackground_;
    UILabel *magazineCounter_;
    UIImageView *magazineCounterBadgeImage_;
    NSUInteger magazineCount_;
    
    PSPDFMagazine *magazine_;
    PSPDFMagazineFolder *magazineFolder_;
    NSMutableSet *observedMagazineDownloads_;
    
    // delete feature
    UIImageView *deleteImage_;
    BOOL showDeleteImage_;
}

@property(nonatomic, strong) UIImage *image;
@property(nonatomic, assign) NSUInteger magazineCount;

@property(nonatomic, assign) BOOL showDeleteImage;

// don't set both
@property (nonatomic, strong) PSPDFMagazine *magazine;
@property (nonatomic, strong) PSPDFMagazineFolder *magazineFolder;

@end
