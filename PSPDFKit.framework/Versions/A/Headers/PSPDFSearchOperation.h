//
//  PSPDFSearchOperation.h
//  PSPDFKit
//
//  Copyright (c) 2011-2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSPDFDocumentSearcher.h"
#import "PSPDFKitGlobal.h"

@class PSPDFDocument;

/// Search operation. Created within PSPDFDocumentSearcher.
@interface PSPDFSearchOperation : NSOperation

/// Initialize with Document reference and searchText.
- (id)initWithDocument:(PSPDFDocument *)document searchText:(NSString *)searchText;

/// Define which pages should be searched with selection metadata. (much slower)
/// If pageText is not set, this setting is ignored.
@property(nonatomic, copy) NSArray *selectionSearchPages;

/// If set, only the pages set in searchPages are searched (and also selectionSearchPages)
/// searchPages will be searched without selection (if text is already cached)
/// Set this to an empty array and use selectionSearchPages to make a limited search with selection.
@property(nonatomic, copy) NSArray *searchPages;

/// String to be searched for.
@property(nonatomic, copy, readonly) NSString *searchText;

/// Dictionary of the whole page text. Set to optimize - in connection with selectionSearchPages.
@property(nonatomic, strong) NSDictionary *pageTextDict;

/// Array of PSPDFSearchResult's.
@property(nonatomic, strong, readonly) NSArray *searchResults;

/// Associated document (weak, we're saved within the document)
@property(nonatomic, ps_weak, readonly) PSPDFDocument *document;

/// Search delegate. Will be retained as long as the operation runs.    
@property(nonatomic, ps_weak) id<PSPDFSearchDelegate> delegate;

/// Set the searchMode for the active search.
@property(nonatomic, assign) PSPDFSearchMode searchMode;

@end
