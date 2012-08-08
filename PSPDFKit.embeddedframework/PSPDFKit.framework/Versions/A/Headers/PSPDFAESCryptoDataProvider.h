//
//  PSPDFAESCryptoDataProvider.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFCryptoDataProvider.h"

/// BROKEN
@interface PSPDFAESCryptoDataProvider : NSObject

- (id)initWithURL:(NSURL *)URL andKey:(NSString *)cryptoKey;

// Created on first access. PSPDFCryptoDataProvider will be retained as long as you retain this.
- (CGDataProviderRef)dataProviderRef;

@end
