//
//  PSPDFSearchViewController.h
//  PSPDFKit
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFTextSearch.h"
#import "PSPDFCache.h"
#import "PSPDFExtendedPopoverController.h"
#import "PSPDFStatusBarStyleHint.h"
#import "PSPDFStyleable.h"
#import "PSPDFBaseTableViewController.h"

@class PSPDFDocument, PSPDFViewController, PSPDFSearchResult, PSPDFSearchResultCell;

typedef NS_ENUM(NSInteger, PSPDFSearchStatus) {
    PSPDFSearchStatusIdle,
    PSPDFSearchStatusActive,
    PSPDFSearchStatusFinished,
    PSPDFSearchStatusCancelled
};

// Default value is 2. You might want to change this for Asian languages.
// (In the Latin alphabet; searching for a single character is of not much use)
extern NSUInteger PSPDFMinimumSearchLength;

@class PSPDFSearchViewController;

/// Delegate for the search view controller.
@protocol PSPDFSearchViewControllerDelegate <PSPDFTextSearchDelegate, PSPDFOverridable>

@optional

/// Called when the user taps on a controller result cell.
- (void)searchViewController:(PSPDFSearchViewController *)searchController didTapSearchResult:(PSPDFSearchResult *)searchResult;

/// Will be called when the controller clears all search results.
- (void)searchViewControllerDidClearAllSearchResults:(PSPDFSearchViewController *)searchController;

/// Asks for the visible pages to optimize search ordering.
- (NSArray *)searchViewControllerGetVisiblePages:(PSPDFSearchViewController *)searchController;

/// Allows to narrow down the search rage if a scope is set.
- (NSIndexSet *)searchViewController:(PSPDFSearchViewController *)searchController searchRangeForScope:(NSString *)scope;

@end

/// The PDF search view controller.
@interface PSPDFSearchViewController : PSPDFBaseTableViewController <UISearchDisplayDelegate, UISearchBarDelegate, PSPDFTextSearchDelegate, PSPDFStatusBarStyleHint, PSPDFStyleable, PSPDFPopoverControllerDismissable>

/// Designated initializer.
- (id)initWithDocument:(PSPDFDocument *)document delegate:(id<PSPDFSearchViewControllerDelegate>)delegate;

/// Current searchText. If set before showing the controller, keyboard will not be added.
@property (nonatomic, copy) NSString *searchText;

/// Different behavior depending on iPhone/iPad (on the iPhone, the controller is modal, else in a `UIPopoverController`)
@property (nonatomic, assign) BOOL showsCancelButton;

/// Search bar for controller.
/// @warning You can change attributes (e.g. `barStyle`) but don't change the delegate!
@property (nonatomic, strong, readonly) UISearchBar *searchBar;

/// Current search status. KVO observable.
@property (nonatomic, assign, readonly) PSPDFSearchStatus searchStatus;

/// Clears highlights when controller disappears. Defaults to NO.
@property (nonatomic, assign) BOOL clearHighlightsWhenClosed;

/// Defaults to 600. A too high number will be slow.
@property (nonatomic, assign) NSUInteger maximumNumberOfSearchResultsDisplayed;

/// Set to enable searching on the visible pages, then all. Defaults to NO.
/// If not set, the natural page order is searched.
@property (nonatomic, assign) BOOL searchVisiblePagesFirst;

/// Number of lines to show preview text. Defaults to 2.
@property (nonatomic, assign) NSUInteger numberOfPreviewTextLines;

/// Searches the outline for the most matching entry, displays e.g. "Section 100, Page 2" instead of just "Page 2".
/// Defaults to YES.
@property (nonatomic, assign) BOOL useOutlineForPageNames;

/// Internally used `PSPDFTextSearch` object. (is a copy of the PSPDFTextSearch class in document)
@property (nonatomic, strong, readonly) PSPDFTextSearch *textSearch;

/// The search view controller delegate.
@property (nonatomic, weak) id<PSPDFSearchViewControllerDelegate> delegate;

@end

@interface PSPDFSearchViewController (SubclassingHooks)

// Called every time the text in the search bar changes.
- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope;

// Will update the status and insert/reload/remove search rows
- (void)setSearchStatus:(PSPDFSearchStatus)searchStatus updateTable:(BOOL)updateTable;

// Returns the searchResult for a cell.
- (PSPDFSearchResult *)searchResultForIndexPath:(NSIndexPath *)indexPath;

// Currently loaded search results
@property (nonatomic, copy, readonly) NSArray *searchResults;

@end
