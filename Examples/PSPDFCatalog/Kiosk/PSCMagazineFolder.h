//
//  PSPDFMagazineFolder.h
//  PSPDFCatalog
//
//  Copyright 2011-2013 Peter Steinberger. All rights reserved.
//

#define kPSPDFMagazineJSONURL @"http://pspdfkit.com/magazines.json"

@class PSCMagazine;

@interface PSCMagazineFolder : NSObject

+ (PSCMagazineFolder *)folderWithTitle:(NSString *)title;

// Array of PSPDFMagazine
@property (nonatomic, copy) NSArray *magazines;

/// The folder title
@property (nonatomic, copy) NSString *title;

- (BOOL)isSingleMagazine;

// Override to change sorting.
- (void)sortMagazines;

- (PSCMagazine *)firstMagazine;
- (void)addMagazine:(PSCMagazine *)magazine;
- (void)removeMagazine:(PSCMagazine *)magazine;

// Compare.
- (BOOL)isEqualToMagazineFolder:(PSCMagazineFolder *)otherMagazineFolder;

@end
