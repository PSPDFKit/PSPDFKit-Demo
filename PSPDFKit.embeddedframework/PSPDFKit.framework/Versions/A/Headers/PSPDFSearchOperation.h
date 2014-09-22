//
//  PSPDFSearchOperation.h
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
#import "PSPDFAnnotation.h"

@class PSPDFDocument, PSPDFSearchOperation;

/// Get updates while the search operation is running.
@protocol PSPDFSearchOperationDelegate <NSObject>

/// Search was updated, a new page has been scanned.
- (void)didUpdateSearchOperation:(PSPDFSearchOperation *)operation forString:(NSString *)searchTerm newSearchResults:(NSArray *)searchResults forPage:(NSUInteger)page;

@optional

/// Called when search is started.
- (void)willStartSearchOperation:(PSPDFSearchOperation *)operation forString:(NSString *)searchTerm isFullSearch:(BOOL)isFullSearch;

@end

/// Search operation to find text inside a all or specific pages of a `PSPDFDocument`.
/// Usually created within `PSPDFTextSearch`, but can also be used externally.
/// @note Normally you want to use the `PSPDFTextSearch` instead of using this operation directly.
@interface PSPDFSearchOperation : NSOperation

/// Initialize with document reference and the search term.
- (instancetype)initWithDocument:(PSPDFDocument *)document searchTerm:(NSString *)searchTerm NS_DESIGNATED_INITIALIZER;

/// Customize range of pages that should be searched. Set to nil to search whole document.
/// @note See `psc_indexSet` to convert `NSNumber-NSArrays` to an `NSIndexSet`.
@property (nonatomic, copy) NSIndexSet *pageRanges;

/// If set to YES, `pageRanges` will be searched first, then all following pages.
/// If NO, only `pageRanges` will be searched.
@property (nonatomic, assign) BOOL shouldSearchAllPages;

/// We have to limit the number of search results to something reasonable (memory constraints)
@property (nonatomic, assign) NSUInteger maximumNumberOfSearchResults;

/// Set compareOptions for the search.
@property (nonatomic, assign) NSStringCompareOptions compareOptions;

/// Will include annotations that have a matching type into the search results. (contents will be searched).
/// @note Requires the `PSPDFFeatureMaskAnnotationEditing` feature flag.
@property (nonatomic, assign) PSPDFAnnotationType searchableAnnotationTypes;

/// Search delegate.
@property (nonatomic, weak) id<PSPDFSearchOperationDelegate> delegate;

/// Array of `PSPDFSearchResult` (will be set once the operation is finished)
@property (nonatomic, copy, readonly) NSArray *searchResults;

/// Current search term.
@property (nonatomic, copy, readonly) NSString *searchTerm;

/// Associated document.
@property (nonatomic, weak, readonly) PSPDFDocument *document;

/// Call after operation completed. Will be NO if no page text was found.
- (BOOL)pageTextFound;

@end

@interface PSPDFSearchOperation (Advanced)

// Customize start/length of the preview string, in relation to the found element.
// Defaults to 20/160.
@property (nonatomic, assign) NSRange previewRange;

@end
