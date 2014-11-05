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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PSPDFBaseTableViewController.h"
#import "PSPDFTextSearch.h"
#import "PSPDFAnnotation.h"
#import "PSPDFStyleable.h"
#import "PSPDFCache.h"
#import "PSPDFOverridable.h"

@class PSPDFDocument, PSPDFViewController, PSPDFSearchResult, PSPDFSearchResultCell;

typedef NS_ENUM(NSInteger, PSPDFSearchStatus) {
    PSPDFSearchStatusIdle,           /// Search hasn't started yet.
    PSPDFSearchStatusActive,         /// Search operation is running.
    PSPDFSearchStatusFinished,       /// Search has been finished.
    PSPDFSearchStatusFinishedNoText, /// Search finished but there wasn't any content to search.
    PSPDFSearchStatusCancelled       /// Search has been cancelled.
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

/// Requests the text search class. Creates a custom class if not implemented.
- (PSPDFTextSearch *)searchViewControllerTextSearchObject:(PSPDFSearchViewController *)searchController;

@end

/// Allows to search within the current `document`.
@interface PSPDFSearchViewController : PSPDFBaseTableViewController <UISearchDisplayDelegate, UISearchBarDelegate, PSPDFTextSearchDelegate, PSPDFStyleable>

/// Designated initializer.
- (instancetype)initWithDocument:(PSPDFDocument *)document delegate:(id<PSPDFSearchViewControllerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

/// The current document.
@property (nonatomic, strong) PSPDFDocument *document;

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

/// Will include annotations that have a matching type into the search results. (contents will be searched).
/// Defaults to PSPDFAnnotationTypeAll&~PSPDFAnnotationTypeLink.
/// @note Requires the `PSPDFFeatureMaskAnnotationEditing` feature flag.
@property (nonatomic, assign) PSPDFAnnotationType searchableAnnotationTypes;

/// Pins the search bar to the top. Defaults to YES on iPhone.
/// @note Has to be set before the view is created.
@property (nonatomic, assign) BOOL pinSearchBarToHeader;

/// Internally used `PSPDFTextSearch` object. (is a copy of the PSPDFTextSearch class in document)
@property (nonatomic, strong, readonly) PSPDFTextSearch *textSearch;

/// The search view controller delegate.
@property (nonatomic, weak) id<PSPDFSearchViewControllerDelegate> delegate;

/// Call to force a search restart. Useful if the underlying content has changed.
- (void)restartSearch;

@end

@interface PSPDFSearchViewController (SubclassingHooks)

// Called every time the text in the search bar changes.
- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope;

// Will update the status and insert/reload/remove search rows
- (void)setSearchStatus:(PSPDFSearchStatus)searchStatus updateTable:(BOOL)updateTable;

// Returns the searchResult for a cell.
- (PSPDFSearchResult *)searchResultForIndexPath:(NSIndexPath *)indexPath;

// Will return a searchbar. Called during `viewDidLoad`. Use to customize the toolbar.
// This method does basic properties like `tintColor`, `showsCancelButton` and `placeholder`.
// After calling this, the delegate will be set to this class.
- (UISearchBar *)createSearchBar;

// Currently loaded search results
@property (nonatomic, copy, readonly) NSArray *searchResults;

@end
