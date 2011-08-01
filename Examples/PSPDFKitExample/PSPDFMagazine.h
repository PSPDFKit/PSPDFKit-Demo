//
//  PSPDFMagazine.h
//  PSPDFKitExample
//
//  Created by Peter Steinberger on 7/22/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//


@class PSPDFMagazineFolder;

@interface PSPDFMagazine : PSPDFDocument {
    PSPDFMagazineFolder *folder_;
}

@property (nonatomic, assign) PSPDFMagazineFolder *folder; // weak!

+ (PSPDFMagazine *)magazineWithPath:(NSString *)path;

- (UIImage *)coverImage;

@end
