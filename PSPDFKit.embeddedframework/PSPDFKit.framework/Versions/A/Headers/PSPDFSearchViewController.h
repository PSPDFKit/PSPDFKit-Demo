//
//  PSPDFSearchViewController.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFAttributedLabel.h"
#import "PSPDFTextSearch.h"
#import "PSPDFCache.h"
#import "PSPDFViewController.h"

@class PSPDFDocument, PSPDFViewController, PSPDFSearchResult;

typedef NS_ENUM(NSInteger, PSPDFSearchStatus) {
    PSPDFSearchIdle,
    PSPDFSearchActive,
    PSPDFSearchFinished,
    PSPDFSearchCancelled
};

// Default value is 2. You might wanna change this for asian languages.
// (In the latin alphabeth; searching for a single character is of not much use)
extern NSUInteger kPSPDFMinimumSearchLength;

/// pdf search controller.
@interface PSPDFSearchViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate, PSPDFCacheDelegate, PSPDFSearchDelegate, PSPDFStatusBarStyleHint>

/// initializes controller.
- (id)initWithDocument:(PSPDFDocument *)document pdfController:(PSPDFViewController *)pdfController;

/// Current searchText. If set, keyboard is not shown
@property(nonatomic, copy) NSString *searchText;

/// different behavior depending on iPhone/iPad (on the iPhone, the controller is modal, else in a UIPopoverController)
/// Note: this is set from PSPDFViewController in presentModalViewController:embeddedInNavigationController:withCloseButton:animated.
@property(nonatomic, assign) BOOL showsCancelButton;

/// search bar for controller.
/// You can change attributes (e.g. barStyle) but don't change the delegate!
@property(nonatomic, strong, readonly) UISearchBar *searchBar;

/// Current search status. KVO ovserveable.
@property(nonatomic, assign, readonly) PSPDFSearchStatus searchStatus;

/// Clears highlights when controller disappeares. Defaults to NO.
@property(nonatomic, assign) BOOL clearHighlightsWhenClosed;

// Updates the search result cell. Can be subclassed.
// To customize the label search the subvies for the PSPDFAttributedLabel class.
- (void)updateResultCell:(UITableViewCell *)cell searchResult:(PSPDFSearchResult *)searchResult;

@end
