//
//  PSPDFMemoryCache.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import "PSPDFDiskCache.h"

@class PSPDFRenderReceipt;

/// The memory cache is designed to take up as much memory as it can possibly get (the more, the faster!)
/// On a memory warning, it will call clearCache all release all stored images.
@interface PSPDFMemoryCache : NSObject

/// @name Accessing Data

/// Access an image from the memory cache.
- (PSPDFCacheInfo *)cacheInfoForImageWithUID:(NSString *)UID andPage:(NSUInteger)page withSize:(CGSize)size infoSelector:(PSPDFCacheInfoSelector)infoSelector;

/// @name Storing Data

/// Store images into the cache. Storing is async.
- (void)storeImage:(UIImage *)image withUID:(NSString *)UID andPage:(NSUInteger)page withReceipt:(NSString *)renderReceipt;

/// @name Invalidating Cache Entries

/// Invalidate all images that match `UID`.
- (BOOL)invalidateAllImagesWithUID:(NSString *)UID;

/// Invalidate all images that match `UID` and `page` and match `infoSelector`.
- (BOOL)invalidateAllImagesWithUID:(NSString *)UID andPage:(NSUInteger)page infoArraySelector:(PSPDFCacheInfoArraySelector)infoSelector;

/// Clears all entries in the memory cache.
- (void)clearCache;

/// @name Statistics

/// Number of objects that are currently in the cache.
- (NSUInteger)count;

/// Tracks the current amount of pixels cached.
/// One pixel roughly needs 4 byte (+structure overhead).
@property (nonatomic, assign, readonly) NSUInteger numberOfPixels;

/// Maximum number of pixels allowed to be cached. Device dependant.
@property (nonatomic, assign) NSUInteger maxNumberOfPixels;

/// Maximum number of pixels allowed to be cached after a memory warning. Device dependant.
@property (nonatomic, assign) NSUInteger maxNumberOfPixelsUnderStress;

@end
