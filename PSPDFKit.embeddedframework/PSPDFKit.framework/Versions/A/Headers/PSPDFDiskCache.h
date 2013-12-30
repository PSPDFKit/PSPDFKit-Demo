//
//  PSPDFDiskCache.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

@class PSPDFCacheInfo, PSPDFRenderReceipt;

// Cache selector (to fetch sizes)
typedef PSPDFCacheInfo *(^PSPDFCacheInfoSelector)(NSOrderedSet *);
typedef NSArray *(^PSPDFCacheInfoArraySelector)(NSOrderedSet *);

// Encryption/Decryption Helper.
typedef UIImage *(^PSPDFCacheDecryptionHelper)(NSString *path);
typedef NSData *(^PSPDFCacheEncryptionHelper)(UIImage *image);

/// The disk cache is designed to store and get images including metadata in a fast way.
/// No actual images will be held in memory (besides during the time they are scheduled for a disk write)
@interface PSPDFDiskCache : NSObject

/// Initializes the disk cache with the specified directory and the file ending (jpg, png)
- (id)initWithCacheDirectory:(NSString *)cacheDirectory fileFormat:(NSString *)fileFormat;

/// @name Accessing Data

/// Check if there's an matching entry in the cache.
- (PSPDFCacheInfo *)cacheInfoForImageWithUID:(NSString *)UID page:(NSUInteger)page size:(CGSize)size infoSelector:(PSPDFCacheInfoSelector)infoSelector;

/// Will load the image synchronously. The `decryptionHelper` is mandatory.
- (UIImage *)imageWithUID:(NSString *)UID page:(NSUInteger)page size:(CGSize)size infoSelector:(PSPDFCacheInfoSelector)infoSelector decryptionHelper:(PSPDFCacheDecryptionHelper)decryptionHelper cacheInfo:(PSPDFCacheInfo **)outCacheInfo;

/// Accessing data will take some time, calls `completionBlock` when done. The `decryptionHelper` is mandatory.
/// Returns `YES` if an image was found and a loading operation is scheduled.
- (PSPDFCacheInfo *)scheduleLoadImageWithUID:(NSString *)UID page:(NSUInteger)page size:(CGSize)size infoSelector:(PSPDFCacheInfoSelector)infoSelector decryptionHelper:(PSPDFCacheDecryptionHelper)decryptionHelper completionBlock:(void (^)(UIImage *cachedImage, PSPDFCacheInfo *cacheInfo))completionBlock;

/// @name Storing Data

/// Store images into the cache.
/// The `encryptionHelper` is mandatory.
- (void)storeImage:(UIImage *)image UID:(NSString *)UID page:(NSUInteger)page encryptionHelper:(PSPDFCacheEncryptionHelper)encryptionHelper receipt:(NSString *)renderReceipt;

/// @name Invalidating Cache Entries

/// Invalidate all images that match `UID`. Will also invalidate any open writes.
- (BOOL)invalidateAllImagesWithUID:(NSString *)UID;

/// Invalidate all images that match `UID` and `page` that match `infoSelector`. Will also invalidate any open writes.
- (BOOL)invalidateAllImagesWithUID:(NSString *)UID page:(NSUInteger)page infoArraySelector:(PSPDFCacheInfoArraySelector)infoSelector;

/// Invalidate cancel all write requests that match `UID` and `page` that match `infoSelector`.
/// Use NSNotFound as a wildcard for all pages.
- (void)cancelWriteRequestsWithUID:(NSString *)UID page:(NSUInteger)page infoArraySelector:(PSPDFCacheInfoArraySelector)infoSelector;

/// Removes all entries in the disk cache.
- (void)clearCache;

/// @name Settings

/// Maximum number of disk space we're allowed to take up. In Byte. Defaults to 500MB (500*1024*1024)
/// @note Set this to 0 to disable the disk cache.
@property (nonatomic, assign) unsigned long long allowedDiskSpace;

/// Disk space we're currently using. (in byte)
@property (nonatomic, assign, readonly) unsigned long long usedDiskSpace;

/// Returns the available free disk space. (Calculated on every access)
@property (nonatomic, assign, readonly) unsigned long long freeDiskSpace;

/// The file format (png, jpg)
@property (nonatomic, copy) NSString *fileFormat;

@end

@interface PSPDFDiskCache (Private)

// Returns YES when the writer queue has the maximum amount of operations already queued up and waiting.
- (BOOL)writeQueueIsFull;

@end
