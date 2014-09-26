//
//  PSPDFInlineSearchManager.h
//  PSPDFKit
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFTextSearch.h"
#import "PSPDFSearchViewController.h" //HACK: imported because of 'PSPDFSearchStatus'
#import "PSPDFPresentationContext.h"

@class PSPDFInlineSearchManager;

/// The delegate for the `PSPDFInlineSearchManager` class.
@protocol PSPDFInlineSearchManagerDelegate <PSPDFTextSearchDelegate, PSPDFOverridable>

@optional

/// `searchResult` has been focussed.
- (void)inlineSearchManager:(PSPDFInlineSearchManager *)manager didFocusSearchResult:(PSPDFSearchResult *)searchResult;

/// All search results have been cleared.
- (void)inlineSearchManagerDidClearAllSearchResults:(PSPDFInlineSearchManager *)manager;

/// The inline search view will appear.
- (void)inlineSearchManagerSearchWillAppear:(PSPDFInlineSearchManager *)manager;

/// The inline search view did appear.
- (void)inlineSearchManagerSearchDidAppear:(PSPDFInlineSearchManager *)manager;

/// The inline search view will disappear.
- (void)inlineSearchManagerSearchWillDisappear:(PSPDFInlineSearchManager *)manager;

/// The inline search view did disappear.
- (void)inlineSearchManagerSearchDidDisappear:(PSPDFInlineSearchManager *)manager;

@end

/// Takes care about presentation of search UI and search processing of search results.
@interface PSPDFInlineSearchManager : NSObject

/// Search UI will be presented as as a subview of containerView and brought to front every time `presentInlineSearch` is called.
- (instancetype)initWithConfigurationDataSource:(id<PSPDFPresentationContext>)presentationContext containerView:(UIView *)containerView NS_DESIGNATED_INITIALIZER;

/// Presents search UI in provided container view with prefilled text.
- (void)presentInlineSearchWithSearchText:(NSString *)text;
/// Presents search UI in provided container.
- (void)presentInlineSearch;
/// Hides search UI.
- (BOOL)hideInlineSearch;
/// Hides the keyboard, but the search UI stays visible.
- (void)hideKeyboard;

/// Returns YES is search UI is visible. Returns yes even if search UI is currently being presented/dismissed.
- (BOOL)isSearchVisible;

/// The configuration data source for this class.
@property (nonatomic, weak) id<PSPDFPresentationContext> presentationContext;

/// Internally used `PSPDFTextSearch` object. (is a copy of the PSPDFTextSearch class in document)
@property (nonatomic, strong, readonly) PSPDFTextSearch *textSearch;

/// Current searchText.
@property (nonatomic, copy, readonly) NSString *searchText;

/// Currently loaded search results
@property (nonatomic, copy, readonly) NSArray *searchResults;

/// Current search status.
@property (nonatomic, assign, readonly) PSPDFSearchStatus searchStatus;

/// The inline search manager delegate that notifies show/hide and when a search result is focussed.
@property (nonatomic, weak) id <PSPDFInlineSearchManagerDelegate> delegate;

/// Assigning new document resets and hides search UI.
@property (nonatomic, strong) PSPDFDocument *document;

/// Defaults to 600. A too high number will be slow.
@property (nonatomic) NSUInteger maximumNumberOfSearchResultsDisplayed;

/// Will include annotations that have a matching type into the search results. (contents will be searched).
/// Defaults to PSPDFAnnotationTypeAll&~PSPDFAnnotationTypeLink.
/// @note Requires the `PSPDFFeatureMaskAnnotationEditing` feature flag.
@property (nonatomic, assign) PSPDFAnnotationType searchableAnnotationTypes;

/// Returns whether search UI is currently being presented.
@property (nonatomic, readonly, getter=isBeingPresented) BOOL beingPresented;

/// Returns whether search UI is currently being dismissed.
@property (nonatomic, readonly, getter=isBeingDismissed) BOOL beingDismissed;

@end
