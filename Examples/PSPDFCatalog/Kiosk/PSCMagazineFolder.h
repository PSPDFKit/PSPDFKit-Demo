//
//  PSPDFMagazineFolder.h
//  PSPDFCatalog
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#define kPSPDFMagazineJSONURL @"http://pspdfkit.com/magazines.json"

@class PSCMagazine;

@interface PSCMagazineFolder : NSObject {
    NSMutableArray *_magazines;
}

+ (PSCMagazineFolder *)folderWithTitle:(NSString *)title;

@property (nonatomic, copy) NSArray *magazines; // PSPDFMagazine
@property (nonatomic, copy) NSString *title;

- (BOOL)isSingleMagazine;
- (void)sortMagazines;

- (PSCMagazine *)firstMagazine;
- (void)addMagazine:(PSCMagazine *)magazine;
- (void)removeMagazine:(PSCMagazine *)magazine;

@end
