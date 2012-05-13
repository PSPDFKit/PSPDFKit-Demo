//
//  PSPDFMagazine.h
//  PSPDFKitExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

@class PSPDFMagazineFolder;

/// Represents a magazine in the PDFKitExample.
@interface PSPDFMagazine : PSPDFDocument

/// Initializes a magazine object with the specified path.
+ (PSPDFMagazine *)magazineWithPath:(NSString *)path;

/// Returns the coverImage, which is the first page of the magazine.
/// Here we download that from the web to have sth to show before the pdf is available.
- (UIImage *)coverImageForSize:(CGSize)size;

/// Magazine folder. Weak to break the retain cycle.
@property(nonatomic, ps_weak) PSPDFMagazineFolder *folder; // weak!

/// Url for downloading the pdf.
@property(nonatomic, strong) NSURL *url;

// Url for downloading image.
@property(nonatomic, strong) NSURL *imageUrl;

/// UES if magazine is currently downloading.
@property(nonatomic, assign, getter=isDownloading) BOOL downloading;

/// YES if magazine is on-disk and/or sucessfully downloaded.
@property(nonatomic, assign, getter=isAvailable) BOOL available;

/// YES if the magazine can be deleted. NO if it's within the app bundle, which can't be edited.
@property(nonatomic, assign, getter=isDeletable, readonly) BOOL deletable;

@end
