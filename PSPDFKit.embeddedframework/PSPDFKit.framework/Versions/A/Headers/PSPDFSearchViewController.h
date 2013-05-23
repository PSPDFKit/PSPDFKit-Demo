//
//  PSPDFSearchViewController.h
//  PSPDFKit
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFAttributedLabel.h"
#import "PSPDFTextSearch.h"
#import "PSPDFCache.h"
#import "PSPDFExtendedPopoverController.h"
#import "PSPDFStatusBarStyleHint.h"
#import "PSPDFStyleable.h"

@class PSPDFDocument, PSPDFViewController, PSPDFSearchResult, PSPDFSearchResultCell;

typedef NS_ENUM(NSInteger, PSPDFSearchStatus) {
    PSPDFSearchStatusIdle,
    PSPDFSearchStatusActive,
    PSPDFSearchStatusFinished,
    PSPDFSearchStatusCancelled
};

// Default value is 2. You might want to change this for asian languages.
// (In the latin alphabet; searching for a single character is of not much use)
extern NSUInteger kPSPDFMinimumSearchLength;

@class PSPDFSearchViewController;

/// Delegate for the search view controller.
@protocol PSPDFSearchViewControllerDelegate <PSPDFTextSearchDelegate>

@optional

/// Called when the user taps on a controller result cell.
- (void)searchViewController:(PSPDFSearchViewController *)searchController didTapSearchResult:(PSPDFSearchResult *)searchResult;

/// Will be called when the controller clears all search results.
- (void)searchViewControllerDidClearAllSearchResults:(PSPDFSearchViewController *)searchController;

/// Asks for the visible pages to optimize search ordering.
- (NSArray *)searchViewControllerGetVisiblePages:(PSPDFSearchViewController *)searchController;

/// Allows to provide custom subclasses of PSPDFSearchStatusCell/PSPDFSearchResultCell.
- (Class)searchViewController:(PSPDFSearchViewController *)searchController cellForClass:(Class)cellClass;

@end

/// The PDF search controller.
@interface PSPDFSearchViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate, PSPDFCacheDelegate, PSPDFTextSearchDelegate, PSPDFStatusBarStyleHint, PSPDFStyleable, PSPDFPopoverControllerDismissable>

/// initializes controller.
- (id)initWithDocument:(PSPDFDocument *)document delegate:(id<PSPDFSearchViewControllerDelegate>)delegate;

/// Current searchText. If set, keyboard is not shown.
@property (nonatomic, copy) NSString *searchText;

/// Different behavior depending on iPhone/iPad (on the iPhone, the controller is modal, else in a UIPopoverController)
/// @note This is set from PSPDFViewController in presentModalViewController:embeddedInNavigationController:withCloseButton:animated.
@property (nonatomic, assign) BOOL showsCancelButton;

/// Search bar for controller.
/// You can change attributes (e.g. barStyle) but don't change the delegate!
@property (nonatomic, strong, readonly) UISearchBar *searchBar;

/// Current search status. KVO observable.
@property (nonatomic, assign, readonly) PSPDFSearchStatus searchStatus;

/// Clears highlights when controller disappears. Defaults to NO.
@property (nonatomic, assign) BOOL clearHighlightsWhenClosed;

/// Defaults to 600. A too high number will be slow.
@property (nonatomic, assign) NSUInteger maximumNumberOfSearchResultsDisplayed;

/// Set to enable searching on the visible pages, then all. Was default until PSPDFKit 2.4.1. Defaults to NO.
/// If not set, the natural page order is searched.
@property (nonatomic, assign) BOOL searchVisiblePagesFirst;

/// Internally used textSearch. (is a copy of the textSearch class in document)
@property (nonatomic, strong, readonly) PSPDFTextSearch *textSearch;

/// The delegate.
@property (nonatomic, weak) id<PSPDFSearchViewControllerDelegate> delegate;

// Updates the search result cell. Can be subclassed.
// To customize the label search the subviews for the PSPDFAttributedLabel class.
- (void)updateResultCell:(PSPDFSearchResultCell *)cell searchResult:(PSPDFSearchResult *)searchResult;

@end

@interface PSPDFSearchViewController (SubclassingHooks)

// Called every time the text in the search bar changes. Scope is currently ignored.
- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope;

// Will update the status and insert/reload/remove search rows
- (void)setSearchStatus:(PSPDFSearchStatus)searchStatus updateTable:(BOOL)updateTable;

// Returns the searchResult for a cell.
- (PSPDFSearchResult *)searchResultForIndexPath:(NSIndexPath *)indexPath;

// Currently loaded search results
@property (nonatomic, copy, readonly) NSArray *searchResults;

@end
