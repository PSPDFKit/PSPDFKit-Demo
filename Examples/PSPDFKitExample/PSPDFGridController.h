//
//  PSPDFGridController.h
//  PSPDFKitExample
//
//  Created by Peter Steinberger on 7/22/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSPDFGridView.h"
#import "PSPDFBasicViewController.h"
#import "PSPDFStoreManager.h"

@class PSPDFMagazineFolder;

@interface PSPDFGridController : PSPDFBasicViewController <PSPDFStoreManagerDelegate, AQGridViewDelegate, AQGridViewDataSource> {
    PSPDFMagazineFolder *magazineFolder_;  
    PSPDFGridView *gridView_;
    
    CGRect baseGridPosition_;
    UIView *magazineView_;
    
    NSUInteger lastNumbersOfItemsInGridView_;
    BOOL editMode_;
}

- (id)initWithMagazineFolder:(PSPDFMagazineFolder *)aMagazineFolder;
- (void)updateGrid;

@property(nonatomic, retain) PSPDFGridView *gridView;
@property(nonatomic, retain, readonly) PSPDFMagazineFolder *magazineFolder;

@end
