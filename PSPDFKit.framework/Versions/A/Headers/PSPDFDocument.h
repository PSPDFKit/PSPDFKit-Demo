//
//  PSPDFDocument.h
//  PSPDFKit
//
//  Created by Peter Steinberger on 7/20/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "PSPDFCache.h"
#import "PSPDFMAZeroingWeakRef.h"

@class PSPDFDocumentSearcher, PSPDFOutlineParser, PSPDFPageInfo, PSPDFAnnotationParser;

/// Represents a single, logical, pdf document. (one or many pdf files)
/// Can be overriden to support custom collections.
@interface PSPDFDocument : NSObject {
    NSURL *basePath_;
    NSMutableArray *files_;
    NSString *uid_;
    NSString *title_;
    
    BOOL aspectRatioEqual_;
    BOOL searchEnabled_;
    BOOL outlineEnabled_;
    BOOL annotationsEnabled_;
    BOOL isDestroyed_;
    BOOL twoStepRenderingEnabled_;
    NSUInteger pageCount_;
    NSMutableDictionary *pageInfoCache_;
    NSMutableDictionary *pageCountCache_;
    NSMutableDictionary *fileUrlCache_;
    PSPDFViewController *displayingPdfController_; // weak
    
    PSPDFDocumentSearcher *documentSearcher_;
    PSPDFOutlineParser *outlineParser_;
    PSPDFAnnotationParser *annotationParser_;
}

/// initialize empty PSPDFDocument 
+ (PSPDFDocument *)PDFDocument;

/// initalize PSPDFDocument with distinct path and an array of files
+ (PSPDFDocument *)PDFDocumentWithBaseUrl:(NSURL *)baseUrl files:(NSArray *)files;

/// initializes PSPDFDocument with a single file
+ (PSPDFDocument *)PDFDocumentWithUrl:(NSURL *)url;

- (id)init;
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

/// cached rotation and aspect ratio data for specific page. Page starts at 0.
- (PSPDFPageInfo *)pageInfoForPage:(NSUInteger)page;

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

/// can be overridden to draw an overlay on the pdf - will be called from drawing threads!
- (void)drawOverlayRect:(CGRect)rect inContext:(CGContextRef)context forPage:(NSUInteger)page zoomScale:(CGFloat)zoomScale size:(PSPDFSize)size;

/// defaults to nil. can be overridden to provide custom text.
/// if this returns nil for a site, we'll try to extract text ourselves
- (NSString *)pageContentForPage:(NSUInteger)page;

/// override if you want custom *page* background colors. Only displayed while loading, and when no thumbnail is yet available. Defaults to white.
- (UIColor *)backgroundColorForPage:(NSUInteger)page;

/// callback to draw annotations. Use tilingView's convertPDFPointToViewPoint to recalculate coordinates
- (void)drawAnnotations:(NSArray *)annotations inContext:(CGContextRef)context pageInfo:(PSPDFPageInfo *)pageInfo pageRect:(CGRect)pageRect;

/// document title as shown in the controller
@property(nonatomic, copy) NSString *title;

/// For caching, provide a *UNIQUE* uid here. (Or clear cache after content changes for same uid. Appending content is no problem)
@property(nonatomic, copy) NSString *uid;

/// common base path for pdf files. Set to nil to use absolute paths for files.
@property(nonatomic, retain) NSURL *basePath;

/// array of NSString pdf files. 
@property(nonatomic, copy, readonly) NSArray *files;

/// usually, you have one single file url representing the pdf. This is a shortcut setter for basePath * files. Overrides all current settings if set.
@property(nonatomic, retain) NSURL *fileUrl;

/// if aspect ratio is equal on all pages, you can enable this for even better performance. Defaults to YES.
@property(nonatomic, assign, getter=isAspectRatioEqual) BOOL aspectRatioEqual;

/// text extraction is not possible for all pdfs. disable search if not working. Defaults to YES.
@property(nonatomic, assign, getter=isSearchEnabled) BOOL searchEnabled;

/// outline/table of contents extraction. disable if no outline available. Defaults to YES.
@property(nonatomic, assign, getter=isOutlineEnabled) BOOL outlineEnabled;

/// annotation link extraction. Defaults to YES.
@property(nonatomic, assign, getter=isAnnotationsEnabled) BOOL annotationsEnabled;

/// enables two-step rendering. First use cache image, then re-render original pdf. Slightly improves text quality in landscape mode,
/// or when displayed embedded. Two-Step rendering is slower. Defaults to NO.
@property(nonatomic, assign, getter=isTwoStepRenderingEnabled) BOOL twoStepRenderingEnabled;

/// if document is displayed, returns currently active pdfController. Don't set this yourself. Optimizes caching.
@property(nonatomic, assign) PSPDFViewController *displayingPdfController;


/// Text extraction class for current document. Readonly.
@property(nonatomic, retain, readonly) PSPDFDocumentSearcher *documentSearcher;

/// Outline extraction class for current document. Readonly.
@property(nonatomic, retain, readonly) PSPDFOutlineParser *outlineParser;

/// Link annotation parser class for current document. Readonly.
@property(nonatomic, retain, readonly) PSPDFAnnotationParser *annotationParser;

@end
