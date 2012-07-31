//
//  PSPDFGridController.h
//  PSPDFKitExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFBasicViewController.h"
#import "PSPDFStoreManager.h"

@class PSPDFMagazineFolder;

@interface PSPDFGridController : PSPDFBasicViewController <PSPDFStoreManagerDelegate, PSCollectionViewDataSource, PSCollectionViewDelegate>

- (id)initWithMagazineFolder:(PSPDFMagazineFolder *)aMagazineFolder;
- (void)updateGrid;

@property(nonatomic, strong) PSCollectionView *gridView;
@property(nonatomic, strong, readonly) PSPDFMagazineFolder *magazineFolder;

@end
