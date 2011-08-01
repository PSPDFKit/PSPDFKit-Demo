//
//  PSPDFCache.h
//  PSPDFKit
//
//  Created by Peter Steinberger on 7/20/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

@class PSPDFDocument;

enum {
    PSPDFCacheNothing,
    PSPDFCacheOnlyThumbnailsAndNearPages,
    PSPDFCacheOpportunistic
}typedef PSPDFCacheStrategy;

enum {
    PSPDFSizeNative,     // single page portrait device screen size
    PSPDFSizeThumbnail,  // defined as above in kPSPDFThumbnailSize
    PSPDFSizeTiny        // tiny is memory-only
}typedef PSPDFSize;

@protocol PSPDFCacheDelegate
- (void)didCachePageForDocument:(PSPDFDocument *)document page:(NSUInteger)page image:(UIImage *)cachedImage size:(PSPDFSize)size;
@end

// queue item for the cache
@interface PSPDFCacheQueuedDocument : NSObject {
    NSString *uid_;
    NSUInteger page_;
    PSPDFSize size_;
    BOOL caching_;
}
+ (PSPDFCacheQueuedDocument *)queuedDocumentWithDocument:(PSPDFDocument *)document page:(NSUInteger)page size:(PSPDFSize)size;
@property(retain) PSPDFDocument *document;
@property(assign) NSUInteger page;
@property(assign) PSPDFSize size;
@property(assign, getter=isCaching) BOOL caching;
@end

// renders magazine pages and caches them
@interface PSPDFCache : NSObject <NSCacheDelegate> {
    NSMutableDictionary *cachedFiles_;
    BOOL cacheFileDictLoaded_;
    
    NSMutableArray *queuedItems_;     // PSPDFCacheQueuedDocument
    NSMutableArray *queuedDocuments_; // PSPDFCacheQueuedDocument
    NSTimer *cacheTimer_;
    NSOperationQueue *cacheQueue_;
    NSMutableSet *delegates_;
    NSCache *thumbnailCache_;
    PSPDFCacheStrategy strategy_;
    NSUInteger numberOfMaximumCachedDocuments_;
    NSUInteger numberOfNearCachedPages_;
    BOOL largeImagesUseJPGFormat_;
    CGFloat JPGFormatCompression_;
    CGSize tinySize_;
    CGSize thumbnailSize_;
    NSString *cacheDirectory_;
    NSString *cachedCacheDirectory_;
}

// cache is a singleton
+ (PSPDFCache *)sharedPSPDFCache;

// check if document is cached
- (BOOL)isImageCachedForDocument:(PSPDFDocument *)document page:(NSUInteger)page size:(PSPDFSize)size;

// returns cached image of document. If not found, add to TOP of current caching queue
- (UIImage *)cachedImageForDocument:(PSPDFDocument *)document page:(NSUInteger)page size:(PSPDFSize)size;

// returns cached image of document. preload decompresses the image in the background.
- (UIImage *)cachedImageForDocument:(PSPDFDocument *)document page:(NSUInteger)page size:(PSPDFSize)size preload:(BOOL)preload;

// start document caching (update often to improve cache hits)
- (void)cacheDocument:(PSPDFDocument *)aDocument startAtPage:(NSUInteger)startPage size:(PSPDFSize)size;

// stop document caching
- (void)stopCachingDocument:(PSPDFDocument *)aDocument;

// clear cache
- (void)removeCacheForDocument:(PSPDFDocument *)aDocument deleteDocument:(BOOL)deleteMagazine;

// clear whole cache directory
- (BOOL)clearCache;

// delegate (uses MAZeroWeakRef to weak/nil out deallocated delegates)
- (void)addDelegate:(id<PSPDFCacheDelegate>)aDelegate;

// you *can* manually remove delegates, but it's not needed. return YES on success
- (BOOL)removeDelegate:(id<PSPDFCacheDelegate>)aDelegate;

// set up caching strategy
@property(assign) PSPDFCacheStrategy strategy;

// maximum number of cached documents
@property(assign) NSUInteger numberOfMaximumCachedDocuments;

// only relevant in strategy PSPDFCacheOnlyThumbnailsAndNearPages
@property(assign) NSUInteger numberOfNearCachedPages;


// PNG needs ~200% more space, but is both faster in creation, loading and looks nicer. Defaults to NO.
@property(assign) BOOL largeImagesUseJPGFormat;

// compression strength used. Defaults to 0.8
@property(assign) CGFloat JPGFormatCompression;

// defaults to CGSizeMake(200, 400);
@property(assign) CGSize thumbnailSize;

// defaults to CGSizeMake(50, 100);
@property(assign) CGSize tinySize;

// cache files are saved in a subdirectory of NSCachesDirectory. Defaults to "PSPDFKit".
@property(nonatomic, copy) NSString *cacheDirectory;

@end


// additional thumbnail cache control helper
@interface PSPDFCache (PSPDFKitThumbnailCache)

// save image in an NSCache object for specified identifier.
- (void)cacheImage:(UIImage *)image document:(PSPDFDocument *)document page:(NSUInteger)page size:(PSPDFSize)size;

// load image for a certain document page
- (UIImage *)imageForDocument:(PSPDFDocument *)document page:(NSUInteger)page size:(PSPDFSize)size;

// clear thumbnail memory cache
- (void)clearThumbnailMemoryCache;

@end
