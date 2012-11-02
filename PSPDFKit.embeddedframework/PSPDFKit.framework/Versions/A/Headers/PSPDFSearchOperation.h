//
//  PSPDFSearchOperation.h
//  PSPDFKit
//
//  Copyright (c) 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFTextSearch.h"

@class PSPDFDocument, PSPDFSearchOperation;

typedef NS_ENUM(NSInteger, PSPDFSearchMode) {
    PSPDFBasicSearch,
    PSPDFSearchWithHighlighting
};

/// Get updates while the search operation is running.
@protocol PSPDFSearchOperationDelegate <NSObject>

/// Search was updated, a new page has been scanned
- (void)didUpdateSearchOperation:(PSPDFSearchOperation *)operation forString:(NSString *)searchTerm newSearchResults:(NSArray *)searchResults forPage:(NSUInteger)page;

@optional

/// Called when search is started. 
- (void)willStartSearchOperation:(PSPDFSearchOperation *)operation forString:(NSString *)searchTerm isFullSearch:(BOOL)isFullSearch;

@end


/// Search operation. Created within PSPDFTextSearch.
@interface PSPDFSearchOperation : NSOperation

/// Initialize with Document reference and searchText.
- (id)initWithDocument:(PSPDFDocument *)document searchTerm:(NSString *)searchTerm;

/// Define which pages should be searched with selection metadata. (much slower)
/// If pageText is not set, this setting is ignored.
@property (nonatomic, copy) NSArray *selectionSearchPages;

/// If set, only the pages set in searchPages are searched (and also selectionSearchPages)
/// searchPages will be searched without selection (if text is already cached)
/// Set this to an empty array and use selectionSearchPages to make a limited search with selection.
@property (nonatomic, copy) NSArray *searchPages;

/// String to be searched for.
@property (nonatomic, copy, readonly) NSString *searchTerm;

/// Dictionary of the whole page text. Set to optimize - in connection with selectionSearchPages.
@property (nonatomic, strong) NSDictionary *pageTextDict;

/// Array of PSPDFSearchResult's.
@property (nonatomic, strong, readonly) NSArray *searchResults;

/// Associated document (weak, we're saved within the document)
@property (nonatomic, weak, readonly) PSPDFDocument *document;

/// Search delegate. Will be retained as long as the operation runs.    
@property (nonatomic, weak) id<PSPDFSearchOperationDelegate> delegate;

/// Set the searchMode for the search.
@property (nonatomic, assign) PSPDFSearchMode searchMode;

/// Set compareOptions for the search.
@property (nonatomic, assign) NSStringCompareOptions compareOptions;

@end
