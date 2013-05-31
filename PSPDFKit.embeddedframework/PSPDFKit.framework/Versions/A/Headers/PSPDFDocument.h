//
//  PSPDFDocument.h
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
#import "PSPDFCache.h"
#import "PSPDFAnnotation.h"
#import "PSPDFDocumentDelegate.h"
#import "PSPDFDocumentProvider.h"
#import <CoreGraphics/CoreGraphics.h>

@class PSPDFTextSearch, PSPDFOutlineParser, PSPDFPageInfo, PSPDFAnnotationParser, PSPDFViewController, PSPDFTextParser, PSPDFDocumentParser, PSPDFDocumentProvider, PSPDFBookmarkParser, PSPDFRenderReceipt;

// Annotations can be saved in the PDF or alongside in an external file.
typedef NS_ENUM(NSInteger, PSPDFAnnotationSaveMode) {
    PSPDFAnnotationSaveModeDisabled,
    PSPDFAnnotationSaveModeExternalFile, // Uses save/loadAnnotationsWithError in PSPDFAnnotationParser.
    PSPDFAnnotationSaveModeEmbedded,
    PSPDFAnnotationSaveModeEmbeddedWithExternalFileAsFallback // Default.
};

// Creates annotations based on the text content. See detectLinkTypes:forPagesInRange:.
typedef NS_OPTIONS(NSUInteger, PSPDFTextCheckingType) {
    PSPDFTextCheckingTypeLink        = 1 << 0,  // URLs
    PSPDFTextCheckingTypePhoneNumber = 1 << 1,  // Phone numbers
    PSPDFTextCheckingTypeAll         = NSUIntegerMax
};

// Menu options when text is selected on this document.
typedef NS_OPTIONS(NSUInteger, PSPDFDocumentMenuAction) {
    PSPDFDocumentMenuActionSearch              = 1 << 0,
    PSPDFDocumentMenuActionDefine              = 1 << 1,
    PSPDFDocumentMenuActionWikipediaAsFallback = 1 << 2, // Only displayed if Define fails/is missing.
    PSPDFDocumentMenuActionAll                 = NSUIntegerMax
};

// Called before the document starts to save annotations. Use to save any unsaved changes.
extern NSString *const PSPDFDocumentWillSaveNotification;

/**
 PSPDFDocument represents a single document for the user.
 Internally it might come from several different sources, files or data.

 Ensure that a document is only opened within *one* PSPDFViewController at a time.
 Documents fully support copy or serialization.

 To speed up PSPDFViewController display, you can invoke fillCache on any thread. Most methods are thread safe. If you change settings here while the document is already being displayed, you most likely need to call reloadData on  PSPDFViewController to refresh.

 Remember that rendered images of PSPDFDocument will be cached using PSPDFCache. If you replace/modify a PDF that has already been cached, you need to clear the cache for that document.

 PSPDFDocument is the default delegate for PSPDFDocumentProviderDelegate.
 */
@interface PSPDFDocument : NSObject <NSCopying, NSCoding, PSPDFDocumentProviderDelegate>

/// @name Initialization

/// Initialize empty PSPDFDocument.
+ (instancetype)document;

/// Initialize PSPDFDocument with a single file.
+ (instancetype)documentWithURL:(NSURL *)URL;

/// Initialize PSPDFDocument with data.
/// @warning You might want to set a custom UID when initialized with NSData, else the UID will be calculated from the PDF contents, which might be the same for two equal files.
/// In most cases, you really want to use a fileURL instead. When using NSData, PSPDFKit is unable to automatically save annotation changes back into the PDF. Also, keep in mind that iOS is an environment without virtual memory. Loading a 100MB PDF will simply get your app killed by the iOS watchdog while you try to allocate more memory than is available. If you use NSData because of encryption, look into CGDataProvider instead for a way to dynamically decrypt the needed portions of the PDF.
+ (instancetype)documentWithData:(NSData *)data;

/// Initialize PSPDFDocument with multiple data objects
+ (instancetype)documentWithDataArray:(NSArray *)dataArray;

/// Initialize PSPDFDocument with a dataProvider.
/// @warning You might need to manually set a UID to enable caching if the dataProvider is too big to be copied into memory.
+ (instancetype)documentWithDataProvider:(CGDataProviderRef)dataProvider;

/// Initialize PSPDFDocument with distinct path and an array of files.
+ (instancetype)documentWithBaseURL:(NSURL *)baseURL files:(NSArray *)files;

/// If you have files that have the pattern XXX_Page_0001 - XXX_Page_0200 use this initializer.
/// fileTemplate needs to have exactly one '%d' marker where the page should be.
/// For leading zeros, use the default printf syntax. (%04d = 0001)
+ (instancetype)documentWithBaseURL:(NSURL *)baseURL fileTemplate:(NSString *)fileTemplate startPage:(NSInteger)startPage endPage:(NSInteger)endPage;

- (id)init;
- (id)initWithURL:(NSURL *)URL;
- (id)initWithData:(NSData *)data;
- (id)initWithDataArray:(NSArray *)data;
- (id)initWithDataProvider:(CGDataProviderRef)dataProvider;
- (id)initWithBaseURL:(NSURL *)basePath files:(NSArray *)files;
- (id)initWithBaseURL:(NSURL *)basePath fileTemplate:(NSString *)fileTemplate startPage:(NSInteger)startPage endPage:(NSInteger)endPage;

/// Compare two documents.
- (BOOL)isEqualToDocument:(PSPDFDocument *)otherDocument;

/// Delegate. Used for annotation calls.
/// @warning The document delegate should not be your view controller, since this could retain your controller and cause a release on a different thread than the main thread, which can be problematic in UIKit.
@property (atomic, weak) id<PSPDFDocumentDelegate> delegate;

/// @name File Access / Modification

/// Appends a file to the current document. No PDF gets modified, just displayed together. Can be a name or partial path (full path if basePath is nil)
/// Adding the same file multiple times is allowed.
- (void)appendFile:(NSString *)file;

/// Returns path for a single page (in case pages are split up). Page starts at 0.
/// @note Uses fileIndexForPage and URLForFileIndex internally. Override those instead of pathForPage.
- (NSURL *)pathForPage:(NSUInteger)page;

/// Returns position of the internal file array.
- (NSInteger)fileIndexForPage:(NSUInteger)page;

/// Returns the URL corresponding to the fileIndex
- (NSURL *)URLForFileIndex:(NSInteger)fileIndex;

/// Returns a NSURL files array with the base path already added (if there is one)
- (NSArray *)filesWithBasePath;

/**
 Returns a dictionary with filename : NSData object.
 Memory-maps files; works with all available input types.
 If there's no file name, we use the PDF title or "Untitled PDF" if all fails.
 Uses PSPDFDocumentProviders dataRepresentationWithError. Errors are only logged.

 Returns an ordered NSDictionary (PSPDFOrderedDictionary).
 */
- (NSDictionary *)fileNamesWithDataDictionary;

/// Helper that gets a suggested fileName for a specific page.
- (NSString *)fileNameForPage:(NSUInteger)pageIndex;
- (NSString *)fileName; // Uses page 0.

/// Common base path for pdf files. Set to nil to use absolute paths for files.
@property (nonatomic, strong) NSURL *basePath;

/// Array of NSString pdf files. If basePath is set, this will be combined with the file name.
/// If basePath is not set, add the full path (as NSString) to the files.
/// @note It's currently not possible to add the file multiple times, this will fail to display correctly.
@property (nonatomic, copy) NSArray *files;

/// Usually, you have one single file URL representing the pdf. This is a shortcut setter for basePath* files. Overrides all current settings if set.
/// nil if the document was initialized with initWithData:
@property (nonatomic, strong) NSURL *fileURL;

/// PDF data when initialized with initWithData: otherwise nil.
/// This is a shortcut to the first entry of dataArray.
@property (nonatomic, copy, readonly) NSData *data;

/// A document can also have multiple NSData objects.
/// @note If writing annotations is enabled, the dataArray's content will change after a save.
@property (atomic, copy, readonly) NSArray *dataArray;

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
/// It's possible that there are keys that don't have a PSPDFKit define, loop the dictionary to find them all.
@property (nonatomic, copy, readonly) NSDictionary *metadata;

/// For caching, provide a *UNIQUE* UID here. (Or clear cache after content changes for same UID. Appending content is no problem)
@property (nonatomic, copy) NSString *UID;


/// @name Annotations

/// Annotation link extraction. Defaults to YES.
/// @note This will disable the creation of the PSPDFAnnotationParser and will automatically return nil on `editableAnnotationTypes`.
@property (nonatomic, assign, getter=isAnnotationsEnabled) BOOL annotationsEnabled;

/**
 Defines the annotations that can be edited (if annotationsEnabled is set to YES)
 Set this to an empty set to disable annotation editing/creation.

 Defaults to all available STRING constants (PSPDFAnnotationTypeStringHighlight, PSPDFAnnotationTypeStringInk, etc).

 Since PSPDFKit 2.8, this now is an ordered set - the order will change the button order in the toolbar and the page menu.

 @warning Some annotation types are only behaviorally different in PSPDFKit but are mapped to basic annotation types, so adding those will only change the creation of those types, not editing. Example: If you add PSPDFAnnotationTypeStringInk but not PSPDFAnnotationTypeStringSignature, signatures added in previous session will still be editable (since they are Ink annotations). On the other hand, if you set PSPDFAnnotationTypeStringSignature but not PSPDFAnnotationTypeStringInk, then your newly created signatures will not be movable. See PSPDFAnnotation.h for comments
*/
@property (nonatomic, copy) NSOrderedSet *editableAnnotationTypes;

/// Can PDF annotations be embedded?
/// @note Only evaluates the first file if multiple files are set.
/// This might block for a while since the PDF needs to be parsed to determine this.
@property (nonatomic, assign, readonly) BOOL canEmbedAnnotations;

/// Control if and where custom created PSPDFAnnotations are saved.
/// Possible options are PSPDFAnnotationSaveModeDisabled, PSPDFAnnotationSaveModeExternalFile, PSPDFAnnotationSaveModeEmbedded and PSPDFAnnotationSaveModeEmbeddedWithExternalFileAsFallback. (default)
@property (nonatomic, assign) PSPDFAnnotationSaveMode annotationSaveMode;

/// Default annotation username. Defaults to nil.
/// Written as the "T" (title/user) property of newly created annotations.
@property (nonatomic, copy) NSString *defaultAnnotationUsername;

/**
 Saves changed annotations back into the PDF sources (files/data).

 Returns NO if annotations cannot be embedded. Then most likely error is set.
 Returns YES if there are no annotations that need to be saved.

 Only available in PSPDFKit Annotate.
 */
- (BOOL)saveChangedAnnotationsWithError:(NSError **)error;

/// Returns YES if any provider of the document has dirty annotations that need saving.
- (BOOL)hasDirtyAnnotations;

/// Link annotation parser class for current document.
/// Can be overridden to use a subclassed annotation parser.
/// @note Only returns the parser for the first PDF file.
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
 Returns all annotations of all documentProviders.

 Returns dictionary NSNumber->NSArray. Only adds entries for a page if there are annotations.
 @warning This might take some time if the annotation cache hasn't been built yet.
 */
- (NSDictionary *)allAnnotationsOfType:(PSPDFAnnotationType)annotationType;

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
@property (nonatomic, assign, readonly) NSUInteger pageCount;

/// Limit pages to a certain page range.
/// If document has a pageRange set, the visible pages can be limited to a certain subset. Defaults to nil.
/// @warning Changing this will require a reloadData on the PSPDFViewController and also a clearCache for this document (as the cached pages will be different after changing this!)
@property (nonatomic, copy) NSIndexSet *pageRange;

/// Return PDF page number (PDF pages start at 1).
/// This may be different if a collection of pdfs is used a one big document. Page starts at 0.
- (NSUInteger)pageNumberForPage:(NSUInteger)page;

/// Equal to pageNumberForPage, but returns zero-based compensated page.
/// (Essentially pageNumberForPage-1)
- (NSUInteger)compensatedPageForPage:(NSUInteger)page;

/// Cached rotation and aspect ratio data for specific page. Page starts at 0.
/// Override the methods in PSPDFDocumentProvider instead.
- (PSPDFPageInfo *)pageInfoForPage:(NSUInteger)page;

/// Returns YES of pageInfo for page is available
- (BOOL)hasPageInfoForPage:(NSUInteger)page;

/// Makes a search beginning from page 0 for the nearest pageInfo. Does not calculate/block the thread.
- (PSPDFPageInfo *)nearestPageInfoForPage:(NSUInteger)page;

/// Aspect ratio is automatically cached and analyzed per page. Page starts at 0.
/// maybe needs a pdf lock if not already cached.
- (CGRect)rectBoxForPage:(NSUInteger)page;

/// Rotation for specified page. cached. Page starts at 0.
- (int)rotationForPage:(NSUInteger)page;

/// PDFBox that is used for rendering. Defaults to kCGPDFCropBox.
/// Older versions of PSPDFKit used kCGPDFCropBox by default.
@property (nonatomic, assign) CGPDFBox PDFBox;

/// Scan the whole document and analyzes if the aspect ratio is equal or not.
/// If this returns 0 or a very small value, it's perfectly suitable for pageCurl.
/// @note this might take a second on larger documents, as the page structure needs to be parsed.
- (CGFloat)aspectRatioVariance;


/// @name Caching

/**
 Will clear all cached objects (annotations, pageCount, ouline, textParser, ...)

 This is called implicitly if you change the files array or append a file.

 Important! Unless you disable it, PSPDFKit also has an image cache who is not affected by this. If you replace the PDF document with new content, you also need to clear the image cache:
 [PSPDFCache.sharedCache removeCacheForDocument:document deleteDocument:NO error:NULL];
 */
- (void)clearCache;

/// Creates internal cache for faster display. override to provide custom caching. usually called in a thread.
- (void)fillCache;
- (void)fillPageInfoCache; // part of fillCache.

/// Path where backupable cache data like bookmarks are saved.
/// Defaults to &lt;AppDirectory&gt;/Library/PrivateDocuments/PSPDFKit. Cannot be nil.
/// Will *always* be appended by UID. Don't manually append UID.
@property (nonatomic, copy) NSString *dataDirectory;

/// Make sure 'dataDirectory' exists. Returns error if creation is not possible.
- (BOOL)ensureDataDirectoryExistsWithError:(NSError **)error;

/// Overrides the global disk caching strategy in PSPDFCache.
/// Defaults to -1; which equals to the setting in PSPDFCache.
/// Set this to PSPDFDiskCacheNothing for sensible/encrypted documents!
@property (nonatomic, assign) PSPDFDiskCacheStrategy diskCacheStrategy;


/// @name Design and hints for PSPDFViewController

/// If aspect ratio is equal on all pages, you can enable this for even better performance. Defaults to NO.
@property (nonatomic, assign, getter=isAspectRatioEqual) BOOL aspectRatioEqual;

/// If document is displayed, returns currently active pdfController. Don't set this yourself. Optimizes caching.
@property (atomic, weak) PSPDFViewController *displayingPdfController;

/// Currently displayed page. Updated by PSPDFViewController. Used to make the memory cache smarter.
/// Set to NSNotFound if no controller displays the document.
@property (atomic, assign, readonly) NSUInteger displayingPage;

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

/// Was the PDF file encrypted at file creation time?
/// @note Only evaluates the first file if multiple files are set.
@property (nonatomic, assign, readonly) BOOL isEncrypted;

/// Name of the encryption filter used, e.g. Adobe.APS. If this is set, the document can't be unlocked.
/// See "Adobe LifeCycle DRM, http://www.adobe.com/products/livecycle/rightsmanagement
/// @note Only evaluates the first file if multiple files are set.
@property (nonatomic, copy, readonly) NSString *encryptionFilter;

/// Has the PDF file been unlocked? (is it still locked?).
/// @note Only evaluates the first file if multiple files are set.
@property (nonatomic, assign, readonly) BOOL isLocked;

/// Do the PDF digital right allow for printing?
/// @note Only evaluates the first file if multiple files are set.
@property (nonatomic, assign, readonly) BOOL allowsPrinting;

/// A flag that indicates whether copying text is allowed
/// @note Only evaluates the first file if multiple files are set.
/// Can also be overridden manually.
@property (nonatomic, assign) BOOL allowsCopying;

/// Allows to customize other displayed menu actions when text is selected.
/// Defaults to PSPDFDocumentMenuActionSearch|PSPDFDocumentMenuActionDefine|PSPDFDocumentMenuActionWikipediaAsFallback
/// @note This is no flag that gets parsed from the document (like allowsCopying) but seems to be  a better fit here than on the controller, since almost all menu related options are controller from the document.
@property (nonatomic, assign) PSPDFDocumentMenuAction allowedMenuActions;


/// @name Attached Parsers

/// Return a textParser for the specific document page.
- (PSPDFTextParser *)textParserForPage:(NSUInteger)page;

/// Checks if the text parser has already been loaded.
- (BOOL)hasLoadedTextParserForPage:(NSUInteger)page;

/// If YES, any glyphs (text, words) that are outside the visible page area will not be parsed.
/// Set early or call clearCache manually after changing this property. (since extracted text is cached)
/// Defaults to YES.
@property (nonatomic, assign) BOOL textParserHideGlyphsOutsidePageRect;

/// Text extraction class for current document.
/// Be careful where you're setting the delegate. You can also create a private PSPDFTextSearch class.
@property (nonatomic, strong) PSPDFTextSearch *textSearch;

/// Get the document provider for a specific page.
- (PSPDFDocumentProvider *)documentProviderForPage:(NSUInteger)page;

/// Get the page offset from a specific documentProvider.
/// Can be used to calculate from the document provider page to the PSPDFDocument page.
- (NSUInteger)pageOffsetForDocumentProvider:(PSPDFDocumentProvider *)documentProvider;

/// Get an array of documentProviders to easily manage documents with multiple files.
- (NSArray *)documentProviders;

/// Document Parser is per file, so might return the same parser for different pages.
/// (But we need to check as a PSPDFDocument can contain multiple files)
- (PSPDFDocumentParser *)documentParserForPage:(NSUInteger)page;

/// Outline extraction class for current document.
/// @warning Only returns the parser for the first PDF file.
@property (nonatomic, strong, readonly) PSPDFOutlineParser *outlineParser;

/// Globally enable/disable bookmarks. Defaults to YES.
@property (nonatomic, assign, getter=isBookmarksEnabled) BOOL bookmarksEnabled;

/// Accesses the bookmark parser.
/// Bookmarks are handled on document level, not on documentProvider.
@property (nonatomic, strong) PSPDFBookmarkParser *bookmarkParser;

/// Returns the bookmarks, with the pageRange of the document factored in.
/// @note The PSPDFBookmark objects themselves are not changed, only those who are not visible are filtered out.
- (NSArray *)bookmarks;

/// Set to NO to disable the custom PDF page labels and simply use page numbers. Defaults to YES.
@property (nonatomic, assign) BOOL pageLabelsEnabled;

/// Page labels (NSString) for the current document.
/// Might be nil if PageLabels isn't set in the PDF.
/// If substituteWithPlainLabel is set to YES then this always returns a valid string.
/// @note If `pageLabelsEnabled` is set to NO, then this method will either return nil or the plain label if `substite` is YES.
- (NSString *)pageLabelForPage:(NSUInteger)page substituteWithPlainLabel:(BOOL)substite;

/// Find page of a pageLabel.
- (NSUInteger)pageForPageLabel:(NSString *)pageLabel partialMatching:(BOOL)partialMatching;

/// @name PDF Page Rendering

// Special PDF rendering options for the methods in PSPDFDocument. For more options, see PSPDFPageRenderer.h
extern NSString *const kPSPDFPreserveAspectRatio;     // If added to options, this will change size to fit the aspect ratio.
extern NSString *const kPSPDFIgnoreDisplaySettings;   // Always draw pixels with a 1.0 scale.

/// Renders the page or a part of it with default display settings into a new image.
/// @param size          The size of the page, in pixels, if it was rendered without clipping
/// @param clipRect      A rectangle, relative to size, that specifies the area of the page that should be rendered. CGRectZero = automatic.
/// @param annotations   Annotations that should be rendered with the view
/// @param options       Dictionary with options that modify the render process (see PSPDFPageRenderer)
/// @param receipt       Returns the render receipt for the render action.
/// @param error         Returns an error object. (then image will be nil)
/// @return              A new UIImage with the rendered page content
- (UIImage *)renderImageForPage:(NSUInteger)page withSize:(CGSize)size clippedToRect:(CGRect)clipRect withAnnotations:(NSArray *)annotations options:(NSDictionary *)options receipt:(PSPDFRenderReceipt **)receipt error:(NSError **)error;

// Shorthand method.
- (UIImage *)renderImageForPage:(NSUInteger)page withSize:(CGSize)size clippedToRect:(CGRect)clipRect withAnnotations:(NSArray *)annotations options:(NSDictionary *)options;

/// Draw a page into a specified context.
/// If for some reason renderPage: doesn't return a Render Receipt, an error occured.
/// @note if `annotations` is nil, they will be auto-fetched. Add an empty array if you don't want to render annotations.
- (PSPDFRenderReceipt *)renderPage:(NSUInteger)page inContext:(CGContextRef)context withSize:(CGSize)size clippedToRect:(CGRect)clipRect withAnnotations:(NSArray *)annotations options:(NSDictionary *)options error:(NSError **)error;

/// Set custom render options (see PSPDFPageRenderer.h for options)
/// Options set here will override any options sent to renderImageForPage/renderPage.
/// This is the perfect place to change the background fill color, e.g. you would do this for a black document:
/// renderOptions = @{kPSPDFBackgroundFillColor : UIColor.blackColor};
/// This fixes tiny white/gray lines at the borders of a document that else might show up.
@property (nonatomic, copy) NSDictionary *renderOptions;

/// Set what annotations should be rendered. Defaults to PSPDFAnnotationTypeAll.
/// Set this to PSPDFAnnotationTypeLink|PSPDFAnnotationTypeHighlight for PSPDFKit v1 rendering style.
@property (nonatomic, assign) PSPDFAnnotationType renderAnnotationTypes;

/// @name Object Finder

// options
extern NSString *const kPSPDFObjectsGlyphs;                // Search glyphs.
extern NSString *const kPSPDFObjectsText;                  // Include Text.
extern NSString *const kPSPDFObjectsFullWords;             // Always return full PSPDFWords. Implies kPSPDFObjectsText.
extern NSString *const kPSPDFObjectsTextBlocks;            // Include text blocks, sorted after most appropriate.
extern NSString *const kPSPDFObjectsTextBlocksIgnoreLarge; // Ignore too large text blocks (that are > 90% of a page)
extern NSString *const kPSPDFObjectsAnnotationTypes;       // Include annotations of attached type
extern NSString *const kPSPDFObjectsAnnotationPageBounds;  // Special case; used for PSPDFAnnotationTypeNote hit testing.
extern NSString *const kPSPDFObjectsImages;                // Include Image info.
extern NSString *const kPSPDFObjectsSmartSort;             // Will sort words/annotations (smaller words/annots first). Use for touch detection.
extern NSString *const kPSPDFObjectsTextFlow;              // Will look at the text flow and select full sentences, not just what's within the rect.
extern NSString *const kPSPDFObjectsFindFirstOnly;         // Will stop after finding the first matching object.
extern NSString *const kPSPDFObjectsTestIntersection;      // Only relevant for rect. Will test for intersection instead of objects that are fully included in the pdfRect.

// Output categories
extern NSString *const kPSPDFGlyphs;
extern NSString *const kPSPDFWords;
extern NSString *const kPSPDFText;
extern NSString *const kPSPDFTextBlocks;
extern NSString *const kPSPDFAnnotations;
extern NSString *const kPSPDFImages;

/// Find objects at the current PDF point.
/// If options is nil, we assume kPSPDFObjectsText and kPSPDFObjectsFullWords.
/// Unless set otherwise, for points kPSPDFObjectsTestIntersection is YES automatically.
/// Returns objects in certain key dictionaries (kPSPDFGlyphs, etc)
- (NSDictionary *)objectsAtPDFPoint:(CGPoint)pdfPoint page:(NSUInteger)page options:(NSDictionary *)options;

/// Find objects at the current PDF rect.
/// If options is nil, we assume kPSPDFGlyphs only.
/// Returns objects in certain key dictionaries (kPSPDFGlyphs, etc)
- (NSDictionary *)objectsAtPDFRect:(CGRect)pdfRect page:(NSUInteger)page options:(NSDictionary *)options;

@end

@interface PSPDFDocument (Subclassing)

/// Use this to use specific subclasses instead of the default PSPDF* classes.
/// e.g. add an entry of PSPDFAnnotationParser.class / MyCustomAnnotationParser.class to use the custom subclass.
/// (MyCustomAnnotationParser must be a subclass of PSPDFAnnotationParser)
/// @throws an exception if the overriding class is not a subclass of the overridden class.
/// @note Does not get serialized when saved to disk. Only set from the main thread, before you first use the object.
- (void)overrideClass:(Class)builtinClass withClass:(Class)subclass;

/// Dictionary with key/value pairs of classes to override.
@property (nonatomic, copy) NSDictionary *overrideClassNames;

/// Hook to modify/return a different document provider. Called each time a documentProvider is created (which is usually on first access, and cached afterwards)
/// During PSPDFDocument lifetime, document providers might be created at any time, lazily, and destroyed when memory is low.
/// This might be used to change the delegate of the PSPDFDocumentProvider.
- (PSPDFDocumentProvider *)didCreateDocumentProvider:(PSPDFDocumentProvider *)documentProvider;

/// Register a block that is called in didCreateDocumentProvider.
/// @warning This needs to be set before the document providers have been created (thus, before accessing properties like pageCount or setting it to the view controller)
- (void)setDidCreateDocumentProviderBlock:(void (^)(PSPDFDocumentProvider *documentProvider))block;

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
/// @note If you return text here, text highlighting cannot be used for this page.
- (NSString *)pageContentForPage:(NSUInteger)page;

/// Override if you want custom *page* background colors. Only displayed while loading, and when no thumbnail is yet available. Defaults to backgroundColor.
/// Will use kPSPDFBackgroundFillColor if set in renderOptions.
- (UIColor *)backgroundColorForPage:(NSUInteger)page;

/// Default background color for pages. Can be overridden by subclassing backgroundColorForPage.
/// Defaults to white.
@property (nonatomic, strong) UIColor *backgroundColor;

/// Helper for higher performance.
- (PSPDFPageInfo *)pageInfoForPage:(NSUInteger)page pageRef:(CGPDFPageRef)pageRef;

/// Experimental. Will iterate all pages and create new annotations for the set types.
/// Will ignore any text that is already linked with the same URL.
/// To analyze the whole document, use [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)]
/// @warning Performs text and annotation extraction and analysis. Might be slow. Call this before showing the document in the PSPDFViewController or manually add the link annotations.
- (NSArray *)detectLinkTypes:(PSPDFTextCheckingType)textLinkType forPagesInRange:(NSIndexSet *)pageRange;

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

@interface PSPDFDocument (SubclassingHooks)

// Override to customize file name for the send via email feature.
- (NSString *)fileNameForIndex:(NSUInteger)fileIndex;

// Returns the page of the pageRange feature
- (NSUInteger)pageWithPageRange:(NSUInteger)page;

@end

@interface PSPDFDocument (Deprecated)

typedef NSInteger PSPDFCacheStrategy;
#define PSPDFCacheNothing 0
#define PSPDFCacheThumbnails 1
#define PSPDFCacheThumbnailsAndNearPages 2
#define PSPDFCacheOpportunistic 2
@property (nonatomic, assign) PSPDFCacheStrategy cacheStrategy __attribute__ ((deprecated("Use diskCacheStragegy instead")));

@property (nonatomic, copy) NSString *cacheDirectory __attribute__ ((deprecated("Use dataDirectory instead")));
+ (instancetype)PDFDocument __attribute__ ((deprecated("Use document instead")));
+ (instancetype)PDFDocumentWithURL:(NSURL *)URL __attribute__ ((deprecated("Use documentWithURL: instead")));
+ (instancetype)PDFDocumentWithData:(NSData *)data __attribute__ ((deprecated("Use documentWithData: instead")));
+ (instancetype)PDFDocumentWithDataArray:(NSArray *)dataArray __attribute__ ((deprecated("Use documentWithDataArray: instead")));
+ (instancetype)PDFDocumentWithDataProvider:(CGDataProviderRef)dataProvider __attribute__ ((deprecated("Use documentWithDataProvider: instead")));
+ (instancetype)PDFDocumentWithBaseURL:(NSURL *)baseURL files:(NSArray *)files __attribute__ ((deprecated("Use documentWithBaseURL:files: instead")));
+ (instancetype)PDFDocumentWithBaseURL:(NSURL *)baseURL fileTemplate:(NSString *)fileTemplate startPage:(NSInteger)startPage endPage:(NSInteger)endPage __attribute__ ((deprecated("Use documentWithBaseURL:fileTemplate:startPage:endPage: instead")));

@end
