//
//  PSPDFImageGridViewCell.h
//  PSPDFKitExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PSCMagazine, PSCMagazineFolder;

/// Cell for pdf magazines. Adds support for deleting.
@interface PSCImageGridViewCell : PSPDFThumbnailGridViewCell

/// Relays image to internal image of PSPDFThumbnailGridViewCell.
@property(nonatomic, strong) UIImage *image;

/// Set magazineCount badge for a PSPDFMagazineFolder.
@property(nonatomic, assign) NSUInteger magazineCount;

// Cell may contain a magazine or a folder. don't set both.
@property(nonatomic, strong) PSCMagazine *magazine;
@property(nonatomic, strong) PSCMagazineFolder *magazineFolder;

// If set to YES, image is loaded synchronously, not via threads.
@property(nonatomic, assign) BOOL immediatelyLoadCellImages;

@end
