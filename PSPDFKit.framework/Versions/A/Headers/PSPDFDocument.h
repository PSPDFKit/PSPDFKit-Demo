//
//  PSPDFDocument.h
//  PSPDFKit
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSPDFKitGlobal.h"
#import "PSPDFCache.h"

@class PSPDFDocumentSearcher, PSPDFOutlineParser, PSPDFPageInfo, PSPDFAnnotationParser, PSPDFViewController;

/// Represents a single, logical, pdf document. (one or many pdf files)
/// Can be overriden to support custom collections.
@interface PSPDFDocument : NSObject {
    NSUInteger pageCount_;
}

/// initialize empty PSPDFDocument 
+ (PSPDFDocument *)PDFDocument;

/// initialize PSPDFDocument with data
+ (PSPDFDocument *)PDFDocumentWithData:(NSData *)data;

/// initialize PSPDFDocument with distinct path and an array of files.
/// Note: it's currently not possible to add the file multiple times, this will fail to display correctly.
+ (PSPDFDocument *)PDFDocumentWithBaseUrl:(NSURL *)baseUrl files:(NSArray *)files;

/// initializes PSPDFDocument with a single file
+ (PSPDFDocument *)PDFDocumentWithUrl:(NSURL *)url;

- (id)init;
- (id)initWithData:(NSData *)data;
- (id)initWithUrl:(NSURL *)url;
- (id)initWithBaseUrl:(NSURL *)basePath files:(NSArray *)files;

/// appends a file to the current document. No PDF gets modified, just displayed together. Can be a name or partial path (full path if basePath is nil)
- (BOOL)appendFile:(NSString *)file;

/// returns path for a single page (in case pages are split up). Page starts at 0.
- (NSURL *)pathForPage:(NSUInteger)page;

/// return pdf page count
- (NSUInteger)pageCount;

/// return pdf page number. this may be different if a collection of pdfs is used a one big document. Page starts at 0.
- (NSUInteger)pageNumberForPage:(NSUInteger)page;

/// Returns YES of pageInfo for page is available
- (BOOL)hasPageInfoForPage:(NSUInteger)page;

/// cached rotation and aspect ratio data for specific page. Page starts at 0.
- (PSPDFPageInfo *)pageInfoForPage:(NSUInteger)page;

/// cached rotation and aspect ratio data for specific page. Page starts at 0.
/// You can override this if you need to manually change the rotation value of a page.
- (PSPDFPageInfo *)pageInfoForPage:(NSUInteger)page pageRef:(CGPDFPageRef)pageRef;

/// Makes a search beginning from page 0 for the nearest pageInfo. Does not calculate/block the thread.
- (PSPDFPageInfo *)nearestPageInfoForPage:(NSUInteger)page;

/// aspect ratio is automatically cached and analyzed per page. Page starts at 0.
/// maybe needs a pdf lock if not already cached.
- (CGRect)rectBoxForPage:(NSUInteger)page;

/// rotation for specified page. cached. Page starts at 0.
- (int)rotationForPage:(NSUInteger)page;

/// if you change internal properties (like file count), cache needs to be cleared. Forced clears *everything* and even if doc is currently displayed.
- (void)clearCacheForced:(BOOL)forced;

/// shortcut to clearCacheForced:NO
- (void)clearCache;

/// creates internal cache for faster display. override to provide custom caching. usually called in a thread.
- (void)fillCache;

/// return plain thumbnail path, if thumbnail already exists. override if you pre-provide thumbnails. Returns nil on default.
- (NSURL *)thumbnailPathForPage:(NSUInteger)page;

/// return true if you want drawOverlayRect to be called.
- (BOOL)shouldDrawOverlayRectForSize:(PSPDFSize)size;

/// can be overridden to draw an overlay on the pdf - will be called from drawing threads.
- (void)drawOverlayRect:(CGRect)rect inContext:(CGContextRef)context forPage:(NSUInteger)page zoomScale:(CGFloat)zoomScale size:(PSPDFSize)size;

/// defaults to nil. can be overridden to provide custom text.
/// if this returns nil for a site, we'll try to extract text ourselves.
/// Note: If you return text here, text highlighting cannot be used for this page.
- (NSString *)pageContentForPage:(NSUInteger)page;

/// override if you want custom *page* background colors. Only displayed while loading, and when no thumbnail is yet available. Defaults to white.
- (UIColor *)backgroundColorForPage:(NSUInteger)page;

/// Passes a password to unlock encrypted documents.
/// If the password is correct, this method returns YES. Once unlocked, you cannot use this function to relock the document.
/// If you attempt to unlock an already unlocked document, one of the following occurs:
/// If the document is unlocked with full owner permissions, unlockWithPassword: does nothing and returns YES. The password string is ignored.
/// If the document is unlocked with only user permissions, unlockWithPassword attempts to obtain full owner permissions with the password
/// string. If the string fails, the document maintains its user permissions. In either case, this method returns YES.
- (BOOL)unlockWithPassword:(NSString*)password;

/// Do the PDF digital right allow for printing?
@property (nonatomic, readonly) BOOL allowsPrinting;

/// Was the PDF file encryted at file creation time?
@property (nonatomic, readonly) BOOL isEncrypted;

/// Has the PDF file been unlocked? (is it still locked?).
@property (nonatomic, readonly) BOOL isLocked;

/// document title as shown in the controller
@property(nonatomic, copy) NSString *title;

/// For caching, provide a *UNIQUE* uid here. (Or clear cache after content changes for same uid. Appending content is no problem)
@property(nonatomic, copy) NSString *uid;

/// common base path for pdf files. Set to nil to use absolute paths for files.
@property(nonatomic, strong) NSURL *basePath;

/// array of NSString pdf files. If basePath is set, this will be combined with the file name.
/// If basePath is not set, add the full path (as NSString) to the files.
/// Note: it's currently not possible to add the file multiple times, this will fail to display correctly.`
@property(nonatomic, copy) NSArray *files;

/// usually, you have one single file url representing the pdf. This is a shortcut setter for basePath* files. Overrides all current settings if set.
/// nil if the document was initialized with initWithData:
@property(nonatomic, strong) NSURL *fileUrl;

/// set a base password to be used for all files in this document (if the document is PDF encrypted).
@property(nonatomic, copy) NSString* password;

/// PDF data when initialized with initWithData: otherwise nil
@property(nonatomic, copy, readonly) NSData *data;

/// if aspect ratio is equal on all pages, you can enable this for even better performance. Defaults to NO.
@property(nonatomic, assign, getter=isAspectRatioEqual) BOOL aspectRatioEqual;

/// text extraction is not possible for all pdfs. disable search if not working. Defaults to YES.
@property(nonatomic, assign, getter=isSearchEnabled) BOOL searchEnabled;

/// outline/table of contents extraction. disable if no outline available. Defaults to YES.
@property(nonatomic, assign, getter=isOutlineEnabled) BOOL outlineEnabled;

/// annotation link extraction. Defaults to YES.
@property(nonatomic, assign, getter=isAnnotationsEnabled) BOOL annotationsEnabled;

/// enables two-step rendering. First use cache image, then re-render original pdf. Slightly improves text quality in landscape mode,
/// or when displayed embedded. Two-Step rendering is slower. Defaults to NO.
/// This might be a good idea to turn on when using JPG for caching.
@property(nonatomic, assign, getter=isTwoStepRenderingEnabled) BOOL twoStepRenderingEnabled;

/// if document is displayed, returns currently active pdfController. Don't set this yourself. Optimizes caching. 
// note: doesn't use weak as this could lead to background deallocation of the controller.
@property(nonatomic, unsafe_unretained) PSPDFViewController *displayingPdfController;

/// Text extraction class for current document.
@property(nonatomic, strong) PSPDFDocumentSearcher *documentSearcher;

/// Outline extraction class for current document.
@property(nonatomic, strong) PSPDFOutlineParser *outlineParser;

/// Link annotation parser class for current document.
/// Can be overridden to use a subclassed annotation parser.
@property(nonatomic, strong) PSPDFAnnotationParser *annotationParser;

@end
