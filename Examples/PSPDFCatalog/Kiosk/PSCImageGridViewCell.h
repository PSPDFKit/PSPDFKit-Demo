//
//  PSPDFImageGridViewCell.h
//  PSPDFCatalog
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PSCMagazine, PSCMagazineFolder;

/// Cell for PDF magazines. Adds support for deleting.
@interface PSCImageGridViewCell : PSPDFThumbnailGridViewCell

/// Relays image to internal image of PSPDFThumbnailGridViewCell.
@property (nonatomic, strong) UIImage *image;

/// Set magazineCount badge for a PSPDFMagazineFolder.
@property (nonatomic, assign) NSUInteger magazineCount;

/// Cell may contain a magazine or a folder. don't set both.
@property (nonatomic, strong) PSCMagazine *magazine;
@property (nonatomic, strong) PSCMagazineFolder *magazineFolder;

/// If set to YES, image is loaded synchronously, not via a thread.
@property (nonatomic, assign) BOOL immediatelyLoadCellImages;

/// Delete button shown in edit mode.
@property (nonatomic, strong) UIButton *deleteButton;

/// Show delete image on the top left of the cell image.
@property (nonatomic, assign) BOOL showDeleteImage;

@end
