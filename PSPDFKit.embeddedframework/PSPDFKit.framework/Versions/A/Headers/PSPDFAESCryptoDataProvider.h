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

- (id)initWithURL:(NSURL *)URL andKey:(NSString *)cryptoKey;

// Created on first access. PSPDFCryptoDataProvider will be retained as long as you retain this.
- (CGDataProviderRef)dataProviderRef;

@end
