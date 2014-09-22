//
//  PSPDFRSAKey.h
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

typedef void *OPENSSL_EVP_PKEY;

@interface PSPDFRSAKey : NSObject

/// Initializes from an OpenSSL EVP_PKEY object
- (instancetype)initWithKey:(OPENSSL_EVP_PKEY)key NS_DESIGNATED_INITIALIZER;

/// Returns the OpenSSL private key
@property (nonatomic, readonly) OPENSSL_EVP_PKEY key;

@end
