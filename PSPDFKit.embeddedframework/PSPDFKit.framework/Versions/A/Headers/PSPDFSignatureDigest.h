//
//  PSPDFSignatureDigest.h
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

typedef void *OPENSSL_BIO;

@interface PSPDFSignatureDigest : NSObject

/// Init the signature digest with an OpenSSL BIO object
- (instancetype)initWithBIO:(OPENSSL_BIO)bio NS_DESIGNATED_INITIALIZER;

/// The OpenSSL BIO object
@property (nonatomic, readonly) OPENSSL_BIO bio;

/// Digests a byte range of the file pointed to by fh
- (void)digestRange:(NSRange)range fileHandle:(NSFileHandle *)fh;

/// Digests a raw chunk of data
- (void)digestData:(NSData *)data;

@end
