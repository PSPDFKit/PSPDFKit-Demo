//
//  PSPDFDocumentPickerController.h
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFOverridable.h"

@class PSPDFDocumentPickerController;
@class PSPDFDocument, PSPDFLibrary, PSPDFDocumentPickerIndexStatusCell;

/// Document selector delegate.
@protocol PSPDFDocumentPickerControllerDelegate <PSPDFOverridable>

/// A cell has been selected.
/// `pageIndex` is usually NSNotFound, unless a search result from the FTS engine was tapped.
- (void)documentPickerController:(PSPDFDocumentPickerController *)controller didSelectDocument:(PSPDFDocument *)document page:(NSUInteger)pageIndex searchString:(NSString *)searchString;

@optional

// When we start/end showing the search UI
- (void)documentPickerControllerWillBeginSearch:(PSPDFDocumentPickerController *)controller;
- (void)documentPickerControllerDidBeginSearch:(PSPDFDocumentPickerController *)controller;
- (void)documentPickerControllerWillEndSearch:(PSPDFDocumentPickerController *)controller;
- (void)documentPickerControllerDidEndSearch:(PSPDFDocumentPickerController *)controller;

@end

/// Shows all documents available in the Sample directory.
/// By default this will enqueue all documents into the default PSPDFLibrary for FTS.
@interface PSPDFDocumentPickerController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>

/// Returns an array of PSPDFDocument's found in the "directoryName" directory.
+ (NSArray *)documentsFromDirectory:(NSString *)directoryName includeSubdirectories:(BOOL)includeSubdirectories;

/// Designated initializer.
/// `library` is optional but required if you want to use `fullTextSearchEnabled`.
- (id)initWithDirectory:(NSString *)directory includeSubdirectories:(BOOL)includeSubdirectories library:(PSPDFLibrary *)library delegate:(id<PSPDFDocumentPickerControllerDelegate>)delegate;

/// Initialize with a number of documents.
- (id)initWithDocuments:(NSArray *)documents library:(PSPDFLibrary *)library delegate:(id<PSPDFDocumentPickerControllerDelegate>)delegate;

/// Delegate to get the didSelect event.
@property (nonatomic, weak) id<PSPDFDocumentPickerControllerDelegate> delegate;

// All PSPDFDocument objects.
@property (atomic, copy, readonly) NSArray *documents;

/// Displayed path. Might be nil, if initialized with a number of documents.
@property (nonatomic, copy, readonly) NSString *directory;

/// Getting the PDF document title can be slow. If set to NO, the file name is used instead. Defaults to NO.
@property (nonatomic, assign) BOOL useDocumentTitles;

/// Enables section indexes. Defaults to YES.
@property (nonatomic, assign) BOOL showSectionIndexes;

/// If disabled, documents will only be displayed once you start searching. Defaults to YES.
@property (nonatomic, assign) BOOL alwaysShowDocuments;

/// Enable to perform full-text search on all documents. Defaults to YES
@property (nonatomic, assign) BOOL fullTextSearchEnabled;

/// Property is enabled if a FTS-Search is currently queued/running. KVO observable.
@property (nonatomic, assign, readonly) BOOL isSearchingIndex;

/// Will show the actual pages and text preview instead of just the documents.
/// Only valid if `fullTextSearchEnabled` is enabled. Defaults to NO.
@property (nonatomic, assign) BOOL showSearchPageResults;

/// Defaults to 600. A too high number will be slow.
/// Only valid if `fullTextSearchEnabled` is enabled.
@property (nonatomic, assign) NSUInteger maximumNumberOfSearchResultsDisplayed;

/// Number of results found per document. Defaults to 10.
/// Only valid if `fullTextSearchEnabled` is enabled.
@property (nonatomic, assign) NSUInteger maximumNumberOfSearchResultsPerDocument;

/// The attached library, if any.
@property (nonatomic, strong, readonly) PSPDFLibrary *library;

@end

@interface PSPDFDocumentPickerController (SubclassingHooks)

- (void)updateStatusCell:(PSPDFDocumentPickerIndexStatusCell *)cell;

@end
