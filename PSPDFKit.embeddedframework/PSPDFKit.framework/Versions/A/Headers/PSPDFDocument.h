//
//  PSPDFDocument.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFCache.h"
#import "PSPDFAnnotation.h"
#import "PSPDFDocumentDelegate.h"
#import "PSPDFDocumentProvider.h"
#import <CoreGraphics/CoreGraphics.h>

@class PSPDFTextSearch, PSPDFOutlineParser, PSPDFPageInfo, PSPDFAnnotationParser, PSPDFViewController, PSPDFTextParser, PSPDFDocumentParser, PSPDFDocumentProvider, PSPDFBookmarkParser;

typedef NS_ENUM(NSInteger, PSPDFAnnotationSaveMode) {
    PSPDFAnnotationSaveModeDisabled,
    PSPDFAnnotationSaveModeExternalFile,
    PSPDFAnnotationSaveModeEmbedded,
    PSPDFAnnotationSaveModeEmbeddedWithExternalFileAsFallback
};

/// Represents a single, logical, PDF document. (one or many PDF files)
/// Can be overriden to support custom collections.
/// PSPDFDOcument is the default delegate for PSPDFDocumentProviderDelegate.
@interface PSPDFDocument : NSObject <NSCopying, NSCoding, PSPDFDocumentProviderDelegate>

/// @name Initialization

/// Initialize empty PSPDFDocument.
+ (instancetype)PDFDocument;

/// Initialize PSPDFDocument with a single file.
+ (instancetype)PDFDocumentWithURL:(NSURL *)URL;

/// Initialize PSPDFDocument with data.
+ (instancetype)PDFDocumentWithData:(NSData *)data;

/// Initialize PSPDFDocument with multiple data objects
+ (instancetype)PDFDocumentWithDataArray:(NSArray *)dataArray;

/// Initialize PSPDFDocument with a dataProvider.
/// Note: You might need to manually set a UID to enable caching if the dataProvider is too big to be copied into memory.
+ (instancetype)PDFDocumentWithDataProvider:(CGDataProviderRef)dataProvider;

/// Initialize PSPDFDocument with distinct path and an array of files.
+ (instancetype)PDFDocumentWithBaseURL:(NSURL *)baseURL files:(NSArray *)files;

/// If you have files that have the pattern XXX_Page_0001 - XXX_Page_0200 use this initializer.
/// fileTemplate needs to have exactly one '%d' marker where the page should be.
/// For leading zeros, use the default printf syntax. (%04d = 0001)
+ (instancetype)PDFDocumentWithBaseURL:(NSURL *)baseURL fileTemplate:(NSString *)fileTemplate startPage:(NSInteger)startPage endPage:(NSInteger)endPage;

- (id)init;
- (id)initWithURL:(NSURL *)URL;
- (id)initWithData:(NSData *)data;
- (id)initWithDataArray:(NSArray *)data;
- (id)initWithDataProvider:(CGDataProviderRef)dataProvider;
- (id)initWithBaseURL:(NSURL *)basePath files:(NSArray *)files;
- (id)initWithBaseURL:(NSURL *)basePath fileTemplate:(NSString *)fileTemplate startPage:(NSInteger)startPage endPage:(NSInteger)endPage;

/// Delegate. Used for annotation calls.
@property (nonatomic, ps_weak) id<PSPDFDocumentDelegate> delegate;

/// @name File Access / Modification

/// Appends a file to the current document. No PDF gets modified, just displayed together. Can be a name or partial path (full path if basePath is nil)
/// Adding the same file multiple times is allowed.
- (void)appendFile:(NSString *)file;

/// Returns path for a single page (in case pages are split up). Page starts at 0.
/// Note: uses fileIndexForPage and URLForFileIndex internally. Override those instead of pathForPage.
- (NSURL *)pathForPage:(NSUInteger)page;

/// Returns position of the internal file array.
- (NSInteger)fileIndexForPage:(NSUInteger)page;

/// Returns the URL corresponding to the fileIndex
- (NSURL *)URLForFileIndex:(NSInteger)fileIndex;

/// Returs a NSURL files array with the base path already added (if there is one)
- (NSArray *)filesWithBasePath;

/**
    Returns a dictionary with filename : NSData object.
    Memory-maps files; works with all available input types.
    If there's no file name, we use the PDF title or "Untitled PDF" if all fails.
    Uses PSPDFDocumentProviders dataRepresentationWithError. Errors are only logged.
 
    Returns a private subclass of an ORDERED NSDictionary (PSPDFOrderedDictionary).
 */
- (NSDictionary *)fileNamesWithDataDictionary;

/// Helper that gets a suggested fileName for a specific page.
- (NSString *)fileNameForPage:(NSUInteger)pageIndex;

/// Common base path for pdf files. Set to nil to use absolute paths for files.
@property (nonatomic, strong) NSURL *basePath;

/// Array of NSString pdf files. If basePath is set, this will be combined with the file name.
/// If basePath is not set, add the full path (as NSString) to the files.
/// Note: it's currently not possible to add the file multiple times, this will fail to display correctly.`
@property (nonatomic, copy) NSArray *files;

/// Usually, you have one single file URL representing the pdf. This is a shortcut setter for basePath* files. Overrides all current settings if set.
/// nil if the document was initialized with initWithData:
@property (nonatomic, strong) NSURL *fileURL;

/// PDF data when initialized with initWithData: otherwise nil.
/// This is a shortcut to the first entry of dataArray.
@property (nonatomic, copy, readonly) NSData *data;

/// A document can also have multiple NSData objects.
/// Note: If writing annotations is enabled, the dataArray's content will change after a save.
@property (nonatomic, copy, readonly) NSArray *dataArray;

/// PDF dataProvider (can be used to dynamically decrypt a document). Will be retained when set.
@property (nonatomic, assign, readonly) CGDataProviderRef dataProvider;

/// Document title as shown in the controller.
/// If this is not set, the framework tries to extract the title from the PDF metadata.
/// If there's no metadata, the fileName is used. ".pdf" endings will be removed either way.
@property (nonatomic, copy) NSString *title;

/// Title might need to parse the file and is potentially slow.
/// Use this to check if title is loaded and access title in a thread if not.
@property (nonatomic, assign, readonly, getter=isTitleLoaded) BOOL titleLoaded;

/// Access the PDF metadata of the first PDF document.
/// A PDF might not have any metadata at all.
/// See kPSPDFMetadataKeyTitle and the following defines for keys that might be set.
/// It's possible that there are keys that don't have a PSPDFKit define.
/// Loop the dictionary to find them all.
@property (nonatomic, strong, readonly) NSDictionary *metadata;

/// For caching, provide a *UNIQUE* uid here. (Or clear cache after content changes for same uid. Appending content is no problem)
@property (nonatomic, copy) NSString *UID;


/// @name Annotations

/// Annotation link extraction. Defaults to YES.
@property (nonatomic, assign, getter=isAnnotationsEnabled) BOOL annotationsEnabled;

/**
 Defines the annotations that can be edited (if annotationsEnabled is set to YES)
 Set this to an empty set to disable annotation editing/creation.
 
 Defaults to PSPDFAnnotationTypeStringHighlight, PSPDFAnnotationTypeStringUnderline, PSPDFAnnotationTypeStringStrikeout, PSDFAnnotationTypeStringNote, PSPDFAnnotationTypeStringInk, PSPDFAnnotationTypeStringFreeText
*/
@property (nonatomic, strong) NSSet *editableAnnotationTypes;

/// Can PDF annotations be embedded?
/// Note: only evaluates the first file if multiple files are set.
/// This might block for a while since the PDF needs to be parsed to determine this.
@property (nonatomic, assign, readonly) BOOL canEmbedAnnotations;

/**
 Control if and where custom created PSPDFAnnotations are saved.
 Defaults to PSPDFAnnotationSaveModeEmbeddedWithExternalFileAsFallback.
 
 Note: Currently PSPDFLinkAnnotations cannot be saved.
 (See editableAnnotationTypes for annotations that can be written)
*/
@property (nonatomic, assign) PSPDFAnnotationSaveMode annotationSaveMode;

/**
 Saves changed annotations back into the PDF sources (files/data).
 
 Returns NO if annotations cannot be embedded. Then most likely error is set.
 Returns YES if there are no annotations that need to be saved.
 
 Only available in PSPDFKit Annotate.
 */
- (BOOL)saveChangedAnnotationsWithError:(NSError **)error;

/// Link annotation parser class for current document.
/// Can be overridden to use a subclassed annotation parser.
/// Note: Only returns the parser for the first PDF file.
@property (nonatomic, strong, readonly) PSPDFAnnotationParser *annotationParser;

/**
 Shorthand to return annotation array for specified page.
 This is a shortcut method that already compensates the page, replacing this code:

 NSUInteger compensatedPage = [document compensatedPageForPage:self.page];
 PSPDFAnnotationParser *annotationParser = [document annotationParserForPage:self.page];
 NSArray *annotations = [annotationParser annotationsForPage:compensatedPage type:PSPDFAnnotationTypeAll];
 */
- (NSArray *)annotationsForPage:(NSUInteger)page type:(PSPDFAnnotationType)type;

/// Shorthand accessor that compensates the page. See PSPDFAnnotationParser for details.
- (void)addAnnotations:(NSArray *)annotations forPage:(NSUInteger)page;

/**
 Returns the annotation parser for a specific page.
 page is needed if your PSPDFDocument contains multiple PSPDFDocumentProviders.
 (thus, multiple sources like multiple files or a file and a NSData object)

 If you use [annotationParser annotationsForPage:type:] or the other methods in there,
 be sure to use a compensated page index. Pages within annotationParser are file relative.

 Use NSUInteger compensatedPage = [self compensatedPageForPage:page].
 */
- (PSPDFAnnotationParser *)annotationParserForPage:(NSUInteger)page;


/// @name Page Info Data

/// Return pdf page count.
/// Might need file operations to parse the document (slow)
- (NSUInteger)pageCount;

/// Return PDF page number (PDF pages start at 1).
/// This may be different if a collection of pdfs is used a one big document. Page starts at 0.
- (NSUInteger)pageNumberForPage:(NSUInteger)page;

/// Equal to pageNumberForPage, but returns zero-based compensated page.
/// (Essentially pageNumberForPage-1)
- (NSUInteger)compensatedPageForPage:(NSUInteger)page;

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
- (void)fillPageInfoCache; // part of fillCache.

/// Path where backupable cache data like bookmarks are saved.
/// Defaults to &lt;AppDirectory&gt;/Library/PrivateDocuments/PSPDFKit. Cannot be nil.
/// Will *always* be appended by UID. Don't manually append UID.
@property (nonatomic, copy) NSString *cacheDirectory;

/// Make sure 'cacheDirectory' exists. Returns error if creation is not possible.
- (BOOL)ensureCacheDirectoryExistsWithError:(NSError **)error;

/// Overrides the global caching strategy in PSPDFCache.
/// Defaults to -1; which equals to the setting in PSPDFCache.
/// Set this to PSPDFCacheNothing for sensible/encrypted documents!
@property (nonatomic, assign) PSPDFCacheStrategy cacheStrategy;


/// @name Design and hints for PSPDFViewController

/// If aspect ratio is equal on all pages, you can enable this for even better performance. Defaults to NO.
@property (nonatomic, assign, getter=isAspectRatioEqual) BOOL aspectRatioEqual;

/// If document is displayed, returns currently active pdfController. Don't set this yourself. Optimizes caching.
// Note: doesn't use weak as this could lead to background deallocation of the controller.
@property (nonatomic, unsafe_unretained) PSPDFViewController *displayingPdfController;


/// @name Password Protection and Security

/**
 Unlock documents with a password.
 Only saves the password if unlocking was successful (vs setPassword that saves the password always)
 
 If the password is correct, this method returns YES. Once unlocked, you cannot use this function to relock the document.

 If you attempt to unlock an already unlocked document, one of the following occurs:
 If the document is unlocked with full owner permissions, unlockWithPassword: does nothing and returns YES. The password string is ignored.
 If the document is unlocked with only user permissions, unlockWithPassword attempts to obtain full owner permissions with the password string.
 If the string fails, the document maintains its user permissions. In either case, this method returns YES.
 
 After unlocking a document, you need to call reloadData on the PSPDFViewController.
 
 If you're using multiple files or appendFile, all new files will be unlocked with the password.
 This doesn't harm if the document is already unlocked.
 
 If you have a mixture of files with multiple different passwords, you need to subclass didCreateDocumentProvider: and unlock the documentProvider directly there.
 */
- (BOOL)unlockWithPassword:(NSString *)password;

/// Set a base password to be used for all files in this document (if the document is PDF encrypted).
/// Relays the password to all current and future documentProviders.
/// The password will be ignored if the document is not password protected.
@property (nonatomic, copy) NSString *password;

/// Returns YES if the document is valid (if it has at least one page)
/// Might need file operations to parse the document (slow)
@property (nonatomic, assign, readonly, getter=isValid) BOOL valid;

/// Do the PDF digital right allow for printing?
/// Note: only evaluates the first file if multiple files are set.
@property (nonatomic, assign, readonly) BOOL allowsPrinting;

/// Was the PDF file encryted at file creation time?
/// Note: only evaluates the first file if multiple files are set.
@property (nonatomic, assign, readonly) BOOL isEncrypted;

/// Name of the encryption filter used, e.g. Adobe.APS. If this is set, the document can't be unlocked.
/// See "Adobe LifeCycle DRM, http://www.adobe.com/products/livecycle/rightsmanagement
/// Note: only evaluates the first file if multiple files are set.
@property (nonatomic, assign, readonly) NSString *encryptionFilter;

/// Has the PDF file been unlocked? (is it still locked?).
/// Note: only evaluates the first file if multiple files are set.
@property (nonatomic, assign, readonly) BOOL isLocked;

/// A flag that indicates whether copying text is allowed
/// Note: only evaluates the first file if multiple files are set.
/// Can also be overridden manually.
@property (nonatomic, assign) BOOL allowsCopying;


/// @name Attached Parsers

/// Return a textParser for the specific document page.
- (PSPDFTextParser *)textParserForPage:(NSUInteger)page;

/// If YES, any glyphs (text, words) that are outside the visible page area will not be parsed.
/// Set early or call clearCache manually after changing this property. (since extracted text is cached)
/// Defaults to YES.
@property (nonatomic, assign) BOOL textParserHideGlyphsOutsidePageRect;

/// Text extraction class for current document.
@property (nonatomic, strong) PSPDFTextSearch *textSearch;

/// Get the document provider for a specific page.
- (PSPDFDocumentProvider *)documentProviderForPage:(NSUInteger)page;

/// Get the page offset from a specific documentProvider.
/// Can be used to calculate from the document provider page to the PSPDFDocument page.
- (NSUInteger)pageOffsetForDocumentProvider:(PSPDFDocumentProvider *)documentProvider;

/// Get an array of documentProviers to easily manage documents with multiple files.
@property (nonatomic, strong, readonly) NSArray *documentProviders;

/// Document Parser is per file, so might return the same parser for different pages.
/// (But we need to check as a PSPDFDocument can contain multiple files)
- (PSPDFDocumentParser *)documentParserForPage:(NSUInteger)page;

/// Outline extraction class for current document.
/// Note: Only returns the parser for the first PDF file.
@property (nonatomic, strong, readonly) PSPDFOutlineParser *outlineParser;

/// Manages the bookmark parser.
/// Lazily initialized, thread safe.
/// Can be customized with using overrideClassNames.
@property (nonatomic, strong) PSPDFBookmarkParser *bookmarkParser;

/// Page labels (NSString) for the current document.
/// Might be nil if PageLabels isn't set in the PDF.
/// If substituteWithPlainLabel is set to YES then this always returns a valid string.
- (NSString *)pageLabelForPage:(NSUInteger)page substituteWithPlainLabel:(BOOL)substite;

/// Find page of a pageLabel.
- (NSUInteger)pageForPageLabel:(NSString *)pageLabel partialMatching:(BOOL)partialMatching;

/// @name PDF Page Rendering

/// Renders the page or a part of it with default display settings into a new image.
/// @param fullSize		 The size of the page, in pixels, if it was rendered without clipping
/// @param clippedToRect A rectangle, relative to fullSize, that specifies the area of the page that should be rendered. CGRectZero = automatic.
/// @param annotations   Annotations that should be rendered with the view
/// @param options       Dictionary with options that modify the render process (see PSPDFPageRenderer)
/// @returns			A new UIImage with the rendered page content
- (UIImage *)renderImageForPage:(NSUInteger)page withSize:(CGSize)fullSize clippedToRect:(CGRect)clipRect withAnnotations:(NSArray *)annotations options:(NSDictionary *)options;

/// Draw a page into a specified context.
- (void)renderPage:(NSUInteger)page inContext:(CGContextRef)context withSize:(CGSize)size clippedToRect:(CGRect)clipRect withAnnotations:(NSArray *)annotations options:(NSDictionary *)options;

/// Set custom render options (see PSPDFPageRenderer.h for options)
/// Options set here will override any options sent to renderImageForPage/renderPage.
/// This is the perfect place to change the background fill color, e.g. you would do this for a black document:
/// renderOptions = @{kPSPDFBackgroundFillColor : [UIColor blackColor]};
/// This fixes tiny white/gray lines at the borders of a document that else might show up.
@property (nonatomic, strong) NSDictionary *renderOptions;

/// @name Object Finder

// options
extern NSString *const kPSPDFObjectsText;        // Include Text.
extern NSString *const kPSPDFObjectsFullWords;   // Always return full PSPDFWords. Implies kPSPDFObjectsText.
extern NSString *const kPSPDFObjectsTextBlocks;  // Include text blocks, sorted after most appropriate.
extern NSString *const kPSPDFObjectsTextBlocksIgnoreLarge;  // Ignore too large text blocks (that are > 90% of a page)
extern NSString *const kPSPDFObjectsAnnotationTypes; // Include annotations of attached type
extern NSString *const kPSPDFObjectsAnnotationPageBounds; // Special case; used for PSPDFAnnotationTypeNote hit testing.

// Output categories
extern NSString *const kPSPDFGlyphs;
extern NSString *const kPSPDFWords;
extern NSString *const kPSPDFTextBlocks;
extern NSString *const kPSPDFAnnotations;

/// Find objects at the current PDF point.
/// If options is nil, we assume kPSPDFObjectsText and kPSPDFObjectsFullWords.
/// Returns objects in certain key dictionaries (kPSPDFGlyphs, etc)
- (NSDictionary *)objectsAtPDFPoint:(CGPoint)pdfPoint page:(NSUInteger)page options:(NSDictionary *)options;

/// Find objects at the current PDF rect.
/// If options is nil, we assume kPSPDFObjectsText, kPSPDFObjectsFullWords and kPSPDFObjectsRespectTextBlocks.
/// Returns objects in certain key dictionaries (kPSPDFGlyphs, etc)
- (NSDictionary *)objectsAtPDFRect:(CGRect)pdfRect page:(NSUInteger)page options:(NSDictionary *)options;

@end

@interface PSPDFDocument (Subclassing)

/// Use this to use specific subclasses instead of the default PSPDF* classes.
/// e.g. add an entry of [PSPDFAnnotationParser class] / [MyCustomAnnotationParser class] as key/value pair to use the custom subclass. (MyCustomAnnotationParser must be a subclass of PSPDFAnnotationParser)
/// Throws an exception if the overriding class is not a subclass of the overridden class.
/// Note: does not get serialized when saved to disk.
@property (nonatomic, strong) NSDictionary *overrideClassNames;

/// Hook to modify/return a different document provider. Called each time a documentProvider is created (which is usually on first access, and cached afterwards)
/// During PSPDFDocument lifetime, document providers might be created at any time, lazily, and destroyed when memory is low.
/// This might be used to change the delegate of the PSPDFDocumentProvider.
- (PSPDFDocumentProvider *)didCreateDocumentProvider:(PSPDFDocumentProvider *)documentProvider;

/**
 Return URL to a thumbnail/full sized image (png; jpg preferred). Use this if you want to pre-supply rendered images.
 Returns nil in the default implementation.
 
 Replaces thumbnailPathForPage from PSPDFKit v1.
 
 For example, you can use the fully pre-rendered images from the iPhone Simulator (or iPad) and copy them into your bundle.
 Then, you write a method that returns the file URL for those files.
    
 In PSPDFKit, files have the name "p1" (PSPDFSizeNative), "t1" (PSPDFSizeThumbnail) or "y1" (PSPDFSizeTiny).
 The '1' is the first page. Careful; the accessor here is zero-based.
 (So page:0 andSize:PSPDFSizeNative would map to the file "p1.jpg".
 
 There are additional checks in place, if the URL you're returning is invalid the image will be rendered on the fly.
*/
- (NSURL *)cachedImageURLForPage:(NSUInteger)page andSize:(PSPDFSize)size;

/// Can be overridden to provide custom text. Defaults to nil.
/// if this returns nil for a site, we'll try to extract text ourselves.
/// Note: If you return text here, text highlighting cannot be used for this page.
- (NSString *)pageContentForPage:(NSUInteger)page;

/// Override if you want custom *page* background colors. Only displayed while loading, and when no thumbnail is yet available. Defaults to backgroundColor.
/// Will use kPSPDFBackgroundFillColor if set in renderOptions.
- (UIColor *)backgroundColorForPage:(NSUInteger)page;

/// Default background color for pages. Can be overridden by subclassing backgroundColorForPage.
/// Defaults to white.
@property (nonatomic, strong) UIColor *backgroundColor;

@end

// metadata keys.
extern NSString *const kPSPDFMetadataKeyTitle;
extern NSString *const kPSPDFMetadataKeyAuthor;
extern NSString *const kPSPDFMetadataKeySubject;
extern NSString *const kPSPDFMetadataKeySubject;
extern NSString *const kPSPDFMetadataKeyKeywords;
extern NSString *const kPSPDFMetadataKeyCreator;
extern NSString *const kPSPDFMetadataKeyProducer;
extern NSString *const kPSPDFMetadataKeyCreationDate;
extern NSString *const kPSPDFMetadataKeyModDate;
extern NSString *const kPSPDFMetadataKeyTrapped;
