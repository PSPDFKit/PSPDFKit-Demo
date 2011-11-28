//
//  PSPDFSearchViewController.h
//  PSPDFKit
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "TTTAttributedLabel.h"

@class PSPDFDocument, PSPDFViewController;

/// pdf search controller.
@interface PSPDFSearchViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate, PSPDFCacheDelegate>

/// initializes controller.
- (id)initWithDocument:(PSPDFDocument *)document pdfController:(PSPDFViewController *)pdfController;

/// different behavior depending on iPhone/iPad (on the iPhone, the controller is modal, else in a UIPopoverController)
@property(nonatomic, assign) BOOL showCancel;

/// search bar for controller.
@property(nonatomic, retain, readonly) UISearchBar *searchBar;

@end
