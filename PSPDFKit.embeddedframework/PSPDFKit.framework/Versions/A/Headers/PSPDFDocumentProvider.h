//
//  PSPDFDocumentProvider.h
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

@class PSPDFTextSearch, PSPDFTextParser, PSPDFDocumentParser, PSPDFOutlineParser, PSPDFAnnotationParser, PSPDFDocumentProvider, PSPDFLabelParser, PSPDFDocument, PSPDFPageInfo;

/// Delegate for writing annotations.
@protocol PSPDFDocumentProviderDelegate <NSObject>

@optional

/// Called before we append data to a PDF. Return NO to stop writing annotations.
/// Defaults to YES if not implemented, and will set a new NSData object.
- (BOOL)documentProvider:(PSPDFDocumentProvider *)documentProvider shouldAppendData:(NSData *)data;

// Called after the write is completed.
- (void)documentProvider:(PSPDFDocumentProvider *)documentProvider didAppendData:(NSData *)data;

@end

/// A PSPDFDocument consists of one or multiple PSPDFDocumentProvider's.
/// @note This class is used within PSPDFDocument and should not be instantiated externally.
@interface PSPDFDocumentProvider : NSObject

/// Initialize with a local file URL.
- (id)initWithFileURL:(NSURL *)fileURL document:(PSPDFDocument *)document;

/// Initialize with NSData. (can be memory or mapped data)
- (id)initWithData:(NSData *)data document:(PSPDFDocument *)document;

/// Initialize with CGDataProviderRef. (can be used for dynamic decryption)
- (id)initWithDataProvider:(CGDataProviderRef)dataProvider document:(PSPDFDocument *)document;

/// Referenced NSURL. If this is set, data is nil.
@property (nonatomic, readonly) NSURL *fileURL;

/// Referenced NSData. If this is set, fileURL is nil.
/// NOT readonly, since we may write back annotation data.
@property (nonatomic, strong) NSData *data;

/// Referenced dataProvider. (if data is set, or directly). Will be retained.
@property (nonatomic, readonly) CGDataProviderRef dataProvider;

/// Returns a NSData representation, memory-maps files, tries to copy a CGDataProviderRef
- (NSData *)dataRepresentationWithError:(NSError **)error;

/// Returns the fileSize of this documentProvider.
- (unsigned long long)fileSize;

/// Parent document, not retained.
@property (nonatomic, weak, readonly) PSPDFDocument *document;

/// Delegate for writing annotations. Is set to PSPDFDocument per default.
@property (nonatomic, weak) id<PSPDFDocumentProviderDelegate> delegate;

/// Access the CGPDFDocumentRef and locks the internal document.
///
/// Increases the internal reference count
/// We need to keep around the document when accessing a CGPDFPage. Retaining the page alone is not enough.
- (CGPDFDocumentRef)requestDocumentRefWithOwner:(id)owner;

/// Releases the lock on the documentRef.
/// @note The parameter is to *check* if the returned documentRef is the same as the internal one.
- (void)releaseDocumentRef:(CGPDFDocumentRef)documentRef withOwner:(id)owner;

/// Use documentRef within the block. Will be automatically cleaned up.
- (void)performBlock:(void (^)(PSPDFDocumentProvider *docProvider, CGPDFDocumentRef documentRef))documentRefBlock;

/// Iterate over all CGPDFPageRef pages. pageNumber starts at 1.
- (void)iterateOverPageRef:(void (^)(PSPDFDocumentProvider *provider, CGPDFDocumentRef documentRef, CGPDFPageRef pageRef, NSUInteger page))pageRefBlock;

/// Requests a page for the current loaded document. Needs to be returned in releasePageRef.
/// pageNumber starts at 1.
- (CGPDFPageRef)requestPageRefForPageNumber:(NSUInteger)page error:(NSError **)error;

/// Releases a page reference.
- (void)releasePageRef:(CGPDFPageRef)pageRef;

/// For optimization reasons, the internal documentRef might be cached.
/// This force-clears the cache.
/// @return YES if document could be flushed instantly (or was already nil), NO otherwise.
- (BOOL)flushDocumentReference;

/// Cached rotation and aspect ratio data for specific page. Page starts at 0.
- (PSPDFPageInfo *)pageInfoForPage:(NSUInteger)page;

/// Number of pages in the PDF. Nil if source is invalid. Will be filtered by pageRange.
@property (nonatomic, readonly) NSUInteger pageCount;
@property (nonatomic, readonly) NSUInteger pageCountUnfiltered; // ignores pageRange
@property (nonatomic, readonly) NSUInteger firstPageIndex;      // first page, 0 if pageRange is not set.

/// Limit pages to a certain page range. Defaults to nil.
/// If document has a pageRange set, the visible pages can be limited to a certain subset.
/// @warning Changing this will require a reloadData on the PSPDFViewController.
@property (nonatomic, copy) NSIndexSet *pageRange;

/// Translates the capped page to the real page.
/// Will only return something different if pageRange is set.
- (NSUInteger)translateCappedPageToRealPage:(NSUInteger)page;

/// Translates the real page to the capped page.
/// Will only return something different if pageRange is set.
- (NSUInteger)translateRealPageToCappedPage:(NSUInteger)page;

/// Unlock the PDF with a password. Returns YES on success. (File operation, might block for a bit
/// Will set .password to this password if successful.
- (BOOL)unlockWithPassword:(NSString *)password;

/// Set a password. Doesn't try to unlock the document.
@property (nonatomic, copy) NSString *password;

/// Do the PDF digital right allow for printing?
@property (nonatomic, assign, readonly) BOOL allowsPrinting;

/// A flag that indicates whether copying text is allowed
@property (nonatomic, assign) BOOL allowsCopying;

/// Was the PDF file encrypted at file creation time?
@property (nonatomic, assign, readonly) BOOL isEncrypted;

/// Name of the encryption filter used, e.g. Adobe.APS. If this is set, the document can't be unlocked.
/// See "Adobe LifeCycle DRM, http://www.adobe.com/products/livecycle/rightsmanagement
@property (nonatomic, copy, readonly) NSString *encryptionFilter;

/// Has the PDF file been unlocked? (is it still locked?).
@property (nonatomic, readonly) BOOL isLocked;

/// Are we able to add/change annotations in this file?
/// Annotations can't be added to encrypted documents or if there are parsing errors.
@property (nonatomic, assign, readwrite) BOOL canEmbedAnnotations;

- (BOOL)saveChangedAnnotationsWithError:(NSError **)error;

/// Access the PDF metadata. (might be a slow operation)
/// @warning Metadata is not guaranteed to be NSString. Check the type when acessing.
@property (nonatomic, copy, readonly) NSDictionary *metadata;

/// Return YES if metadata is already parsed.
@property (nonatomic, assign, readonly, getter=isMetadataLoaded) BOOL metadataLoaded;

/// Access the PDF title. (".pdf" will be truncated)
/// @note If there's no title in the PDF metadata, the file name will be used.
@property (nonatomic, readonly) NSString *title;

/// Return a textParser for the specific document page. Page starts at 0.
/// Will parse the page contents before returning. Might take a while.
- (PSPDFTextParser *)textParserForPage:(NSUInteger)page;

/// Checks if the text parser has already been loaded.
- (BOOL)hasLoadedTextParserForPage:(NSUInteger)page;

/// Clear all text parsers, releases memory.
- (void)clearAllTextParsers;

/// Outline extraction class for current PDF.
/// Lazy initialized. Can be subclassed or set externally.
/// If you set this externally, do this ONLY in your subclass of PSPDFDocument in didCreateDocumentProvider:.
@property (nonatomic, strong) PSPDFOutlineParser *outlineParser;

/// PDF parser that lists the PDF XRef structure and writes annotations.
/// Lazy initialized. Can be subclassed or set externally.
/// Parses the PDF on first access. Might be slow.
/// If you set this externally, do this ONLY in your subclass of PSPDFDocument in didCreateDocumentProvider:.
@property (nonatomic, strong) PSPDFDocumentParser *documentParser;

/// Determine if lazy-loaded documentParser is already available.
@property (nonatomic, assign, readonly) BOOL isDocumentParserLoaded;

/// Link annotation parser class for current PDF.
/// Lazy initialized. Can be subclassed or set externally.
/// If you set this externally, do this ONLY in your subclass of PSPDFDocument in didCreateDocumentProvider:.
@property (nonatomic, strong) PSPDFAnnotationParser *annotationParser;

/// Page labels found in the current PDF.
/// Lazy initialized. Can be subclassed or set externally.
/// If you set this externally, do this ONLY in your subclass of PSPDFDocument in didCreateDocumentProvider:.
@property (nonatomic, strong) PSPDFLabelParser *labelParser;

@end

@interface PSPDFDocumentProvider (PSPDFInternal)

// We need to allow writing to data to change annotations.
@property (nonatomic, strong) NSData *data;

@property (nonatomic, readonly) BOOL hasOpenDocumentRef;

/// Queries the PageInfo, but doesn't fetch new data.
- (PSPDFPageInfo *)pageInfoForPageNoFetching:(NSUInteger)page;

/// Cached rotation and aspect ratio data for specific page. Page starts at 0.
/// You can override this if you need to manually change the rotation value of a page.
- (PSPDFPageInfo *)pageInfoForPage:(NSUInteger)page pageRef:(CGPDFPageRef)pageRef;

/// Resolves a path like /localhost/Library/test.pdf into a full path.
- (NSString *)resolveTokenizedPath:(NSString *)path alwaysLocal:(BOOL)alwaysLocal;

- (NSURL *)URLForTokenizedPath:(NSString *)path;

@end
