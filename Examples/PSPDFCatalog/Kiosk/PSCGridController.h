//
//  PSCGridController.h
//  PSPDFCatalog
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSCBasicViewController.h"
#import "PSCStoreManager.h"

@class PSCMagazineFolder;

@interface PSCGridController : PSCBasicViewController <PSCStoreManagerDelegate, PSUICollectionViewDataSource, PSUICollectionViewDelegate>

- (id)initWithMagazineFolder:(PSCMagazineFolder *)aMagazineFolder;
- (void)updateGrid;

@property (nonatomic, strong) PSUICollectionView *gridView;
@property (nonatomic, strong, readonly) PSCMagazineFolder *magazineFolder;

@end
