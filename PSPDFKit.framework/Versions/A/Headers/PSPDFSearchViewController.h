//
//  PSPDFSearchViewController.h
//  PSPDFKit
//
//  Created by Peter Steinberger on 7/20/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "TTTAttributedLabel.h"

@class PSPDFDocument;
@class PSPDFViewController;

/// simple search controller
@interface PSPDFSearchViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate, PSPDFCacheDelegate> {
    PSPDFDocument *document_;
    PSPDFViewController *pdfController_; // weak
    UISearchBar *searchBar_;
    NSArray *filteredListContent_;
    BOOL showCancel_; // for modal display
}

/// init
- (id)initWithDocument:(PSPDFDocument *)document pdfController:(PSPDFViewController *)pdfController;

/// different depending on iPhone/iPad
@property(nonatomic, assign) BOOL showCancel;

/// search bar for controller
@property(nonatomic, retain, readonly) UISearchBar *searchBar;

@end
