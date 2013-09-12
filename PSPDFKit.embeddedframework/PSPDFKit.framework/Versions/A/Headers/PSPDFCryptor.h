//
//  PSPDFCryptor.h
//  AESCryptor
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

#define PBKDFNumberOfRounds 50000

extern NSString *const PSPDFCryptorErrorDomain;

typedef NS_ENUM(NSInteger, PSPDFCryptorErrorCode) {
    PSPDFCryptorErrorFailedToInitCryptor = 100,
    PSPDFCryptorErrorFailedToProcessFile = 110,
    PSPDFCryptorErrorInvalidIV           = 200,
    PSPDFCryptorErrorWritingOutputFile   = 600
};

/// Simple class that encrypts/decrypts files in a format compatible to PSPDFAESCryptoDataProvider.
@interface PSPDFCryptor : NSObject

/// Generate a key
- (NSData *)keyFromPassphrase:(NSString *)passphrase salt:(NSString *)salt;

/// Encrypt a file.
- (BOOL)encryptFromURL:(NSURL *)sourceURL toURL:(NSURL *)targetURL key:(NSData *)key error:(NSError **)error;

/// Decrypt a file
- (BOOL)decryptFromURL:(NSURL *)sourceURL toURL:(NSURL *)targetURL key:(NSData *)key error:(NSError **)error;

@end
