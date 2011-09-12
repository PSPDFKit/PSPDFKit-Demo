//
//  PSPDFMagazine.h
//  PSPDFKitExample
//
//  Created by Peter Steinberger on 7/22/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

@class PSPDFMagazineFolder;

@interface PSPDFMagazine : PSPDFDocument {
    BOOL available_;
    BOOL downloading_;
    PSPDFMagazineFolder *folder_;
    NSURL *url_;
    NSURL *imageUrl_;
}

+ (PSPDFMagazine *)magazineWithPath:(NSString *)path;

- (UIImage *)coverImage;

/// magazine folder
@property(nonatomic, assign) PSPDFMagazineFolder *folder; // weak!

/// url for downloading the pdf
@property(nonatomic, retain) NSURL *url;

// url for downloading image
@property(nonatomic, retain) NSURL *imageUrl;

/// true if magazine is currently downloading
@property(nonatomic, assign, getter=isDownloading) BOOL downloading;

/// true if magazine is on-disk and/or sucessfully downloaded
@property(nonatomic, assign, getter=isAvailable) BOOL available;

@end
