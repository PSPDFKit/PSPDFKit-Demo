//
//  PSPDFMagazineFolder.h
//  PSPDFKitExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

@class PSPDFMagazine;

@interface PSPDFMagazineFolder : NSObject {
    NSMutableArray *magazines_;
}

+ (PSPDFMagazineFolder *)folderWithTitle:(NSString *)title;

@property (nonatomic, copy) NSArray *magazines; // PSPDFMagazine
@property (nonatomic, copy) NSString *title;

- (BOOL)isSingleMagazine;
- (void)sortMagazines;

- (PSPDFMagazine *)firstMagazine;
- (void)addMagazine:(PSPDFMagazine *)magazine;
- (void)removeMagazine:(PSPDFMagazine *)magazine;

@end
