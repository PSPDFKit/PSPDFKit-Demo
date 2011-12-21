//
//  PSPDFSearchStatusCell.h
//  PSPDFKit
//
//  Copyright (c) 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PSPDFKitGlobal.h"
#import "PSPDFSearchViewController.h"

@interface PSPDFSearchStatusCell : UITableViewCell

/// Updates the cell with the number of new search results.
- (void)updateCellWithSearchStatus:(PSPDFSearchStatus)searchStatus results:(NSUInteger)results;

/// Spinner that is displayed while search is in progress
@property(nonatomic, ps_weak, readonly) UIActivityIndicatorView *spinner;

@end
