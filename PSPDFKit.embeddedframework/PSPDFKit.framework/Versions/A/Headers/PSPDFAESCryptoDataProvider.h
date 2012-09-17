//
//  PSPDFAESCryptoDataProvider.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

/**
    This class allows a tranparent decryption of AES256 encrypted files.
    The IV vector for the file is written in the first 16 bytes of the file to read.
    Use the provided encryption tool to prepare your documents.
 
    Ensure your passphrase/salt are also protected within the binary, or at least obfuscated.
 
    Encryption marginally slows down rendering, since everything is decrypted on the fly.
    This class needs iOS5 or later. Only available in PSPDFKit Annotate or Source.
 */
@interface PSPDFAESCryptoDataProvider : NSObject

/// Designated initializer with the passphrase and salt.
- (id)initWithURL:(NSURL *)URL passphrase:(NSString *)passphrase salt:(NSString *)salt;

/// PSPDFCryptoDataProvider will be retained as long as you retain this.
@property (nonatomic, readonly) CGDataProviderRef dataProvider;

/// Helper to detect if this CGDataProviderRef is handled by PSPDFAESCryptoDataProvider.
+ (BOOL)isAESCryptoDataProvider:(CGDataProviderRef)dataProviderRef;

/// Feature only available in PSPDFKit Annotate.
+ (BOOL)isAESCryptoFeatureAvailable;

@end
