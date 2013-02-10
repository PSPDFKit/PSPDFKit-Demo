//
//  PSPDFSearchStatusCell.h
//  PSPDFKit
//
//  Copyright (c) 2011-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFSearchViewController.h"

///
/// Cell that is used to display the search status.
///
@interface PSPDFSearchStatusCell : UITableViewCell

/// Updates the cell with the number of new search results.
- (void)updateCellWithSearchStatus:(PSPDFSearchStatus)searchStatus results:(NSUInteger)results page:(NSUInteger)page pageCount:(NSUInteger)pageCount;

/// Spinner that is displayed while search is in progress.
@property (nonatomic, strong, readonly) UIActivityIndicatorView *spinner;

@end
