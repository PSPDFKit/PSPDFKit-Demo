//
//  PSPDFX509.h
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

#import "PSPDFRSAKey.h"


typedef void *OPENSSL_X509;

@interface PSPDFX509 : NSObject

/// The Adobe certification authority
+ (instancetype)adobeCA;

/// Initializes the certificate from certificate data
+ (NSArray *)certificatesFromPKCS7Data:(NSData *)data error:(NSError **)err;

/// Initializes the certificate with an OpenSSL X509 type
- (instancetype)initWithX509:(OPENSSL_X509)x509 NS_DESIGNATED_INITIALIZER;

/// The underlying OpenSSL X509 object
@property (nonatomic, readonly) OPENSSL_X509 cert;

/// The public key
@property (nonatomic, readonly) PSPDFRSAKey *publicKey;

/// The CN entry
@property (nonatomic, copy, readonly) NSString *commonName;

@end
