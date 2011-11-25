//
//  PSPDFMagazine.h
//  PSPDFKitExample
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

@class PSPDFMagazineFolder;

@interface PSPDFMagazine : PSPDFDocument

+ (PSPDFMagazine *)magazineWithPath:(NSString *)path;

- (UIImage *)coverImage;

/// magazine folder
@property(nonatomic, ps_weak) PSPDFMagazineFolder *folder; // weak!

/// url for downloading the pdf
@property(nonatomic, strong) NSURL *url;

// url for downloading image
@property(nonatomic, strong) NSURL *imageUrl;

/// true if magazine is currently downloading
@property(nonatomic, assign, getter=isDownloading) BOOL downloading;

/// true if magazine is on-disk and/or sucessfully downloaded
@property(nonatomic, assign, getter=isAvailable) BOOL available;

@end
