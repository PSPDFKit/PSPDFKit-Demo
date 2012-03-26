//
//  PSPDFImageGridViewCell.h
//  PSPDFKitExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PSPDFMagazine, PSPDFMagazineFolder;

/// Cell for pdf magazines. Adds support for deleting.
@interface PSPDFImageGridViewCell : PSPDFThumbnailGridViewCell {
    UIView *progressViewBackground_;
    UILabel *magazineCounter_;
    UIImageView *magazineCounterBadgeImage_;
    NSMutableSet *observedMagazineDownloads_;
}

/// Relays image to internal image of PSPDFThumbnailGridViewCell.
@property(nonatomic, strong) UIImage *image;

/// Set magazineCount badge for a PSPDFMagazineFolder.
@property(nonatomic, assign) NSUInteger magazineCount;

// don't set both
@property (nonatomic, strong) PSPDFMagazine *magazine;
@property (nonatomic, strong) PSPDFMagazineFolder *magazineFolder;

@end
