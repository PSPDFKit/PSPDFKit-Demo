//
//  AMImageGridViewCell.h
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
}

@property(nonatomic, retain) UIImage *image;
@property(nonatomic, assign) NSUInteger magazineCount;

// don't set both
@property (nonatomic, retain) PSPDFMagazine *magazine;
@property (nonatomic, retain) PSPDFMagazineFolder *magazineFolder;

@end
