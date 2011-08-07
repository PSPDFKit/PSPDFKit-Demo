//
//  PSPDFMagazine.h
//  PSPDFKitExample
//
//  Created by Peter Steinberger on 7/22/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

@class PSPDFMagazineFolder;

@interface PSPDFMagazine : PSPDFDocument {
    BOOL downloading_;
    PSPDFMagazineFolder *folder_;
}

+ (PSPDFMagazine *)magazineWithPath:(NSString *)path;

- (UIImage *)coverImage;

/// magazine folder
@property(nonatomic, assign) PSPDFMagazineFolder *folder; // weak!

/// true if magazine is currently downloading
@property(nonatomic, assign, getter=isDownloading) BOOL downloading;

@end
