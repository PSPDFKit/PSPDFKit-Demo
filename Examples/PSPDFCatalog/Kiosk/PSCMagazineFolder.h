//
//  PSPDFMagazineFolder.h
//  PSPDFCatalog
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
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
