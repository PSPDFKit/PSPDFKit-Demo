//
//  PSPDFGridController.h
//  PSPDFKitExample
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "PSPDFBasicViewController.h"
#import "PSPDFStoreManager.h"

@class PSPDFMagazineFolder;

@interface PSPDFGridController : PSPDFBasicViewController <PSPDFStoreManagerDelegate, GMGridViewActionDelegate, GMGridViewDataSource> {    
    CGRect baseGridPosition_;
}

- (id)initWithMagazineFolder:(PSPDFMagazineFolder *)aMagazineFolder;
- (void)updateGrid;

@property(nonatomic, strong) GMGridView *gridView;
@property(nonatomic, strong, readonly) PSPDFMagazineFolder *magazineFolder;

@end
