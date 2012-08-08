//
//  PSPDFCryptoDataProvider.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import <CoreGraphics/CoreGraphics.h>

/// BROKEN

@class PSPDFCryptoDataProvider;

typedef size_t (^PSPDFCryptoAccessBlock)(PSPDFCryptoDataProvider *dataProviderWrapper, void *buffer, off_t position, size_t count);

@interface PSPDFCryptoDataProvider : NSObject

/// Designated initializer. The block is needed to decrypt your data on the fly.
- (id)initWithDecryptionBlock:(PSPDFCryptoAccessBlock)block totalLength:(off_t)totalLength;

// Created on first access. PSPDFCryptoDataProvider will be retained as long as you retain this.
- (CGDataProviderRef)dataProviderRef;

//+ (CGDataProviderRef)newDataProviderWithBlock:(PSPDFCryptoAccessBlock)block CF_RETURNS_NOT_RETAINED;

@end
