//
//  PSCGridController.h
//  PSPDFCatalog
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCBasicViewController.h"
#import "PSCStoreManager.h"

@class PSCMagazineFolder;

// Displays a grid of elements from the `PSCStoreManager`.
@interface PSCGridViewController : PSCBasicViewController <PSCStoreManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

// Designated initializer.
- (id)initWithMagazineFolder:(PSCMagazineFolder *)aMagazineFolder;

// Force-update grid.
- (void)updateGrid;

// Grid that's used internally.
@property (nonatomic, strong) UICollectionView *collectionView;

// Magazine-folder, if one is selected.
@property (nonatomic, strong, readonly) PSCMagazineFolder *magazineFolder;

@end
