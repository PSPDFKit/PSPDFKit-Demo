//
//  PSPDFCache.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFMemoryCache.h"
#import "PSPDFDiskCache.h"
#import "PSPDFRenderQueue.h"

@class PSPDFDocument, PSPDFRenderReceipt;

// Can be used to use a custom subclass of the PSPDFCache. Defaults to nil, which will use PSPDFCache.class.
// Set very early (in your AppDelegate) before you access PSPDFKit. Will be used to create the singleton.
extern Class PSPDFCacheClass;

// Enable this to see a detailed log output. (slow)
extern BOOL PSPDFCacheDebug;
#define PSPDFCacheLog(...) do { if (PSPDFCacheDebug) PSPDFLog(__VA_ARGS__); }while(0)

/// Cache delegate. Add yourself to the delegate list via addDelegate and get notified of new cache events.
@protocol PSPDFCacheDelegate <NSObject>

@optional

/// Requested image has been rendered or loaded from disk.
/// `size` is the requested image size, not the final image size. (due to document aspect ratio)
- (void)didCacheImage:(UIImage *)image document:(PSPDFDocument *)document page:(NSUInteger)page size:(CGSize)size;

@end

typedef NS_ENUM(NSUInteger, PSPDFCacheStatus) {
    PSPDFCacheStatusNotCached,
    PSPDFCacheStatusInMemory,
    PSPDFCacheStatusOnDisk
};

typedef NS_ENUM(NSInteger, PSPDFDiskCacheStrategy) {
    PSPDFDiskCacheStrategyNothing,    // No files are saved. (slowest)
    PSPDFDiskCacheStrategyThumbnails, // Only thumbnails are cached to disk.
    PSPDFDiskCacheStrategyNearPages,  // Only a few files are saved and all thumbnails.
    PSPDFDiskCacheStrategyEverything  // The whole PDF document is converted to images and saved. (fastest)
};

// `PSPDFCacheOptions` is a hybrid of an enumeration and a bit field.
typedef NS_OPTIONS(NSUInteger, PSPDFCacheOptions) {
    PSPDFCacheOptionMemoryStoreIfVisible      = 0,       // Default. Store into the memory cache if document is visible.
    PSPDFCacheOptionMemoryStoreAlways         = 1,       // Always store into the memory cache.
    PSPDFCacheOptionMemoryStoreNever          = 2,       // Never store into memory cache (unless it's already there)

    PSPDFCacheOptionDiskLoadAsyncAndPreload   = 0 << 3,  // Default. Queue disk load and preload.
    PSPDFCacheOptionDiskLoadAsync             = 1 << 3,  // Queue disk load, don't decompress JPG.
    PSPDFCacheOptionDiskLoadSyncAndPreload    = 2 << 3,  // Load image on current thread + decompress.
    PSPDFCacheOptionDiskLoadSync              = 3 << 3,  // Load image on current thread.
    PSPDFCacheOptionDiskLoadSkip              = 4 << 3,  // Don't access the disk cache.

    PSPDFCacheOptionRenderQueue               = 0 << 6,  // Default. Queue up request.
    PSPDFCacheOptionRenderQueueBackground     = 1 << 6,  // Queue, but with a very low priority.
    PSPDFCacheOptionRenderSync                = 2 << 6,  // If needed, render on current thread.
    PSPDFCacheOptionRenderSkip                = 3 << 6,  // Don't render, don't queue.

    PSPDFCacheOptionActualityCheckAndRequest  = 0 << 9,  // Default. Return image, potentially queue for re-render.
    PSPDFCacheOptionActualityIgnore           = 1 << 9,  // Ignore cache actuality, simply return an image.

    PSPDFCacheOptionSizeRequireAboutExact     = 0 << 12,  // Default. Requires the exact size, allows 2 pixel tolerance/rounding errors.
    PSPDFCacheOptionSizeRequireExact          = 1 << 12,  // Requires the exact size.
    PSPDFCacheOptionSizeAllowLarger           = 2 << 12,  // Allow downscaling of larger sizes.
    PSPDFCacheOptionSizeAllowLargerScaleSync  = 3 << 12,  // Resizes the image if size is substantially different, sync.
    PSPDFCacheOptionSizeAllowLargerScaleAsync = 4 << 12,  // Resizes the image if size is substantially different, async.
    PSPDFCacheOptionSizeGetLargestAvailable   = 5 << 12,  // Returns the largest available image.
    PSPDFCacheOptionSizeAllowSmaller          = 6 << 12,  // Returns an image equal to or smaller to given size.
};

/// This singleton manages both memory and disk cache, and adds new render requests to PSPDFRenderQueue.
/// Most settings are device dependent.
@interface PSPDFCache : NSObject <PSPDFRenderDelegate>

/// The cache object is a singleton.
+ (instancetype)sharedCache;

/// @name Access cache

/// Get the cache status of a rendered image.
/// `options` will ignore all entities except PSPDFCacheOptionSize*.
- (PSPDFCacheStatus)cacheStatusForImageFromDocument:(PSPDFDocument *)document page:(NSUInteger)page size:(CGSize)size options:(PSPDFCacheOptions)options;

/// Get the image for a certain document page.
/// Will first check the memory cache, then the disk cache and lastly queues a request to render.
/// Returns the image instantly if the memory cache was filled, else will queue and call the delegate.
/// If `requireExactSize` is set, images will either be downscaled or dynamically rendered. (There's no point in upscaling)
/// @note The cache will always return an aspect ratio corrected size of the image, so resulting size might be different.
- (UIImage *)imageFromDocument:(PSPDFDocument *)document page:(NSUInteger)page size:(CGSize)size options:(PSPDFCacheOptions)options;

/// @name Store into cache

/// Caches the image in memory and disk for later re-use.
/// PSPDFCache will decide at runtime if the image is worth saving into memory or just disk. (And disk will only be hit if the image is different)
- (void)saveImage:(UIImage *)image document:(PSPDFDocument *)document page:(NSUInteger)page receipt:(NSString *)renderReceipt;

/// @name Document pre-processing

/// Starts caching the document. setting `diskCacheStrategy` to PSPDFDiskCacheStrategyEverything will pre-cache the whole document, and PSPDFDiskCacheStrategyNearPages will render a few pages around `page`.
- (void)cacheDocument:(PSPDFDocument *)document startAtPage:(NSUInteger)page sizes:(NSArray *)sizes diskCacheStrategy:(PSPDFDiskCacheStrategy)diskCacheStrategy;

/// Stops all cache requests (render requests, queued disk writes) for the document.
- (void)stopCachingDocument:(PSPDFDocument *)document;

/// @name Cache invalidation

/// Cancels any open image request (disk load/render).
- (void)cancelRequestForImageFromDocument:(PSPDFDocument *)document page:(NSUInteger)page size:(CGSize)size;

/// Allows to invalidate a single page in the document.
/// This usually is called after an annotation changes (and thus the image needs to be re-rendered)
- (void)invalidateImageFromDocument:(PSPDFDocument *)document page:(NSUInteger)page;

/// Removes the whole cache (memory/disk) for `document`. Will cancel any open writes as well.
/// Enable `deleteDocument` to remove the document and the associated metadata.
- (BOOL)removeCacheForDocument:(PSPDFDocument *)document deleteDocument:(BOOL)deleteDocument error:(NSError **)error;

/// Clears the disk and memory cache.
- (void)clearCache;

/// @name Access internal caches

/// Access the memory cache. Allows deeper customization of the amount of memory used.
@property (nonatomic, strong, readonly) PSPDFMemoryCache *memoryCache;

/// Access the disk cache. Allows deeper customization of the amount of disk space used.
@property (nonatomic, strong, readonly) PSPDFDiskCache *diskCache;

/// @name Settings

/// Cache files are saved in a subdirectory of NSCachesDirectory. Defaults to "PSPDFKit/Pages".
/// @note The cache directory is not backed up by iCloud and will be purged when memory is low.
/// @warning Set this early during class initialization. Will clear the current cache before changing.
@property (nonatomic, copy) NSString *cacheDirectory;

/// Defines the global disk cache strategy. Defaults to PSPDFDiskCacheStrategyEverything.
/// If PSPDFDocument also defines a strategy, that one is prioritized.
@property (nonatomic, assign) PSPDFDiskCacheStrategy diskCacheStrategy;

/// The size of the thumbnail images used in the grid view and those shown before the full-size versions are rendered.
/// Defaults to (170, 220) on iPad and (85, 110) on iPhone.
@property (nonatomic, assign) CGSize thumbnailSize;

/// The size of the images used in the scrobble bar.
/// Defaults to CGSizeMake(50, 65).
@property (nonatomic, assign) CGSize tinySize;

/// @name Starting/Stopping

/// Will pause queued cache requests on the render queue.
/// For `service` use the class object that requests the pause.
/// @return Returns YES if the cache has been paused.
- (BOOL)pauseCachingForService:(id)service;

/// Will resume queued cache requests on the render queue.
/// For `service` use the class object that requested the pause.
/// @return Returns YES if the cache has been resumed.
- (BOOL)resumeCachingForService:(id)service;

/// @name Delegate

/// Register a delegate to be notified of new cache load events.
- (void)addDelegate:(id<PSPDFCacheDelegate>)aDelegate;

/// Deregisters a delegate.
/// @return Returns YES on success.
- (BOOL)removeDelegate:(id<PSPDFCacheDelegate>)aDelegate;

/// @name Disk Cache Settings

/// JPG is almost always faster, and uses less memory (<50% of a PNG, usually). Defaults to YES.
/// If you have very text-like pages, you might want to set this to NO.
@property (nonatomic, assign) BOOL useJPGFormat;

/// Compression strength for JPG. (PNG is loss-less)
/// The higher the compression, the larger the files and the slower is decompression. Defaults to 0.9.
/// This will load the pdf and remove any jpg artifacts.
@property (nonatomic, assign) CGFloat JPGFormatCompression;

/// Will allow image resizing instead of re-rendering to generate thumbnails.
/// This is conditionally enabled for older devices. This is a trade-off between performance or quality.
/// @note You will need to clear the cache after changing this to see a difference.
@property (nonatomic, assign) BOOL allowImageResize;

/// @name Encryption/Decryption Handlers

/// Decrypt data from the path. PSPDFKit Annotate feature.
/// If set to nil, the default implementation will be used.
@property (atomic, copy) NSData *(^decryptFromPathBlock)(PSPDFDocument *document, NSString *path);

/// Encrypt mutable data. PSPDFKit Annotate feature.
/// If set to nil, the default implementation will be used.
@property (atomic, copy) void (^encryptDataBlock)(PSPDFDocument *document, NSMutableData *data);

@end
