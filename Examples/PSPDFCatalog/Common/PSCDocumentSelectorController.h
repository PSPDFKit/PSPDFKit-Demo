//
//  PSCDocumentSelectorController.h
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

@class PSCDocumentSelectorController;
@class PSPDFDocument;

/// Document selector delegate.
@protocol PSCDocumentSelectorControllerDelegate <NSObject>

/// A cell has been selected.
- (void)documentSelectorController:(PSCDocumentSelectorController *)controller didSelectDocument:(PSPDFDocument *)document;

@end

/// Shows all documents available in the Sample directory.
@interface PSCDocumentSelectorController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>

/// Returns an array of PSPDFDocument's found in the "directoryName" directory.
+ (NSArray *)documentsFromDirectory:(NSString *)directoryName;

/// Designated initializer.
- (id)initWithDirectory:(NSString *)directory delegate:(id<PSCDocumentSelectorControllerDelegate>)delegate;

/// Delegate to get the didSelect event.
@property (nonatomic, weak) id<PSCDocumentSelectorControllerDelegate> delegate;

// All PSPDFDocument objects.
@property (nonatomic, copy, readonly) NSArray *documents;

/// Displayed path.
@property (nonatomic, copy, readonly) NSString *directory;

/// Getting the PDF document title can be slow. If set to NO, the file name is used instead. Defaults to NO.
@property (nonatomic, assign) BOOL useDocumentTitles;

/// Enables section indexes. Enabled by default.
@property (nonatomic, assign) BOOL showSectionIndexes;

/// Enable to perform full-text search on all documents. Currently pretty slow. Defaults to NO.
@property (nonatomic, assign) BOOL fullTextSearchEnabled;

@end
