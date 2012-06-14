//
//  PSPDFDocument.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSPDFKitGlobal.h"
#import "PSPDFCache.h"

@class PSPDFTextSearch, PSPDFOutlineParser, PSPDFPageInfo, PSPDFAnnotationParser, PSPDFViewController, PSPDFTextParser, PSPDFDocumentParser, PSPDFDocumentProvider;

/// Represents a single, logical, pdf document. (one or many pdf files)
/// Can be overriden to support custom collections.
@interface PSPDFDocument : NSObject <NSCopying, NSCoding> {
    NSUInteger pageCount_;
}

/// @name Initialization

/// Initialize empty PSPDFDocument
+ (PSPDFDocument *)PDFDocument;

/// Initialize PSPDFDocument with data
+ (PSPDFDocument *)PDFDocumentWithData:(NSData *)data;

/// Initialize PSPDFDocument with distinct path and an array of files.
+ (PSPDFDocument *)PDFDocumentWithBaseURL:(NSURL *)baseURL files:(NSArray *)files;

/// Initializes PSPDFDocument with a single file
+ (PSPDFDocument *)PDFDocumentWithURL:(NSURL *)URL;

- (id)init;
- (id)initWithData:(NSData *)data;
- (id)initWithURL:(NSURL *)URL;
- (id)initWithBaseURL:(NSURL *)basePath files:(NSArray *)files;


/// @name File Access / Modification

/// Appends a file to the current document. No PDF gets modified, just displayed together. Can be a name or partial path (full path if basePath is nil)
/// Note: As of PSPDFKit 1.9.7, adding the same file multiple times is allowed.
/// Do not mix .data and files - this call will be ignored when data is set.
- (void)appendFile:(NSString *)file;

/// Returns path for a single page (in case pages are split up). Page starts at 0.
/// Note: uses fileIndexForPage and URLForFileIndex internally. Override those instead of pathForPage.
- (NSURL *)pathForPage:(NSUInteger)page;

/// Returns position of the internal file array.
- (NSInteger)fileIndexForPage:(NSUInteger)page;

/// Returns the URL corresponding to the fileIndex
- (NSURL *)URLForFileIndex:(NSInteger)fileIndex;

/// Return plain thumbnail path, if thumbnail already exists. override if you pre-provide thumbnails. Returns nil on default.
- (NSURL *)thumbnailPathForPage:(NSUInteger)page;

/// Returs a files array with the base path already added (if there is one)
- (NSArray *)filesWithBasePath;

/// Common base path for pdf files. Set to nil to use absolute paths for files.
@property(nonatomic, strong) NSURL *basePath;

/// Array of NSString pdf files. If basePath is set, this will be combined with the file name.
/// If basePath is not set, add the full path (as NSString) to the files.
/// Note: it's currently not possible to add the file multiple times, this will fail to display correctly.`
@property(nonatomic, copy) NSArray *files;

/// Usually, you have one single file url representing the pdf. This is a shortcut setter for basePath* files. Overrides all current settings if set.
/// nil if the document was initialized with initWithData:
@property(nonatomic, strong) NSURL *fileURL;

/// PDF data when initialized with initWithData: otherwise nil
@property(nonatomic, copy, readonly) NSData *data;

/// Document title as shown in the controller.
/// If this is not set, the framework tries to extract the title from the PDF metadata.
/// If there's no metadata, the fileName is used. ".pdf" endings will be removed either way.
@property(nonatomic, copy) NSString *title;

/// For caching, provide a *UNIQUE* uid here. (Or clear cache after content changes for same uid. Appending content is no problem)
@property(nonatomic, copy) NSString *uid;

/// @name Annotations

/// Can PDF annotations be embedded?
/// Note: only evaluates the first file if multiple files are set.
@property(nonatomic, assign, readonly) BOOL canEmbedAnnotations;

/// Saves changed annotations back into the PDF sources (files/data).
/// Returns NO if annotations cannot be embedded. Then most likely error is set.
/// Returns YES if there are no annotations that have the dirty flag set.
- (BOOL)saveChangedAnnotationsWithError:(NSError **)error;

/// @name Page Info Data

/// Return pdf page count
- (NSUInteger)pageCount;

/// Return pdf page number. this may be different if a collection of pdfs is used a one big document. Page starts at 0.
- (NSUInteger)pageNumberForPage:(NSUInteger)page;

/// Returns YES of pageInfo for page is available
- (BOOL)hasPageInfoForPage:(NSUInteger)page;

/// Cached rotation and aspect ratio data for specific page. Page starts at 0.
- (PSPDFPageInfo *)pageInfoForPage:(NSUInteger)page;

/// Cached rotation and aspect ratio data for specific page. Page starts at 0.
/// You can override this if you need to manually change the rotation value of a page.
- (PSPDFPageInfo *)pageInfoForPage:(NSUInteger)page pageRef:(CGPDFPageRef)pageRef;

/// Makes a search beginning from page 0 for the nearest pageInfo. Does not calculate/block the thread.
- (PSPDFPageInfo *)nearestPageInfoForPage:(NSUInteger)page;

/// Aspect ratio is automatically cached and analyzed per page. Page starts at 0.
/// maybe needs a pdf lock if not already cached.
- (CGRect)rectBoxForPage:(NSUInteger)page;

/// Rotation for specified page. cached. Page starts at 0.
- (int)rotationForPage:(NSUInteger)page;

/// Scan the whole document and analyzes if the aspect ratio is equal or not.
/// If this returns 0 or a very small value, it's perfectly suitable for pageCurl.
/// Note: this might take a second on larger documents, as the page structure needs to be parsed.
- (CGFloat)aspectRatioVariance;


/// @name Caching

/// Call if you change referenced pdf files outside.
/// Clear the pageCount, pageRects, outline cache, text parser, ...
/// This is called implicitely if you change the files array or append a file.
- (void)clearCache;

/// Creates internal cache for faster display. override to provide custom caching. usually called in a thread.
- (void)fillCache;


/// @name PDF Drawing

/// Return true if you want drawOverlayRect to be called.
- (BOOL)shouldDrawOverlayRectForSize:(PSPDFSize)size;

/// Can be overridden to draw an overlay on the pdf - will be called from drawing threads.
/// Note: most of the time you might be better off using custom UIViews and adding them on PSPDFPageView via the delegates.
- (void)drawOverlayRect:(CGRect)rect inContext:(CGContextRef)context forPage:(NSUInteger)page zoomScale:(CGFloat)zoomScale size:(PSPDFSize)size;


/// @name PDF Search

/// Can be overridden to provide custom text. Defaults to nil.
/// if this returns nil for a site, we'll try to extract text ourselves.
/// Note: If you return text here, text highlighting cannot be used for this page.
- (NSString *)pageContentForPage:(NSUInteger)page;


/// @name Design and hints for PSPDFViewController

/// Override if you want custom *page* background colors. Only displayed while loading, and when no thumbnail is yet available. Defaults to white.
- (UIColor *)backgroundColorForPage:(NSUInteger)page;

/// If aspect ratio is equal on all pages, you can enable this for even better performance. Defaults to NO.
@property(nonatomic, assign, getter=isAspectRatioEqual) BOOL aspectRatioEqual;

/// Annotation link extraction. Defaults to YES.
@property(nonatomic, assign, getter=isAnnotationsEnabled) BOOL annotationsEnabled;

/// Enables two-step rendering. First use cache image, then re-render original pdf. Slightly improves text quality in landscape mode,
/// or when displayed embedded. Two-Step rendering is slower. Defaults to NO.
/// This might be a good idea to turn on when using JPG for caching.
@property(nonatomic, assign, getter=isTwoStepRenderingEnabled) BOOL twoStepRenderingEnabled;

/// If document is displayed, returns currently active pdfController. Don't set this yourself. Optimizes caching.
// note: doesn't use weak as this could lead to background deallocation of the controller.
@property(nonatomic, unsafe_unretained) PSPDFViewController *displayingPdfController;


/// @name Password Protection and Security

/// Passes a password to unlock encrypted documents.
/// If the password is correct, this method returns YES. Once unlocked, you cannot use this function to relock the document.
/// If you attempt to unlock an already unlocked document, one of the following occurs:
/// If the document is unlocked with full owner permissions, unlockWithPassword: does nothing and returns YES. The password string is ignored.
/// If the document is unlocked with only user permissions, unlockWithPassword attempts to obtain full owner permissions with the password
/// string. If the string fails, the document maintains its user permissions. In either case, this method returns YES.
- (BOOL)unlockWithPassword:(NSString *)password;

/// Set a base password to be used for all files in this document (if the document is PDF encrypted).
/// Note: relays the password to all files in the .files array.
@property(nonatomic, copy) NSString *password;

/// Returns YES if the document is valid (if it has at least one page)
@property(nonatomic, assign, readonly, getter=isValid) BOOL valid;

/// Do the PDF digital right allow for printing?
/// Note: only evaluates the first file if multiple files are set.
@property(nonatomic, assign, readonly) BOOL allowsPrinting;

/// Was the PDF file encryted at file creation time?
/// Note: only evaluates the first file if multiple files are set.
@property(nonatomic, assign, readonly) BOOL isEncrypted;

/// Name of the encryption filter used, e.g. Adobe.APS. If this is set, the document can't be unlocked.
/// See "Adobe LifeCycle DRM, http://www.adobe.com/products/livecycle/rightsmanagement
/// Note: only evaluates the first file if multiple files are set.
@property(nonatomic, assign, readonly) NSString *encryptionFilter;

/// Has the PDF file been unlocked? (is it still locked?).
/// Note: only evaluates the first file if multiple files are set.
@property(nonatomic, assign, readonly) BOOL isLocked;

/// A flag that indicates whether copying text is allowed
/// Note: only evaluates the first file if multiple files are set.
@property (nonatomic, assign, readonly) BOOL allowsCopying;


/// @name Attached Parsers

/// Return a textParser for the specific document page.
- (PSPDFTextParser *)textParserForPage:(NSUInteger)page;

/// Text extraction class for current document.
@property(nonatomic, strong) PSPDFTextSearch *textSearch;

/// Get the document provider for a specific page.
- (PSPDFDocumentProvider *)documentProviderForPage:(NSUInteger)page;

/// Get an array of documentProviers to easily manage documents with multiple files.
@property(nonatomic, strong, readonly) NSArray *documentProviders;

/// Document Parser is per file, so might return the same parser for different pages.
/// (But we need to check as a PSPDFDocument can contain multiple files)
- (PSPDFDocumentParser *)documentParserForPage:(NSUInteger)page;

/// Outline extraction class for current document.
/// Note: Only returns the parser for the first PDF file.
@property(nonatomic, strong) PSPDFOutlineParser *outlineParser;

/// Link annotation parser class for current document.
/// Can be overridden to use a subclassed annotation parser.
/// Note: Only returns the parser for the first PDF file.
@property(nonatomic, strong) PSPDFAnnotationParser *annotationParser;

/// Page labels (NSString) for the current document.
/// Might be nil if PageLabels isn't set in the PDF.
/// If substituteWithPlainLabel is set to YES then this always returns a valid string.
- (NSString *)pageLabelForPage:(NSUInteger)page substituteWithPlainLabel:(BOOL)substite;

@end
