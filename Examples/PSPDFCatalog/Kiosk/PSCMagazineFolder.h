//
//  PSPDFMagazineFolder.h
//  PSPDFCatalog
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#define PSCMagazineJSONURL @"http://pspdfkit.com/magazines.json"

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
