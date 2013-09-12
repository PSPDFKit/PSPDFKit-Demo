//
//  PSPDFSearchOperation.h
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
#import "PSPDFTextSearch.h"

@class PSPDFDocument, PSPDFSearchOperation;

typedef NS_ENUM(NSInteger, PSPDFSearchMode) {
    PSPDFSearchModeBasic,        // don't show highlight positions
    PSPDFSearchModeHighlighting, // show highlights
};

/// Get updates while the search operation is running.
@protocol PSPDFSearchOperationDelegate <NSObject>

/// Search was updated, a new page has been scanned
- (void)didUpdateSearchOperation:(PSPDFSearchOperation *)operation forString:(NSString *)searchTerm newSearchResults:(NSArray *)searchResults forPage:(NSUInteger)page;

@optional

/// Called when search is started.
- (void)willStartSearchOperation:(PSPDFSearchOperation *)operation forString:(NSString *)searchTerm isFullSearch:(BOOL)isFullSearch;

@end

/// Search operation to find text inside a all or specific pages of a PSPDFDocument.
/// Usually created within PSPDFTextSearch, but can also be used externally.
/// @note Normally you want to use the PSPDFTextSearch instead of using this operation directly.
@interface PSPDFSearchOperation : NSOperation

/// Initialize with document reference and the search term.
- (id)initWithDocument:(PSPDFDocument *)document searchTerm:(NSString *)searchTerm;

/// Customize range of pages that should be searched. Set to nil to search whole document.
/// Hint: Use PSPDFIndexSetFromArray() to convert NSNumber-NSArrays to an NSIndexSet.
@property (nonatomic, copy) NSIndexSet *pageRanges;

/// If set to YES, pageRanges will be searched first, then all following pages.
/// If NO, only pageRanges will be searched.
@property (nonatomic, assign) BOOL shouldSearchAllPages;

/// We have to limit the number of search results to something reasonable (memory constraints)
@property (nonatomic, assign) NSUInteger maximumNumberOfSearchResults;

/// Set the searchMode for the search. Defaults to PSPDFSearchModeHighlighting.
@property (nonatomic, assign) PSPDFSearchMode searchMode;

/// Set compareOptions for the search.
@property (nonatomic, assign) NSStringCompareOptions compareOptions;

/// Search delegate.
@property (nonatomic, weak) id<PSPDFSearchOperationDelegate> delegate;

/// Array of PSPDFSearchResult (will be set once the operation is finished)
@property (nonatomic, copy, readonly) NSArray *searchResults;

/// Current search term.
@property (nonatomic, copy, readonly) NSString *searchTerm;

/// Associated document.
@property (nonatomic, weak, readonly) PSPDFDocument *document;

@end
