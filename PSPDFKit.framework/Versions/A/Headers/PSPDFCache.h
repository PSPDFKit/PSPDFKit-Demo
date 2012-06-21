//
//  PSPDFCache.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PSPDFDocument;

typedef enum {
    PSPDFCacheNothing,                    // no files are saved. (slowest)
    PSPDFCacheOnlyThumbnailsAndNearPages, // only a few files are saved.
    PSPDFCacheOpportunistic               // the whole pdf document is converted to images and saved. (fastest)
}PSPDFCacheStrategy;

typedef enum {
    PSPDFSizeNative,     /// single page portrait device screen size
    PSPDFSizeThumbnail,  /// defined as above in kPSPDFThumbnailSize
    PSPDFSizeTiny        /// tiny is memory-only
}PSPDFSize;

/// Cache delegate. Add yourself to the delegate list via addDelegate and get notified of new cache events.
@protocol PSPDFCacheDelegate <NSObject>

/// Page has been successfully processed and cached as UIImage.
- (void)didCachePageForDocument:(PSPDFDocument *)document page:(NSUInteger)page image:(UIImage *)cachedImage size:(PSPDFSize)size;

/// TODO actually I'd like to make the first optional as well, but that would mean more respondsToSelector-ish checks
@optional

/// All pages of the document that needed caching have been processed.
- (void)didFinishCachingDocument:(PSPDFDocument *)document;

@end

/// PSPDFCache is an intelligent cache that pre-renders pdf pages based on a queue.
/// Various image sizes and formats are supported. The system is designed to take as much memory
/// as there's available, and free most of it on a memory warning event.
/// You can manually call clearCache to remove all temporary files and clear the memory caches.
@interface PSPDFCache : NSObject <NSCacheDelegate> 

/// cache is a singleton.
+ (PSPDFCache *)sharedPSPDFCache;

/// Check if all pages of a document are cached.
- (BOOL)isDocumentCached:(PSPDFDocument *)document size:(PSPDFSize)size;

/// Check if an individual page of a document is cached.
- (BOOL)isImageCachedForDocument:(PSPDFDocument *)document page:(NSUInteger)page size:(PSPDFSize)size;

/// returns cached image of document. If not found, add to TOP of current caching queue.
- (UIImage *)cachedImageForDocument:(PSPDFDocument *)document page:(NSUInteger)page size:(PSPDFSize)size;

/// returns cached image of document. preload decompresses the image in the background.
/// Note: if useJPGTurbo is enabled, preload is always YES.
- (UIImage *)cachedImageForDocument:(PSPDFDocument *)document page:(NSUInteger)page size:(PSPDFSize)size preload:(BOOL)preload;

/// renders image of a page for spezified size. Used here and in PSPDFTilingView.
- (UIImage *)renderImageForDocument:(PSPDFDocument *)document page:(NSUInteger)page size:(PSPDFSize)size pdfPage:(CGPDFPageRef)pdfPage;

/// save native rendered image, then call delegate. Used from PSPDFTilingView.
- (void)saveNativeRenderedImage:(UIImage *)image document:(PSPDFDocument *)document page:(NSUInteger)page;

/// start document caching (update often to improve cache hits). Page starts at 0.
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

/// stop document caching.
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

/// clear cache for a specific document, optionally also deletes referenced document files.
/// This usually performs asyncronously. If you need this call to be blocking until it's done, set wait to YES.
- (void)removeCacheForDocument:(PSPDFDocument *)aDocument deleteDocument:(BOOL)deleteDocument waitUntilDone:(BOOL)wait;

/// clear whole cache directory. May lock until related async tasks are finished. Can be called from any thread.
- (BOOL)clearCache;

/// register a delegate. don't forget to manually remove it afterwards!
- (void)addDelegate:(id<PSPDFCacheDelegate>)aDelegate;

/// deregisters a delegate. return YES on success.
- (BOOL)removeDelegate:(id<PSPDFCacheDelegate>)aDelegate;

/// Set up the caching strategy.
/// Defaults to PSPDFCacheOpportunistic.
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

/// Uses libjpeg-turbo for caching. Faster than what CoreFoundation provides. Defaults to YES, as of 1.9.10
@property(assign) BOOL useJPGTurbo;

/// The interpolation level applied to thumbnail and tiny images.
/// Defaults to kCGInterpolationHigh.
@property(assign) CGInterpolationQuality downscaleInterpolationQuality;

/// The size of the thumbnail images used in the grid view and those shown before the full-size versions are rendered.
/// Defaults to CGSizeMake(200, 400).
@property(assign) CGSize thumbnailSize;

/// The size of the images used in the scrobble bar.
/// Defaults to CGSizeMake(50, 100).
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
@property(strong) PSPDFDocument *document;
@property(assign) NSUInteger page; // the page index from where caching should start
@property(assign) PSPDFSize size;
@property(strong) NSMutableSet *pagesCached; // used to remember what pages already were attempted to be cached.
@property(assign, getter=isCaching) BOOL caching;

@end
