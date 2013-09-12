//
//  PSPDFTextSearch.h
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
#import "PSPDFSearchOperation.h"

@class PSPDFDocument, PSPDFTextSearch;

/// Search status delegate. All delegates are guaranteed to be called within the main thread.
@protocol PSPDFTextSearchDelegate <NSObject>

@optional

/// Called when search is started.
- (void)willStartSearch:(PSPDFTextSearch *)textSearch term:(NSString *)searchTerm isFullSearch:(BOOL)isFullSearch;

/// Search was updated, a new page has been scanned.
- (void)didUpdateSearch:(PSPDFTextSearch *)textSearch term:(NSString *)searchTerm newSearchResults:(NSArray *)searchResults page:(NSUInteger)page;

/// Search has finished.
- (void)didFinishSearch:(PSPDFTextSearch *)textSearch term:(NSString *)searchTerm searchResults:(NSArray *)searchResults isFullSearch:(BOOL)isFullSearch;

/// Search has been cancelled.
- (void)didCancelSearch:(PSPDFTextSearch *)textSearch term:(NSString *)searchTerm isFullSearch:(BOOL)isFullSearch;

@end

/// Manages search operations for a specific document.
/// You can copy this class to be able to use it on your custom class. (and set a different delegate)
/// Copying will preserve all settings except the delegate.
@interface PSPDFTextSearch : NSObject <PSPDFSearchOperationDelegate, NSCopying>

/// Initialize with the document;
- (id)initWithDocument:(PSPDFDocument *)document;

/// Searches for text occurrence. If document was not yet parsed, it will be now. Searches entire document.
- (void)searchForString:(NSString *)searchTerm;

/// Searches for text on the specified page ranges. If ranges is nil, will search entire document.
/// If rangesOnly is set to NO, ranges will be searched first, then the rest of the document.
/// Tip: Use PSPDFIndexSetFromArray() to convert NSNumber-NSArrays to an NSIndexSet.
- (void)searchForString:(NSString *)searchTerm inRanges:(NSIndexSet *)ranges rangesOnly:(BOOL)rangesOnly;

/// Stops all operations. Blocks until all operations are finished.
- (void)cancelAllOperationsAndWait;

/// Changes the search mode. Default is PSPDFSearchModeHighlighting.
/// There's practically no speed difference so PSPDFSearchWithHighlighting should be preferred.
@property (nonatomic, assign) PSPDFSearchMode searchMode;

/// Defaults to NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch | NSWidthInsensitiveSearch | NSRegularExpressionSearch
/// With NSDiacriticInsensitiveSearch, e.g. an ö character will be treated like an o.
/// See NSString comparison documentation for details.
/// @note PSPDF has extensions that will allow a combination of NSRegularExpressionSearch and NSDiacriticInsensitiveSearch.
/// If NSRegularExpressionSearch is enabled, hyphenations and newlines between the body text will be ignored (which is good, better results)
@property (nonatomic, assign) NSStringCompareOptions compareOptions;

/// We have to limit the number of search results to something reasonable. Defaults to 600.
@property (nonatomic, assign) NSUInteger maximumNumberOfSearchResults;

/// The document that is searched.
@property (nonatomic, weak, readonly) PSPDFDocument *document;

/// Search delegate.
@property (atomic, weak) id<PSPDFTextSearchDelegate> delegate;

@end

@interface PSPDFTextSearch (SubclassingHooks)

@property (nonatomic, strong, readonly) NSOperationQueue *searchQueue;

@end

