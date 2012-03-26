//
//  PSPDFDocumentSearch.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSPDFKitGlobal.h"

@class PSPDFDocument;

/// Search status delegate. All delegates are guarranteed to be called within the main thread.
@protocol PSPDFSearchDelegate <NSObject>

/// Called when search is started. 
- (void)willStartSearchForString:(NSString *)searchString isFullSearch:(BOOL)isFullSearch;

/// Search was updated, a new page has been scanned
- (void)didUpdateSearchForString:(NSString *)searchString newSearchResults:(NSArray *)searchResults forPage:(NSUInteger)page;

/// Search has finished.
- (void)didFinishSearchForString:(NSString *)searchString searchResults:(NSArray *)searchResults isFullSearch:(BOOL)isFullSearch;

/// Search has been cancelled.
- (void)didCancelSearchForString:(NSString *)searchString isFullSearch:(BOOL)isFullSearch;;

@end

enum {
    PSPDFSearchLegacy,                    // this is basically legacy mode, very fast, does not parse CMaps.
    PSPDFSearchAdvanced,                  // more advanced text extraction. (slower)
    PSPDFSearchAdvancedWithHighlighting   // additionally, search results will be highlighted.
}typedef PSPDFSearchMode;

/// Manages search operations for a specific document.
@interface PSPDFDocumentSearcher : NSObject <PSPDFSearchDelegate>

/// Initialize with the document;
- (id)initWithDocument:(PSPDFDocument *)document;

/// Searches for text occurence. If document was not yet parsed, it will be now. 
- (void)searchForString:(NSString *)searchText;

/// Searches for text occurence, selection property is added to sites in visiblePages.
/// enable onlyVisible to only search within the visiblePages
- (void)searchForString:(NSString *)searchText visiblePages:(NSArray *)visiblePages onlyVisible:(BOOL)onlyVisible;

/// YES if there's text stored for page page. (thus, textForPage will return instantly)
- (BOOL)hasTextForPage:(NSUInteger)page;

/// Get text for a specific page. Page starts at 0. Returns nil if no text is available or page is incorrect. (blocking)
- (NSString *)textForPage:(NSUInteger)page;

/// Stops all operations. Call before destroying. Blocks until all operations are finished.
- (void)cancelAllOperationsAndWait;

/// Changes the search mode. Set to PSPDFSearchLegacy if PSPDFSearchAdvanced* is too slow for you.
/// Note: search does not work with all documents. Also highlighting may doesn't work.
/// If you have pdf's that fail, you can send them to us; we may or may not be able to improve things.
/// Do not expect that this library will give you 100% perfect results as compared to Adobe Acrobat.
/// Text extraction is a *very* tricky feature.
/// Defaults to PSPDFSearchAdvancedWithHighlighting.
@property(nonatomic, assign) PSPDFSearchMode searchMode;

/// The document that is searched.
@property(nonatomic, ps_weak, readonly) PSPDFDocument *document;

/// Search delegate. Will be retained as long as the operation runs.    
@property(nonatomic, ps_weak) id<PSPDFSearchDelegate> delegate;

@end
