//
//  PSPDFSearchStatusCell.h
//  PSPDFKit
//
//  Copyright (c) 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFSearchViewController.h"

/// Cell that is used to display the search status.
@interface PSPDFSearchStatusCell : UITableViewCell

/// Updates the cell with the number of new search results.
- (void)updateCellWithSearchStatus:(PSPDFSearchStatus)searchStatus results:(NSUInteger)results page:(NSUInteger)page pageCount:(NSUInteger)pageCount;

/// Spinner that is displayed while search is in progress.
@property (nonatomic, strong, readonly) UIActivityIndicatorView *spinner;

@end
