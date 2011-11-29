//
//  PSPDFCache.h
//  PSPDFKit
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

@class PSPDFDocument;

enum {
    PSPDFCacheNothing,                    // no files are saved. (slowest)
    PSPDFCacheOnlyThumbnailsAndNearPages, // only a few files are saved.
    PSPDFCacheOpportunistic               // the whole pdf document is converted to images and saved. (fastest)
}typedef PSPDFCacheStrategy;

enum {
    PSPDFSizeNative,     /// single page portrait device screen size
    PSPDFSizeThumbnail,  /// defined as above in kPSPDFThumbnailSize
    PSPDFSizeTiny        /// tiny is memory-only
}typedef PSPDFSize;

/// Cache delegate. Add yourself to the delegate list via addDelegate and get notified of new cache events.
@protocol PSPDFCacheDelegate

/// page has been successfully processed and cached as UIImage.
- (void)didCachePageForDocument:(PSPDFDocument *)document page:(NSUInteger)page image:(UIImage *)cachedImage size:(PSPDFSize)size;

@end

/// PSPDFCache is an intelligent cache that pre-renders pdf pages based on a queue.
/// Various image sizes and formats are supported. The system is designed to take as much memory
/// as there's available, and free most of it on a memory warning event.
/// You can manually call clearCache to remove all temporary files and clear the memory caches.
@interface PSPDFCache : NSObject <NSCacheDelegate> 

/// cache is a singleton.
+ (PSPDFCache *)sharedPSPDFCache;

/// check if document is cached.
- (BOOL)isImageCachedForDocument:(PSPDFDocument *)document page:(NSUInteger)page size:(PSPDFSize)size;

/// returns cached image of document. If not found, add to TOP of current caching queue.
- (UIImage *)cachedImageForDocument:(PSPDFDocument *)document page:(NSUInteger)page size:(PSPDFSize)size;

/// returns cached image of document. preload decompresses the image in the background.
- (UIImage *)cachedImageForDocument:(PSPDFDocument *)document page:(NSUInteger)page size:(PSPDFSize)size preload:(BOOL)preload;

/// renders image of a page for spezified size. Used here and in PSPDFTilingView.
- (UIImage *)renderImageForDocument:(PSPDFDocument *)document page:(NSUInteger)page size:(PSPDFSize)size pdfPage:(CGPDFPageRef)pdfPage;

/// save native rendered image, then call delegate. Used from PSPDFTilingView.
- (void)saveNativeRenderedImage:(UIImage *)image document:(PSPDFDocument *)document page:(NSUInteger)page;

/// start document caching (update often to improve cache hits). Page starts at 0.
- (void)cacheDocument:(PSPDFDocument *)aDocument startAtPage:(NSUInteger)startPage size:(PSPDFSize)size;

/// stop document caching.
- (void)stopCachingDocument:(PSPDFDocument *)aDocument;

/// clear cache for a specific document, optionally also deletes referenced document files.
- (void)removeCacheForDocument:(PSPDFDocument *)aDocument deleteDocument:(BOOL)deleteMagazine;

/// clear whole cache directory. May lock until related async tasks are finished. Can be called from any thread.
- (BOOL)clearCache;

/// register a delegate. don't forget to manually remove it afterwards!
- (void)addDelegate:(id<PSPDFCacheDelegate>)aDelegate;

/// deregisters a delegate. return YES on success.
- (BOOL)removeDelegate:(id<PSPDFCacheDelegate>)aDelegate;

/// set up caching strategy.
@property(assign) PSPDFCacheStrategy strategy;

/// maximum number of cached documents. Default value depends on device. Only odd numbers are allowed. (1,3,5,...)
/// if you experience memory issues, set this to zero in your AppDelegate.
@property(nonatomic, assign) NSUInteger numberOfMaximumCachedDocuments;

/// only relevant in strategy PSPDFCacheOnlyThumbnailsAndNearPages.
@property(assign) NSUInteger numberOfNearCachedPages;

/// JPG is almost always faster, and uses less memory (<50% of a PNG, usually). Defaults to YES.
/// If you have very text-like pages, you might want to set this to NO.
@property(assign) BOOL useJPGFormat;

/// Compression strength for JPG. (PNG is lossless)
/// The higher the compression, the larger the files and the slower is decompression. Defaults to 0.9.
/// You can set the document to re-render with PSPDFDocument.twoStepRenderingEnabled = YES.
/// This will load the pdf and remove any jpg artifacts.
@property(assign) CGFloat JPGFormatCompression;

/// PNGs can be saved as a crushed variant, which changes the RGB channel and premultiplies alpha,
/// which results in a slight speed gain. Xcode by default crushes all your PNGs after copying then,
/// but it needs to be explicitely called on iOS.
/// This uses libpng, so if you expecience any problems, diasble it. Defaults to YES.
/// Only used if useJPGFormat is set to NO.
/// Note: the current implementation may slightly *increase* pdf file size for crushing.
@property(assign) BOOL crushPNGs;

/// defaults to CGSizeMake(200, 400).
@property(assign) CGSize thumbnailSize;

/// defaults to CGSizeMake(50, 100).
@property(assign) CGSize tinySize;

/// cache files are saved in a subdirectory of NSCachesDirectory. Defaults to "PSPDFKit".
@property(nonatomic, copy) NSString *cacheDirectory;

@end


/// additional thumbnail cache control helper.
@interface PSPDFCache (PSPDFKitThumbnailCache)

/// save image in an NSCache object for specified identifier. Page starts at 0.
- (void)cacheImage:(UIImage *)image document:(PSPDFDocument *)document page:(NSUInteger)page size:(PSPDFSize)size;

/// load image for a certain document page. Page starts at 0.
- (UIImage *)imageForDocument:(PSPDFDocument *)document page:(NSUInteger)page size:(PSPDFSize)size;

/// clear thumbnail memory cache.
- (void)clearThumbnailMemoryCache;

@end

/// used for debugging/status checking. See kPSPDFKitDebugMemory in PSPDFKitGlobal.h.
@interface PSPDFCache (PSPDFDebuggingSupport)
- (void)registerObject:(NSObject *)object;
- (void)deregisterObject:(NSObject *)object;
- (void)printStatus;
@end

// helper for deadlock-free dispatch_sync.
void dispatch_sync_reentrant(dispatch_queue_t queue, dispatch_block_t block);


// internal queue item for the cache.
@interface PSPDFCacheQueuedDocument : NSObject 

+ (PSPDFCacheQueuedDocument *)queuedDocumentWithDocument:(PSPDFDocument *)document page:(NSUInteger)page size:(PSPDFSize)size;
@property(retain) PSPDFDocument *document;
@property(assign) NSUInteger page;
@property(assign) PSPDFSize size;
@property(assign, getter=isCaching) BOOL caching;

@end
