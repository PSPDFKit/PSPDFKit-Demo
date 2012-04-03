//
//  PSPDFSearchViewController.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PSPDFAttributedLabel.h"
#import "PSPDFDocumentSearcher.h"
#import "PSPDFCache.h"

// used in UITableViewCell
#define kPSPDFAttributedLabelTag 25633

@class PSPDFDocument, PSPDFViewController, PSPDFSearchResult;

enum {
    PSPDFSearchIdle,
    PSPDFSearchActive,
    PSPDFSearchFinished,
    PSPDFSearchCancelled
}typedef PSPDFSearchStatus;

/// pdf search controller.
@interface PSPDFSearchViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate, PSPDFCacheDelegate, PSPDFSearchDelegate>

/// initializes controller.
- (id)initWithDocument:(PSPDFDocument *)document pdfController:(PSPDFViewController *)pdfController;

/// different behavior depending on iPhone/iPad (on the iPhone, the controller is modal, else in a UIPopoverController)
@property(nonatomic, assign) BOOL showCancel;

/// search bar for controller.
@property(nonatomic, strong, readonly) UISearchBar *searchBar;

/// Current search status. KVO ovserveable.
@property(nonatomic, assign, readonly) PSPDFSearchStatus searchStatus;

/// Set to your custom class if you need to override the search status cell
@property(nonatomic, copy) NSString *searchClassName;

/// Clears highlights when controller disappeares. Defaults to NO.
@property(nonatomic, assign) BOOL clearHighlightsWhenClosed;

/// If presented within a popoverController, it can be accessed here.
@property(nonatomic, ps_weak) UIPopoverController *popoverController;

// Updates the search result cell. Can be subclassed.
- (void)updateResultCell:(UITableViewCell *)cell searchResult:(PSPDFSearchResult *)searchResult;

@end
