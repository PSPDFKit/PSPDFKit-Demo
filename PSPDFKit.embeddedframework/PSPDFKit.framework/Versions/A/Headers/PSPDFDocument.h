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
#import "PSPDFDocumentProvider.h"
#import "PSPDFOverridable.h"
#import <CoreGraphics/CoreGraphics.h>

@class PSPDFFormParser, PSPDFTextSearch, PSPDFOutlineParser, PSPDFPageInfo, PSPDFAnnotationManager, PSPDFViewController, PSPDFTextParser,PSPDFDocumentProvider, PSPDFBookmarkParser, PSPDFRenderReceipt;

@protocol PSPDFDocumentDelegate;

/**
* The PSPDFDocument class represents a single logical document for the user.
* It can use multiple data sources (files, NSData, CGDataProvider) that are then merged together on display.
*
* Ensure that a PSPDFDocument is only opened by one PSPDFViewController at any time.
*
* You're expected to set any properties on a single thread only (usually the main thread)
* Changing properties once the document is visible will require calling reloadData on the controller most of the time.
*
* PSPDFDocument builds up some cache when properties like `pageCount` are first accessed.
* You want to create those objects once and keep them around, creating and destroying them on the fly is very wasteful.
* If you change the underlying files the PSPDFDocument points to, you need to clear it's internal cache.
*
* To speed up the first time the document is displayed in the PSPDFViewController, you can call fillCache on any thread.
*/
@interface PSPDFDocument : NSObject <PSPDFDocumentProviderDelegate, PSPDFOverridable, NSCopying, NSCoding, NSFastEnumeration>

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

/// Initialize PSPDFDocument with a dataProviders.
+ (instancetype)documentWithDataProviderArray:(NSArray *)dataProviders;

/// Initialize PSPDFDocument with distinct path and an array of files.
+ (instancetype)documentWithBaseURL:(NSURL *)baseURL files:(NSArray *)files;

/// If you have files that have the pattern XXX_Page_0001 - XXX_Page_0200 use this initializer.
/// fileTemplate needs to have exactly one '%d' marker where the page should be.
/// For leading zeros, use the default printf syntax. (%04d = 0001)
+ (instancetype)documentWithBaseURL:(NSURL *)baseURL fileTemplate:(NSString *)fileTemplate startPage:(NSInteger)startPage endPage:(NSInteger)endPage;

// Regular init methods.
- (id)init;
- (id)initWithURL:(NSURL *)URL;
- (id)initWithData:(NSData *)data;
- (id)initWithDataArray:(NSArray *)data;
- (id)initWithDataProvider:(CGDataProviderRef)dataProvider;
- (id)initWithDataProviderArray:(NSArray *)dataProviders;
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

/// Returns an ordered dictionary with filename : NSData objects.
/// Will memory-map data files.
/// @note If there is no file name available, this will use the PDF title or "Untitled PDF" if all fails.
/// Uses PSPDFDocumentProviders dataRepresentationWithError. Errors are only logged.
- (NSDictionary *)fileNamesWithDataDictionary;

/// Helper that gets a suggested fileName for a specific page.
- (NSString *)fileNameForPage:(NSUInteger)pageIndex;
- (NSString *)fileName; // Page 0

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
@property (nonatomic, copy, readonly) NSArray *dataArray;

/// PDF dataProviders (can be used to dynamically decrypt a document). Will be retained when set.
@property (nonatomic, copy, readonly) NSArray *dataProviderArray;

/// For caching, provide a *UNIQUE* UID here. (Or clear cache after content changes for same UID. Appending content is no problem)
@property (nonatomic, copy) NSString *UID;

/// Returns YES if the document is valid (if it has at least one page)
/// Might need file operations to parse the document (slow)
@property (nonatomic, assign, readonly, getter=isValid) BOOL valid;

/// Get the document provider for a specific page.
- (PSPDFDocumentProvider *)documentProviderForPage:(NSUInteger)page;

/// Get the page offset from a specific documentProvider.
/// Can be used to calculate from the document provider page to the PSPDFDocument page.
- (NSUInteger)pageOffsetForDocumentProvider:(PSPDFDocumentProvider *)documentProvider;

/// Get an array of documentProviders to easily manage documents with multiple files.
- (NSArray *)documentProviders;

/// @name Page Info Data

/// Return pdf page count. Can be called from any thread.
/// @warning Might need file operations to parse the document (slow)
@property (nonatomic, assign, readonly) NSUInteger pageCount;

/// Limit pages to a certain page range.
/// If document has a pageRange set, the visible pages can be limited to a certain subset. Defaults to nil.
/// @warning Changing this will require a reloadData on the PSPDFViewController and also a clearCache for this document (as the cached pages will be different after changing this!)
@property (nonatomic, copy) NSIndexSet *pageRange;

// Returns the page of the pageRange feature.
- (NSUInteger)pageWithPageRange:(NSUInteger)page;

/// Return PDF page number (PDF page number start at 1, `page` starts at zero).
/// Will return the correct page number even on multi-file PDFs.
- (NSUInteger)PDFPageNumberForPage:(NSUInteger)page;

/// Cached rotation and aspect ratio data for specific page. Page starts at 0.
/// Override the methods in PSPDFDocumentProvider instead.
- (PSPDFPageInfo *)pageInfoForPage:(NSUInteger)page;

/// @name Design and hints for PSPDFViewController

/// If document is displayed, returns currently active pdfController. Don't set this yourself. Optimizes caching.
@property (atomic, weak) PSPDFViewController *displayingPdfController;

/// Currently displayed page. Updated by PSPDFViewController. Used to make the memory cache smarter.
/// Set to NSNotFound if no controller displays the document.
@property (atomic, assign, readonly) NSUInteger displayingPage;

/// @name Attached Parsers

/// Text extraction class for current document.
/// Be careful where you're setting the delegate. You can also create a private PSPDFTextSearch class.
@property (nonatomic, strong) PSPDFTextSearch *textSearch;

/// Outline extraction class for current document.
/// @warning Only returns the parser for the first PDF file.
@property (nonatomic, strong, readonly) PSPDFOutlineParser *outlineParser;

/// Save additional properties here. This will not be used by the document.
@property (nonatomic, copy) NSDictionary *userInfo;

@end

@interface PSPDFDocument (Caching)

/**
 Will clear all cached objects (annotations, pageCount, outline, textParser, ...)

 This is called implicitly if you change the files array or append a file.

 Important! Unless you disable it, PSPDFKit also has an image cache who is not affected by this. If you replace the PDF document with new content, you also need to clear the image cache:
 [PSPDFCache.sharedCache removeCacheForDocument:document deleteDocument:NO error:NULL];
 */
- (void)clearCache;

/// Creates internal cache for faster display. override to provide custom caching. usually called in a thread.
- (void)fillCache;

/// Path where backup-able cache data like bookmarks or annotations (if they can't be embedded into the PDF) are saved.
/// Defaults to &lt;AppDirectory&gt;/Library/PrivateDocuments/PSPDFKit. Cannot be nil.
/// Will *always* be appended by UID. Don't manually append UID.
@property (nonatomic, copy) NSString *dataDirectory;

/// Make sure 'dataDirectory' exists. Returns error if creation is not possible.
- (BOOL)ensureDataDirectoryExistsWithError:(NSError **)error;

/// Overrides the global disk caching strategy in PSPDFCache.
/// Defaults to -1; which equals to the setting in PSPDFCache.
/// Set this to PSPDFDiskCacheNothing for sensible/encrypted documents!
@property (nonatomic, assign) PSPDFDiskCacheStrategy diskCacheStrategy;

@end


@interface PSPDFDocument (Security)

/**
 * Unlock documents with a password.
 * Only saves the password if unlocking was successful (vs setPassword that saves the password always)
 *
 * If the password is correct, this method returns YES. Once unlocked, you cannot use this function to re-lock the document.
 *
 * If you attempt to unlock an already unlocked document, one of the following occurs:
 * If the document is unlocked with full owner permissions, unlockWithPassword: does nothing and returns YES. The password string is ignored.
 * If the document is unlocked with only user permissions, unlockWithPassword attempts to obtain full owner permissions with the password string.
 * If the string fails, the document maintains its user permissions. In either case, this method returns YES.
 *
 * After unlocking a document, you need to call reloadData on the PSPDFViewController.
 *
 * If you're using multiple files or appendFile, all new files will be unlocked with the password.
 * This doesn't harm if the document is already unlocked.
 *
 * If you have a mixture of files with multiple different passwords, you need to subclass didCreateDocumentProvider: and unlock the documentProvider directly there.
 */
- (BOOL)unlockWithPassword:(NSString *)password;

/// Set a base password to be used for all files in this document (if the document is PDF encrypted).
/// Relays the password to all current and future documentProviders.
/// The password will be ignored if the document is not password protected.
@property (nonatomic, copy) NSString *password;

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

@end


@interface PSPDFDocument (Bookmarks)

/// Globally enable/disable bookmarks. Defaults to YES.
@property (nonatomic, assign, getter=isBookmarksEnabled) BOOL bookmarksEnabled;

/// Accesses the bookmark parser.
/// Bookmarks are handled on document level, not on documentProvider.
@property (nonatomic, strong) PSPDFBookmarkParser *bookmarkParser;

/// Returns the bookmarks, with the pageRange of the document factored in.
/// @note The PSPDFBookmark objects themselves are not changed, only those who are not visible are filtered out.
- (NSArray *)bookmarks;

@end

@interface PSPDFDocument (PageLabels)

/// Set to NO to disable the custom PDF page labels and simply use page numbers. Defaults to YES.
@property (nonatomic, assign, getter=isPageLabelsEnabled) BOOL pageLabelsEnabled;

/// Page labels (NSString) for the current document.
/// Might be nil if PageLabels isn't set in the PDF.
/// If substituteWithPlainLabel is set to YES then this always returns a valid string.
/// @note If `pageLabelsEnabled` is set to NO, then this method will either return nil or the plain label if `substitute` is YES.
- (NSString *)pageLabelForPage:(NSUInteger)page substituteWithPlainLabel:(BOOL)substitute;

/// Find page of a pageLabel.
- (NSUInteger)pageForPageLabel:(NSString *)pageLabel partialMatching:(BOOL)partialMatching;

@end

@interface PSPDFDocument (Forms)

/// Set to NO to disable displaying/editing AcroForms. Defaults to YES.
/// @note Not all PSPDFKit variants do support AcroForms.
/// @warning For `formsEnabled` to work, you need to also set `annotationsEnabled` to YES, since forms are simply a special sub-type of Widget-annotations.
@property (nonatomic, assign, getter=isFormsEnabled) BOOL formsEnabled;

/// AcroForm parser for the document.
@property (nonatomic, strong, readonly) PSPDFFormParser *formParser;

@end


// Annotations can be saved in the PDF or alongside in an external file.
typedef NS_ENUM(NSInteger, PSPDFAnnotationSaveMode) {
    PSPDFAnnotationSaveModeDisabled,
    PSPDFAnnotationSaveModeExternalFile, // Uses save/loadAnnotationsWithError in PSPDFAnnotationManager.
    PSPDFAnnotationSaveModeEmbedded,
    PSPDFAnnotationSaveModeEmbeddedWithExternalFileAsFallback
};

@interface PSPDFDocument (Annotations)

/// Master switch to completely disable annotation display/parsing on a document. Defaults to YES.
/// @note This will disable the creation of the PSPDFAnnotationManager and will automatically return nil on `editableAnnotationTypes`.
@property (nonatomic, assign, getter=isAnnotationsEnabled) BOOL annotationsEnabled;

/// Returns annotations for a specific `page`.
///
/// This replaces following code:
/// NSUInteger compensatedPage = [document documentProviderRelativePageWithPageRangeCompensated:self.page];
/// PSPDFAnnotationManager *annotationManager = [document annotationManagerForPage:self.page];
/// NSArray *annotations = [annotationManager annotationsForPage:compensatedPage type:PSPDFAnnotationTypeAll];
- (NSArray *)annotationsForPage:(NSUInteger)page type:(PSPDFAnnotationType)type;

/// Add `annotations` to the current document.
/// @note For each, the `absolutePage` property of the annotation is used.
/// @warning Might change the `page` property if multiple documentProviders are set.
- (BOOL)addAnnotations:(NSArray *)annotations;

/// Remove `annotations`.
- (BOOL)removeAnnotations:(NSArray *)annotations;

/// Returns all annotations in this document in the form of an NSNumber->NSArray dictionary.
/// Will not add key entries for pages without annotations.
/// @warning Parsing annotations can take some time. Can be called from a background thread.
- (NSDictionary *)allAnnotationsOfType:(PSPDFAnnotationType)annotationType;

/// Returns the annotationManager for the documentProvider matched by `page`.
/// @note Remember that page within the PSPDFAnnotationManager is relative to the documentProvider.
/// Use NSUInteger compensatedPage = [self documentProviderRelativePageWithPageRangeCompensated:page] to compensate when working with the annotation parser.
- (PSPDFAnnotationManager *)annotationManagerForPage:(NSUInteger)page;

@end

@interface PSPDFDocument (AnnotationSaving)

// Called before the document starts to save annotations. Use to save any unsaved changes.
extern NSString *const PSPDFDocumentWillSaveAnnotationsNotification;

/// Modify what annotations are editable and can be created. Set to nil to completely disable annotation editing/creation.
/// Defaults to an ordered set with all available annotation string constants with the exception of PSPDFAnnotationStringLink.
/// @note The order changes the order as items appear in the annotation toolbar.
///
/// @warning Some annotation types are only behaviorally different in PSPDFKit but are mapped to basic annotation types,
/// so adding those will only change the creation of those types, not editing.
/// Example: If you add PSPDFAnnotationStringInk but not PSPDFAnnotationStringSignature,
/// signatures added in previous session will still be editable (since they are Ink annotations).
/// On the other hand, if you set PSPDFAnnotationStringSignature but not PSPDFAnnotationStringInk,
/// then your newly created signatures will not be movable. See PSPDFAnnotation.h for comments
@property (nonatomic, copy) NSOrderedSet *editableAnnotationTypes;

/// Tests if we can embed annotations into this PDF. Certain PDFs (e.g. with encryption, or broken xref index) are readonly.
/// @note Only evaluates the first file if multiple files are set.
/// @warning This might block for a while, the PDF needs to be parsed to determine this.
@property (nonatomic, assign, readonly) BOOL canEmbedAnnotations;

/// Control if and where PSPDFObjectsAnnotationKey are saved.
/// Possible options are PSPDFAnnotationSaveModeDisabled, PSPDFAnnotationSaveModeExternalFile, PSPDFAnnotationSaveModeEmbedded and PSPDFAnnotationSaveModeEmbeddedWithExternalFileAsFallback. (default)
@property (nonatomic, assign) PSPDFAnnotationSaveMode annotationSaveMode;

/// Default annotation username for new annotations. Defaults to the device name.
/// Written as the "T" (title/user) property of newly created annotations.
@property (nonatomic, copy) NSString *defaultAnnotationUsername;

// Contains the boxed PSPDFAnnotationType to control appearance stream generation for each type.
extern NSString *const PSPDFAnnotationWriteOptionsGenerateAppearanceStreamForTypeKey;

/// Allows control over what annotation should get an AP stream.
/// AP (Appearance Stream) generation takes more time but will maximize compatibility with PDF Viewers that don't implement the complete spec for annotations.
/// The default value for this dict is @{PSPDFAnnotationWriteOptionsGenerateAppearanceStreamForTypeKey : @(PSPDFAnnotationTypeFreeText|PSPDFAnnotationTypeInk|PSPDFAnnotationTypePolygon|PSPDFAnnotationTypePolyLine|PSPDFAnnotationTypeLine|PSPDFAnnotationTypeSquare|PSPDFAnnotationTypeCircle)}
@property (nonatomic, copy) NSDictionary *annotationWritingOptions;

/// Saves changed annotations in an external file or PDF, depending on `annotationSaveMode`.
/// Can be called on any thread.
/// @note Not available in PSPDFKit Viewer.
- (void)saveAnnotationsWithCompletionBlock:(void (^)(NSArray *savedAnnotations, NSError *error))completionBlock;
- (BOOL)saveAnnotationsWithError:(NSError **)error; // sync variant.

/// Returns YES if there are unsaved annotations.
- (BOOL)hasDirtyAnnotations;

@end


@interface PSPDFDocument (Rendering)

// Special PDF rendering options for the methods in PSPDFDocument. For more options, see PSPDFPageRenderer.h
extern NSString *const PSPDFPreserveAspectRatio;     // If added to options, this will change size to fit the aspect ratio.
extern NSString *const PSPDFIgnoreDisplaySettings;   // Always draw pixels with a 1.0 scale.

/// Renders the page or a part of it with default display settings into a new image.
/// @param size          The size of the page, in pixels, if it was rendered without clipping
/// @param clipRect      A rectangle, relative to size, that specifies the area of the page that should be rendered. CGRectZero = automatic.
/// @param annotations   Annotations that should be rendered with the view
/// @param options       Dictionary with options that modify the render process (see PSPDFPageRenderer)
/// @param receipt       Returns the render receipt for the render action.
/// @param error         Returns an error object. (then image will be nil)
/// @return              A new UIImage with the rendered page content
- (UIImage *)imageForPage:(NSUInteger)page size:(CGSize)size clippedToRect:(CGRect)clipRect annotations:(NSArray *)annotations options:(NSDictionary *)options receipt:(PSPDFRenderReceipt **)receipt error:(NSError **)error;

/// Draw a page into a specified context.
/// If for some reason renderPage: doesn't return a Render Receipt, an error occurred.
/// @note if `annotations` is nil, they will be auto-fetched. Add an empty array if you don't want to render annotations.
- (PSPDFRenderReceipt *)renderPage:(NSUInteger)page context:(CGContextRef)context size:(CGSize)size clippedToRect:(CGRect)clipRect annotations:(NSArray *)annotations options:(NSDictionary *)options error:(NSError **)error;

/// Set custom render options (see PSPDFPageRenderer.h for options)
/// Options set here will override any options sent to imageForPage/renderPage.
/// @note This is the perfect place to change the background fill color, e.g. you would do this for a black document:
/// renderOptions = @{PSPDFRenderBackgroundFillColor : UIColor.blackColor};
/// This fixes tiny white/gray lines at the borders of a document that else might show up.
@property (nonatomic, copy) NSDictionary *renderOptions;

/// Set what annotations should be rendered. Defaults to PSPDFAnnotationTypeAll.
@property (nonatomic, assign) PSPDFAnnotationType renderAnnotationTypes;

@end

// Creates annotations based on the text content. See detectLinkTypes:forPagesInRange:.
typedef NS_OPTIONS(NSUInteger, PSPDFTextCheckingType) {
    PSPDFTextCheckingTypeNone        = 0,
    PSPDFTextCheckingTypeLink        = 1 << 0,  // URLs
    PSPDFTextCheckingTypePhoneNumber = 1 << 1,  // Phone numbers
    PSPDFTextCheckingTypeAll         = NSUIntegerMax
};

@interface PSPDFDocument (DataDetection)

/// Set this property to allow automatic link detection. Will only add links where no link annotations already exist.
/// Defaults to PSPDFTextCheckingTypeNone for performance reasons. Set to PSPDFTextCheckingTypeLink if you are see URLs in your document that are not clickable. PSPDFTextCheckingTypeLink is the default behavior for desktop apps like Adobe Acrobat or Apple Preview.app.
/// @note This requires that you keep the `PSPDFFileAnnotationProvider` in the `annotationManager`. (Default). Needs to be set before the document is being displayed or annotations are accessed!
/// @warning Autodetecting links is useful but might slow down annotation display.
@property (nonatomic, assign) PSPDFTextCheckingType autodetectTextLinkTypes;

/// Iterates over all pages in `pageRange` and creates new annotations for the defined types in `textLinkTypes`.
/// Will ignore any text that is already linked with the same URL.
/// It is your responsibility to add the annotations to the document.
///
/// @note To analyze the whole document, use [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)]
/// @warning Performs text and annotation extraction and analysis. Might be slow.
/// @warning `progressBlock` might be called from different threads - ensure you dispatch to the main queue for progress updates.
- (NSDictionary *)annotationsFromDetectingLinkTypes:(PSPDFTextCheckingType)textLinkTypes pagesInRange:(NSIndexSet *)pageRange progress:(void (^)(NSArray *annotations, NSUInteger page, BOOL *stop))progressBlock error:(NSError **)error;

@end


@interface PSPDFDocument (ObjectFinder)

// Options for the object finder.
extern NSString *const PSPDFObjectsGlyphs;                // Search glyphs.
extern NSString *const PSPDFObjectsText;                  // Include Text.
extern NSString *const PSPDFObjectsFullWords;             // Always return full PSPDFWords. Implies PSPDFObjectsText.
extern NSString *const PSPDFObjectsTextBlocks;            // Include text blocks, sorted after most appropriate.
extern NSString *const PSPDFObjectsTextBlocksIgnoreLarge; // Ignore too large text blocks (that are > 90% of a page)
extern NSString *const PSPDFObjectsAnnotationTypes;       // Include annotations of attached type
extern NSString *const PSPDFObjectsAnnotationPageBounds;  // Special case; used for PSPDFAnnotationTypeNote hit testing.
extern NSString *const PSPDFObjectsImages;                // Include Image info.
extern NSString *const PSPDFObjectsSmartSort;             // Will sort words/annotations (smaller words/annots first). Use for touch detection.
extern NSString *const PSPDFObjectsTextFlow;              // Will look at the text flow and select full sentences, not just what's within the rect.
extern NSString *const PSPDFObjectsFindFirstOnly;         // Will stop after finding the first matching object.
extern NSString *const PSPDFObjectsTestIntersection;      // Only relevant for rect. Will test for intersection instead of objects that are fully included in the pdfRect.

// Output categories
extern NSString *const PSPDFObjectsGlyphKey;
extern NSString *const PSPDFObjectsWordKey;
extern NSString *const PSPDFObjectsTextKey;
extern NSString *const PSPDFObjectsTextBlockKey;
extern NSString *const PSPDFObjectsAnnotationKey;
extern NSString *const PSPDFObjectsImageKey;

/// Find objects (glyphs, words, images, annotations) at the specified `pdfPoint`. Thread safe.
/// If `options` is nil, we assume PSPDFObjectsText and PSPDFObjectsFullWords.
/// Unless set otherwise, for points PSPDFObjectsTestIntersection is YES automatically.
/// Returns objects in certain key dictionaries (PSPDFObjectsGlyphKey, etc)
- (NSDictionary *)objectsAtPDFPoint:(CGPoint)pdfPoint page:(NSUInteger)page options:(NSDictionary *)options;

/// Find objects (glyphs, words, images, annotations) at the specified `pdfRect`. Thread safe.
/// If `options` is nil, we assume PSPDFObjectsGlyphKey only.
/// Returns objects in certain key dictionaries (PSPDFObjectsGlyphKey, etc)
- (NSDictionary *)objectsAtPDFRect:(CGRect)pdfRect page:(NSUInteger)page options:(NSDictionary *)options;

/// Return a textParser for the specific document page. Thread safe.
- (PSPDFTextParser *)textParserForPage:(NSUInteger)page;

/// Checks if the text parser has already been loaded. Thread safe.
- (BOOL)hasLoadedTextParserForPage:(NSUInteger)page;

/// Text can be defined outside of the visible page area. Usually this is unexpected and a leftover, so this defaults to YES.
/// Set this early before any page textParser is accessed.
@property (nonatomic, assign) BOOL textParserHideGlyphsOutsidePageRect;

@end


@interface PSPDFDocument (Metadata)

/// Document title as shown in the controller.
/// If this is not set, the framework tries to extract the title from the PDF metadata.
/// If there's no metadata, the fileName is used. ".pdf" endings will be removed either way.
@property (nonatomic, copy) NSString *title;

/// Title might need to parse the file and is potentially slow.
/// Use this to check if title is loaded and access title in a thread if not.
@property (nonatomic, assign, readonly, getter=isTitleLoaded) BOOL titleLoaded;

// metadata keys.
extern NSString *const PSPDFMetadataKeyTitle;
extern NSString *const PSPDFMetadataKeyAuthor;
extern NSString *const PSPDFMetadataKeySubject;
extern NSString *const PSPDFMetadataKeySubject;
extern NSString *const PSPDFMetadataKeyKeywords;
extern NSString *const PSPDFMetadataKeyCreator;
extern NSString *const PSPDFMetadataKeyProducer;
extern NSString *const PSPDFMetadataKeyCreationDate;
extern NSString *const PSPDFMetadataKeyModDate;
extern NSString *const PSPDFMetadataKeyTrapped;

/// Access the PDF metadata of the first PDF document.
/// A PDF might not have any metadata at all.
/// See PSPDFMetadataKeyTitle and the following defines for keys that might be set.
/// It's possible that there are keys that don't have a PSPDFKit define, loop the dictionary to find them all.
@property (nonatomic, copy, readonly) NSDictionary *metadata;

@end


@interface PSPDFDocument (SubclassingHooks)

/// Use this to use specific subclasses instead of the default PSPDF* classes.
/// e.g. add an entry of PSPDFAnnotationManager.class / MyCustomAnnotationManager.class to use the custom subclass.
/// (MyCustomAnnotationManager must be a subclass of PSPDFAnnotationManager)
/// @throws an exception if the overriding class is not a subclass of the overridden class.
/// @note Does not get serialized when saved to disk. Only set from the main thread, before you first use the object.
- (void)overrideClass:(Class)builtinClass withClass:(Class)subclass;

/// Hook to modify/return a different document provider. Called each time a documentProvider is created (which is usually on first access, and cached afterwards)
/// During PSPDFDocument lifetime, document providers might be created at any time, lazily, and destroyed when memory is low.
/// This might be used to change the delegate of the PSPDFDocumentProvider.
- (PSPDFDocumentProvider *)didCreateDocumentProvider:(PSPDFDocumentProvider *)documentProvider;

/// Register a block that is called in didCreateDocumentProvider.
/// @warning This needs to be set very early, before the document providers have been created (thus, before accessing any properties like pageCount or setting it to the view controller)
- (void)setDidCreateDocumentProviderBlock:(void (^)(PSPDFDocumentProvider *documentProvider))block;

/// Can be overridden to provide custom text. Defaults to nil.
/// if this returns nil for a site, we'll try to extract text ourselves.
/// @note If you return text here, text highlighting cannot be used for this page.
- (NSString *)pageContentForPage:(NSUInteger)page;

/// Override if you want custom *page* background colors. Only displayed while loading, and when no thumbnail is yet available. Defaults to backgroundColor.
/// Will use PSPDFRenderBackgroundFillColor if set in renderOptions.
- (UIColor *)backgroundColorForPage:(NSUInteger)page;

/// Default background color for pages. Can be overridden by subclassing backgroundColorForPage.
/// Defaults to white.
@property (nonatomic, strong) UIColor *backgroundColor;

/// Helper for higher performance.
- (PSPDFPageInfo *)pageInfoForPage:(NSUInteger)page pageRef:(CGPDFPageRef)pageRef;

// Override to customize file name for the send via email feature.
- (NSString *)fileNameForIndex:(NSUInteger)fileIndex;

@end


@class PSPDFUndoController;

@interface PSPDFDocument (Advanced)

/// PDFBox that is used for rendering. Defaults to kCGPDFCropBox.
/// Older versions of PSPDFKit used kCGPDFCropBox by default.
@property (nonatomic, assign) CGPDFBox PDFBox;

/// Scan the whole document and analyzes if the aspect ratio is equal or not.
/// If this returns 0 or a very small value, it's perfectly suitable for pageCurl.
/// @note this might take a second on larger documents, as the page structure needs to be parsed.
- (CGFloat)aspectRatioVariance;

/// If aspect ratio is equal on all pages, you can enable this for even better performance. Defaults to NO.
@property (nonatomic, assign, getter=isAspectRatioEqual) BOOL aspectRatioEqual;

// The undo manager attached to the document. Set to nil to disable undo/redo management.
// @Note Undo/Redo has a small performance impact since all annotation operations are tracked.
@property (nonatomic, strong) PSPDFUndoController *undoController;

// To calculate pages between multiple document providers and if you use the `pageRange` feature.
- (NSUInteger)documentProviderRelativePageForPage:(NSUInteger)page;
- (NSUInteger)documentProviderRelativePageWithPageRangeCompensated:(NSUInteger)page;

@end
