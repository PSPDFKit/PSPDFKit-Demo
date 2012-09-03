//
//  PSPDFAESCryptoDataProvider.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

/**
    We use AES256 encryption here.
    The IV vector for the file is written in the first 16 bytes of the file to read.
 */
@interface PSPDFAESCryptoDataProvider : NSObject

/// Designated initializer with the passphrase and salt.
- (id)initWithURL:(NSURL *)URL passphrase:(NSString *)passphrase salt:(NSString *)salt;

/// Created on first access. PSPDFCryptoDataProvider will be retained as long as you retain this.
- (CGDataProviderRef)dataProviderRef;

@end
