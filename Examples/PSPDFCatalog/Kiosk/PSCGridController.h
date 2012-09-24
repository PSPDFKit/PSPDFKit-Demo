//
//  PSCGridController.h
//  PSPDFKitExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSCBasicViewController.h"
#import "PSCStoreManager.h"

@class PSCMagazineFolder;

@interface PSCGridController : PSCBasicViewController <PSCStoreManagerDelegate, PSTCollectionViewDataSource, PSTCollectionViewDelegate>

- (id)initWithMagazineFolder:(PSCMagazineFolder *)aMagazineFolder;
- (void)updateGrid;

@property (nonatomic, strong) PSTCollectionView *gridView;
@property (nonatomic, strong, readonly) PSCMagazineFolder *magazineFolder;

@end
