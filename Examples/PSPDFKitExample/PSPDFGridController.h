//
//  PSPDFGridController.h
//  PSPDFKitExample
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "PSPDFGridView.h"
#import "PSPDFBasicViewController.h"
#import "PSPDFStoreManager.h"

@class PSPDFMagazineFolder;

@interface PSPDFGridController : PSPDFBasicViewController <PSPDFStoreManagerDelegate, AQGridViewDelegate, AQGridViewDataSource> {    
    CGRect baseGridPosition_;
    NSUInteger lastNumbersOfItemsInGridView_;
}

- (id)initWithMagazineFolder:(PSPDFMagazineFolder *)aMagazineFolder;
- (void)updateGrid;

@property(nonatomic, strong) PSPDFGridView *gridView;
@property(nonatomic, strong, readonly) PSPDFMagazineFolder *magazineFolder;

@end
