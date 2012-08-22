//
//  PSPDFDocumentProvider.h
//  PSPDFKit
//
//  Copyright (c) 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFTextSearch, PSPDFDocumentParser, PSPDFOutlineParser, PSPDFAnnotationParser, PSPDFDocumentProvider, PSPDFLabelParser, PSPDFDocument;

/// Delegate for writing annotations.
@protocol PSPDFDocumentProviderDelegate <NSObject>

/// Called before we append data to a PDF. Return NO to stop writing annotations.
- (BOOL)documentProvider:(PSPDFDocumentProvider *)documentProvider shouldAppendData:(NSData *)data;

// Called after the write is completed.
- (void)documentProvider:(PSPDFDocumentProvider *)documentProvider didAppendData:(NSData *)data;

@end

/// A PSPDFDocument consists of one or multiple PSPDFDocumentProvider's.
/// Note: This class is used within PSPDFDocument and should not be instantiated externally.
@interface PSPDFDocumentProvider : NSObject

/// Initialize with a local file URL.
- (id)initWithFileURL:(NSURL *)fileURL document:(PSPDFDocument *)document;

/// Initalize with NSData. (can be memory or mapped data)
- (id)initWithData:(NSData *)data document:(PSPDFDocument *)document;

/// Initalize with CGDataProviderRef. (can be used for dynamic decryption)
- (id)initWithDataProvider:(CGDataProviderRef)dataProvider document:(PSPDFDocument *)document;

/// Referenced NSURL. If this is set, data is nil.
@property(nonatomic, strong, readonly) NSURL *fileURL;

/// Referenced NSData. If this is set, fileURL is nil.
/// NOT readonly, since we may write back annotation data.
@property(nonatomic, strong) NSData *data;

/// Referenced dataProvider. (if data is set, or directly)
@property(nonatomic, strong, readonly) __attribute__((NSObject)) CGDataProviderRef dataProvider;

/// Returns a NSData representation, memory-maps files, tries to copy a CGDataProviderRef
- (NSData *)dataRepresentationWithError:(NSError **)error;

/// Weak-linked parent document.
@property(nonatomic, ps_weak, readonly) PSPDFDocument *document;

/// Delegate for writing annotations.
@property(nonatomic, ps_weak) id<PSPDFDocumentProviderDelegate> delegate;

/// Access the CGPDFDocumentRef and locks the internal document. 
///
/// Increases the internal reference count
/// We need to keep around the document when accessing a CGPDFPage. Retaining the page alone is not enough.
- (CGPDFDocumentRef)requestDocumentRef;

/// Releases the lock on the documentRef.
/// Note: the parameter is to *check* if the returned documentRef is the same as the internal one.
- (void)releaseDocumentRef:(CGPDFDocumentRef)documentRef;

/// Use documentRef within the block. Will be automatically cleaned up.
- (void)performBlock:(void(^)(PSPDFDocumentProvider *docProvider, CGPDFDocumentRef documentRef))documentRefBlock;

/// Iterate over all CGPDFPageRef pages. pageNumber starts at 1.
- (void)iterateOverPageRef:(void(^)(PSPDFDocumentProvider *docProvider, CGPDFDocumentRef documentRef, CGPDFPageRef pageRef, NSUInteger pageNumber))pageRefBlock;

/// Requests a page for the current loaded document. Needs to be returned in releasePageRef.
/// pageNumber starts at 1.
- (CGPDFPageRef)requestPageRefForPageNumber:(NSUInteger)page;

/// Releases a page reference. 
- (void)releasePageRef:(CGPDFPageRef)pageRef;

/// For optimization reasons, the internal documentRef might be cached.
/// This force-clears the cache, optionally blocking.
- (void)flushDocumentReferenceAsync:(BOOL)async;

/// Number of pages in the PDF. Nil if source is invalid.
@property(nonatomic, assign, readonly) NSUInteger pageCount;

/// Unlock the PDF with a password. Returns YES on success. (File operation, might block for a bit
/// Will set .password to this password if successful.
- (BOOL)unlockWithPassword:(NSString *)password;

/// Set a password. Doesn't try to unlock the document.
@property(nonatomic, copy) NSString *password;

/// Do the PDF digital right allow for printing?
@property(nonatomic, assign, readonly) BOOL allowsPrinting;

/// A flag that indicates whether copying text is allowed
@property(nonatomic, assign) BOOL allowsCopying;

/// Was the PDF file encryted at file creation time?
@property(nonatomic, assign, readonly) BOOL isEncrypted;

/// Name of the encryption filter used, e.g. Adobe.APS. If this is set, the document can't be unlocked.
/// See "Adobe LifeCycle DRM, http://www.adobe.com/products/livecycle/rightsmanagement
@property(nonatomic, assign, readonly) NSString *encryptionFilter;

/// Has the PDF file been unlocked? (is it still locked?).
@property(nonatomic, assign, readonly) BOOL isLocked;

/// Are we able to add/change annotations in this file?
/// Annotations can't be added to encrypted documents or if there are parsing errors.
@property(nonatomic, assign, readwrite) BOOL canEmbedAnnotations;

- (BOOL)saveChangedAnnotationsWithError:(NSError **)error;

/// Access the PDF metadata. (might be a slow operation)
@property(nonatomic, strong, readonly) NSDictionary *metadata;

/// Return YES if metadata is already parsed.
@property(nonatomic, assign, readonly, getter=isMetadataLoaded) BOOL metadataLoaded;

/// Access the PDF title. (".pdf" will be trunicated)
/// Note: if there's no title in the PDF metadata, the file name will be used.
@property(nonatomic, copy, readonly) NSString *title;

/// Outline extraction class for current PDF.
/// Lazy initialized. Can be subclassed or set externally.
@property(nonatomic, strong) PSPDFOutlineParser *outlineParser;

/// PDF parser that lists the PDF XRef structure and writes annotations.
/// Lazy initialized. Can be subclassed or set externally.
@property(nonatomic, strong) PSPDFDocumentParser *documentParser;

/// Link annotation parser class for current PDF.
/// Lazy initialized. Can be subclassed or set externally.
@property(nonatomic, strong) PSPDFAnnotationParser *annotationParser;

/// Page labels found in the current PDF.
/// Lazy initialized. Can be subclassed or set externally.
@property(nonatomic, strong) PSPDFLabelParser *labelParser;

@end

@interface PSPDFDocumentProvider (PSPDFInternal)

// We need to allow writing to data to change annotations.
@property(nonatomic, strong) NSData *data;

@property(nonatomic, assign, readonly) BOOL hasOpenDocumentRef;

@end
