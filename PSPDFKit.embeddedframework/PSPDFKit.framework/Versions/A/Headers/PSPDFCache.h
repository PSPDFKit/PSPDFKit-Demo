//
//  PSPDFCache.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFDocument;
extern NSString *kPSPDFCachedRenderRequest; // set in options when we render a cached page

typedef NS_ENUM(NSInteger, PSPDFCacheStrategy) {
    PSPDFCacheNothing,                    // no files are saved. (slowest)
    PSPDFCacheThumbnails,                 // only thumbnails.
    PSPDFCacheThumbnailsAndNearPages,     // only a few files are saved.
    PSPDFCacheOpportunistic               // the whole PDF document is converted to images and saved. (fastest)
};

typedef NS_ENUM(NSInteger, PSPDFSize) {
    PSPDFSizeNative,     /// single page portrait device screen size
    PSPDFSizeThumbnail,  /// defined as above in kPSPDFThumbnailSize
    PSPDFSizeTiny        /// tiny is memory-only
};

/// Cache delegate. Add yourself to the delegate list via addDelegate and get notified of new cache events.
@protocol PSPDFCacheDelegate <NSObject>

/// Page has been successfully processed and cached as UIImage.
- (void)didCachePageForDocument:(PSPDFDocument *)document page:(NSUInteger)page image:(UIImage *)cachedImage size:(PSPDFSize)size;

@optional

/// All pages of the document that needed caching have been processed.
- (void)didFinishCachingDocument:(PSPDFDocument *)document;

@end

/// PSPDFCache is an intelligent cache that pre-renders pdf pages based on a queue.
/// Various image sizes and formats are supported. The system is designed to take as much memory
/// as there's available, and free most of it on a memory warning event.
/// You can manually call clearCache to remove all temporary files and clear the memory caches.
@interface PSPDFCache : NSObject <NSCacheDelegate> 

/// The cache is a singleton.
+ (PSPDFCache *)sharedCache;

/// Check if all pages of a document are cached.
- (BOOL)isDocumentCached:(PSPDFDocument *)document size:(PSPDFSize)size;

/// Check if an individouble page of a document is cached.
- (BOOL)isImageCachedForDocument:(PSPDFDocument *)document page:(NSUInteger)page size:(PSPDFSize)size;

/// Returns cached image of document. If not found, add to TOP of current caching queue.
- (UIImage *)cachedImageForDocument:(PSPDFDocument *)document page:(NSUInteger)page size:(PSPDFSize)size;

/// Returns cached image of document. preload decompresses the image in the background.
- (UIImage *)cachedImageForDocument:(PSPDFDocument *)document page:(NSUInteger)page size:(PSPDFSize)size preload:(BOOL)preload;

/// Renders image of a page for specified size.
- (UIImage *)renderImageForDocument:(PSPDFDocument *)document page:(NSUInteger)page size:(PSPDFSize)size pdfPage:(CGPDFPageRef)pdfPage;

// TODO was used in tiling view
/// save native rendered image, then call delegate.
//- (void)saveNativeRenderedImage:(UIImage *)image document:(PSPDFDocument *)document page:(NSUInteger)page;

/// Start document caching (update often to improve cache hits). Page starts at 0.
- (void)cacheDocument:(PSPDFDocument *)aDocument startAtPage:(NSUInteger)startPage size:(PSPDFSize)size;

/// Creates caches for both thumbnails and tiny images. This, together with PSPDFDocument.loadThumbnailsOnMainThread,
/// will ensure that the user doesn’t see any white pages when showing the document to the user.
///
/// Preloading the cache for PSPDFSizeNative would not be efficient. These images tend to become large in data size,
/// which would in turn trigger the OS’ cache cleaning sooner.
///
/// Note that PSPDFViewController will cache images in PSPDFSizeNative.
///
/// Returns wether or not any preloading has to be done.
- (BOOL)cacheThumbnailsForDocument:(PSPDFDocument *)aDocument;

/// Stop document caching.
- (void)stopCachingDocument:(PSPDFDocument *)aDocument;

/// Request that caching takes a break. Helpful when you want to perform other high-cpu tasks.
/// This will finish the current rendering/caching process and then stop the queue.
/// Set a service Class/Token/Id that is referred with the break. Needed so that multiple services can request a pause.
/// Throws an exception if the service is nil. Already registered services will be ignored.
/// Returns YES if the cache was paused, NO if it was already paused.
/// Thread safe.
- (BOOL)pauseCachingForService:(id)service;

/// Resumes caching, removes the specific service from the blocker list.
/// Throws an exception if the service is invalid/not registered.
/// Returns YES if the service continues running.
/// Thread safe.
- (BOOL)resumeCachingForService:(id)service;

/// Clear cache for a specific document, optionally also deletes referenced document files.
/// This usually performs asyncronously. If you need this call to be blocking until it's done, set wait to YES.
- (void)removeCacheForDocument:(PSPDFDocument *)aDocument deleteDocument:(BOOL)deleteDocument waitUntilDone:(BOOL)wait;

/// Clear whole (disk) cache directory. May lock until related async tasks are finished. Can be called from any thread.
- (BOOL)clearCache;

/// Register a delegate. don't forget to manually remove it afterwards!
- (void)addDelegate:(id<PSPDFCacheDelegate>)aDelegate;

/// Deregisters a delegate. return YES on success.
- (BOOL)removeDelegate:(id<PSPDFCacheDelegate>)aDelegate;

/// Set up the caching strategy.
/// Defaults to PSPDFCacheOpportunistic.
@property(assign) PSPDFCacheStrategy strategy;

/// Maximum number of cached documents. Default value depends on device. Only odd numbers are allowed. (1,3,5,...)
/// If you experience memory issues, set this to zero in your AppDelegate.
@property(nonatomic, assign) NSUInteger numberOfMaximumCachedDocuments;

/// Only relevant in strategy PSPDFCacheThumbnailsAndNearPages.
@property(assign) NSUInteger numberOfNearCachedPages;

/// JPG is almost always faster, and uses less memory (<50% of a PNG, usually). Defaults to YES.
/// If you have very text-like pages, you might want to set this to NO.
@property(assign) BOOL useJPGFormat;

/// Compression strength for JPG. (PNG is lossless)
/// The higher the compression, the larger the files and the slower is decompression. Defaults to 0.9.
/// This will load the pdf and remove any jpg artifacts.
@property(assign) CGFloat JPGFormatCompression;

/// The interpolation level applied to thumbnail and tiny images.
/// Defaults to kCGInterpolationHigh.
@property(assign) CGInterpolationQuality downscaleInterpolationQuality;

/// The size of the thumbnail images used in the grid view and those shown before the full-size versions are rendered.
/// Defaults to CGSizeMake(200, 400).
@property(assign) CGSize thumbnailSize;

/// The size of the images used in the scrobble bar.
/// Defaults to CGSizeMake(50, 100).
@property(assign) CGSize tinySize;

/// Cache files are saved in a subdirectory of NSCachesDirectory. Defaults to "PSPDFKit".
@property(nonatomic, copy) NSString *cacheDirectory;

@end


/// additional thumbnail cache control helper.
@interface PSPDFCache (PSPDFKitThumbnailCache)

/// Save image in an NSCache object for specified identifier. Page starts at 0.
- (void)cacheImage:(UIImage *)image document:(PSPDFDocument *)document page:(NSUInteger)page size:(PSPDFSize)size;

/// Load image for a certain document page. Page starts at 0.
- (UIImage *)imageForDocument:(PSPDFDocument *)document page:(NSUInteger)page size:(PSPDFSize)size;

/// Clear memory cache.
- (void)clearMemoryCache;

@end

@interface PSPDFCache (Deprecated)

+ (PSPDFCache *)sharedPSPDFCache __attribute__((deprecated("Deprecated. Use sharedCache instead.")));

@end

/// Used for debugging/status checking. See kPSPDFKitDebugMemory in PSPDFKitGlobal.h.
@interface PSPDFCache (PSPDFDebuggingSupport)
- (void)registerObject:(NSObject *)object;
- (void)deregisterObject:(NSObject *)object;
- (void)printStatus;
@end


// Internal queue item for the cache.
@interface PSPDFCacheQueuedDocument : NSObject 

+ (PSPDFCacheQueuedDocument *)queuedDocumentWithDocument:(PSPDFDocument *)document page:(NSUInteger)page size:(PSPDFSize)size;
@property(strong) PSPDFDocument *document;
@property(assign) NSUInteger page; // the page index from where caching should start
@property(assign) PSPDFSize size;
@property(strong) NSMutableSet *pagesCached; // used to remember what pages already were attempted to be cached.
@property(assign, getter=isCaching) BOOL caching;

@end
