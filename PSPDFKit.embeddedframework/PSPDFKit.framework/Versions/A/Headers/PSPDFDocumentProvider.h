//
//  PSPDFDocumentProvider.h
//  PSPDFKit
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFDocumentProviderDelegate.h"

@class PSPDFFormParser, PSPDFEmbeddedFilesParser, PSPDFTextSearch, PSPDFTextParser, PSPDFOutlineParser, PSPDFAnnotationManager, PSPDFDocumentProvider, PSPDFLabelParser, PSPDFDocument, PSPDFPageInfo;

/// A `PSPDFDocument` consists of one or multiple `PSPDFDocumentProvider`'s.
/// Each document provider has exactly one data source (file/data/dataProvider)
/// @note This class is used within PSPDFDocument and should not be instantiated externally.
@interface PSPDFDocumentProvider : NSObject

/// Initialize with a local file URL.
- (instancetype)initWithFileURL:(NSURL *)fileURL document:(PSPDFDocument *)document;

/// Initialize with `NSData`. (can be memory or mapped data)
- (instancetype)initWithData:(NSData *)data document:(PSPDFDocument *)document;

/// Initialize with `CGDataProviderRef`. (can be used for dynamic decryption)
- (instancetype)initWithDataProvider:(CGDataProviderRef)dataProvider document:(PSPDFDocument *)document;

/// Referenced NSURL. If this is set, data is nil.
@property (nonatomic, readonly) NSURL *fileURL;

/// Referenced NSData. If this is set, `fileURL` is nil.
@property (nonatomic, strong, readonly) NSData *data;

/// Referenced data provider. (if data is set, or directly). Will be retained.
@property (nonatomic, readonly) CGDataProviderRef dataProvider;

/// Returns a NSData representation, memory-maps files, tries to copy a `CGDataProviderRef`.
- (NSData *)dataRepresentationWithError:(NSError **)error;

/// Returns the `fileSize` of this documentProvider.
- (unsigned long long)fileSize;

/// Accesses the parent document.
@property (nonatomic, weak, readonly) PSPDFDocument *document;

/// Delegate for writing annotations. Defaults to the current set document.
@property (nonatomic, weak) id<PSPDFDocumentProviderDelegate> delegate;

/// Cached rotation and aspect ratio data for specific page. Page starts at 0.
/// Unlike with `-[PSPDFDocument pageInfoForPage:]` here the returned `PSPDFPageInfo`'s
/// `page` propety always equals the supplied `page` argument
- (PSPDFPageInfo *)pageInfoForPage:(NSUInteger)page;

/// Number of pages in the PDF. 0 if source is invalid. Will be filtered by pageRange.
/// @warning Manually setting the `pageCount` usually is not recommended.
@property (nonatomic, assign) NSUInteger pageCount;

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

/// Has the PDF file been unlocked? (is it still locked?).
@property (nonatomic, assign, readonly) BOOL isLocked;

/// Are we able to add/change annotations in this file?
/// Annotations can't be added to encrypted documents or if there are parsing errors.
@property (nonatomic, assign) BOOL canEmbedAnnotations;

/// A flag that indicates whether changing existing annotations or creating new annotations are allowed
/// @note Searches and checks the digital signatures on the first call (caches the result for subsequent calls)
@property (nonatomic, assign, readonly) BOOL allowAnnotationChanges;

/// Access the PDF title. (".pdf" will be truncated)
/// @note If there's no title in the PDF metadata, the file name will be used.
@property (nonatomic, copy, readonly) NSString *title;

/// Return a textParser for the specific document page. Page starts at 0.
/// Will parse the page contents before returning. Might take a while.
- (PSPDFTextParser *)textParserForPage:(NSUInteger)page;

/// Outline extraction class for current PDF.
/// Lazy initialized. Can be subclassed or set externally.
/// If you set this externally, do this ONLY in your subclass of `PSPDFDocument` in `didCreateDocumentProvider:`.
@property (nonatomic, strong) PSPDFOutlineParser *outlineParser;

/// AcroForm parser for current PDF.
@property (nonatomic, strong) PSPDFFormParser *formParser;

/// Embedded files.
@property (nonatomic, strong) PSPDFEmbeddedFilesParser *embeddedFilesParser;

/// Link annotation parser class for current PDF.
/// Lazy initialized. Can be subclassed or set externally.
/// If you set this externally, do this ONLY in your subclass of `PSPDFDocument` in `didCreateDocumentProvider:`.
@property (nonatomic, strong) PSPDFAnnotationManager *annotationManager;

/// Page labels found in the current PDF.
/// Lazy initialized. Can be subclassed or set externally.
/// If you set this externally, do this ONLY in your subclass of `PSPDFDocument` in `didCreateDocumentProvider:`.
@property (nonatomic, strong) PSPDFLabelParser *labelParser;

/// Get the XMP metadata in XML format, if there is any.
- (NSString *)XMPMetadata;

@end

@interface PSPDFDocumentProvider (PageRange)

/// Like `pageCount`, but will not be filtered by `pageRange`.
@property (nonatomic, assign, readonly) NSUInteger pageCountUnfiltered;

/// First real page, will return 0 if `pageRange` is not set.
@property (nonatomic, assign, readonly) NSUInteger firstPageIndex;

/// Limit pages to a certain page range. Defaults to nil.
/// If document has a `pageRange` set, the visible pages can be limited to a certain subset.
/// @warning Changing this will require a reloadData on the `PSPDFViewController`.
@property (nonatomic, copy) NSIndexSet *pageRange;

/// Translates the capped page to the real page.
/// Will only return something different if `pageRange` is set.
- (NSUInteger)translateCappedPageToRealPage:(NSUInteger)page;

/// Translates the real page to the capped page.
/// Will only return something different if `pageRange` is set.
- (NSUInteger)translateRealPageToCappedPage:(NSUInteger)page;

// Returns the page offset relative to the document.
- (NSUInteger)pageOffsetForDocument;

@end

@interface PSPDFDocumentProvider (Advanced)

/// Will always return NO for `isLocked`. This can speed up initial load time as the document doesn't need to be parsed.
@property (nonatomic, assign) BOOL ignoreLocking;

/// Access the PDF metadata. (might be a slow operation)
/// @warning Metadata is not guaranteed to be `NSString`. Check the type when accessing.
@property (nonatomic, copy, readonly) NSDictionary *metadata;

/// Return YES if metadata is already parsed.
@property (nonatomic, assign, readonly, getter=isMetadataLoaded) BOOL metadataLoaded;

/// For optimization reasons, the internal documentRef might be cached.
/// This force-clears the cache.
/// @return YES if document could be flushed instantly (or was already nil), NO otherwise.
/// @note This can also be used if the backing store file didn't exist and was just added, to force a re-try on document loading.
- (BOOL)flushDocumentReference;

@end

@interface PSPDFDocumentProvider (SubclassingHooks)

// Cached rotation and aspect ratio data for specific page. Page starts at 0.
// You can override this if you need to manually change the rotation value of a page.
// `pageRef` is used for caching and might be nil.
- (PSPDFPageInfo *)pageInfoForPage:(NSUInteger)page pageRef:(CGPDFPageRef)pageRef;

// Manually add page info objects.
- (void)setPageInfo:(PSPDFPageInfo *)pageInfo forPage:(NSUInteger)page;

/// Saves changed annotations.
/// @warning You shouldn't call this method directly, use the high-level save method in `PSPDFDocument` instead.
- (BOOL)saveAnnotationsWithOptions:(NSDictionary *)options error:(NSError **)error;

// Resolves a path like `/localhost/Library/test.pdf` into a full path.
// If either `alwaysLocal` is set or `localhost` is part of the path, we'll handle this as a local URL.
- (NSString *)resolveTokenizedPath:(NSString *)path alwaysLocal:(BOOL)alwaysLocal;

@end
