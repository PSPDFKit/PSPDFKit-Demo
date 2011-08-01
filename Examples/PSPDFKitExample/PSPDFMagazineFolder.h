//
//  PSPDFMagazineFolder.h
//  PSPDFKitExample
//
//  Created by Peter Steinberger on 7/22/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

@class PSPDFMagazine;

@interface PSPDFMagazineFolder : NSObject {
  NSMutableArray *magazines_;
}

+ (PSPDFMagazineFolder *)folderWithTitle:(NSString *)title;

@property (nonatomic, copy) NSArray *magazines; // PSPDFMagazine
@property (nonatomic, copy) NSString *title;

- (BOOL)isSingleMagazine;

- (PSPDFMagazine *)firstMagazine;
- (void)addMagazine:(PSPDFMagazine *)magazine;
- (void)removeMagazine:(PSPDFMagazine *)magazine;

@end
