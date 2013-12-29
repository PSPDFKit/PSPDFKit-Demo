//
//  PSPDFCryptor.h
//  AESCryptor
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonKeyDerivation.h>

extern NSString *const PSPDFCryptorErrorDomain;

typedef NS_ENUM(NSInteger, PSPDFCryptorErrorCode) {
    PSPDFCryptorErrorFailedToInitCryptor = 100,
    PSPDFCryptorErrorFailedToProcessFile = 110,
    PSPDFCryptorErrorInvalidIV           = 200,
    PSPDFCryptorErrorWritingOutputFile   = 600,
    PSPDFCryptorErrorReadingInputFile   = 700
};

/// Simple class that encrypts/decrypts files in a format compatible to `PSPDFAESCryptoDataProvider`.
@interface PSPDFCryptor : NSObject

/// Generates a key with (kCCPRFHmacAlgSHA1, 10k iterations, used in new file format - http://github.com/rnapier/RNCryptor/wiki/Data-Format)
/// WARNING! In previous versions it generated (kCCPRFHmacAlgSHA256, 50k used in the legacy file format.
/// Use - (NSData *)keyFromPassphrase:(NSString *)passphrase salt:(NSString *)salt PRF:(CCPseudoRandomAlgorithm)prf rounds:(uint)rounds;
/// to generate key to decrypt legacy file format.
- (NSData *)keyFromPassphrase:(NSString *)passphrase salt:(NSString *)salt;

/// Generate a key with custom number of iterations
/// For the current (RNCryptor https://github.com/rnapier/RNCryptor/wiki/Data-Format ) file format):
/// The default PRF is kCCPRFHmacAlgSHA1.
/// The default number of iterations is PSPDFAESDefaultPBKDFNumberOfRounds (10000).
/// For the legacy file format use kCCPRFHmacAlgSHA256 and 50k rounds
- (NSData *)keyFromPassphrase:(NSString *)passphrase salt:(NSString *)salt PRF:(CCPseudoRandomAlgorithm)prf rounds:(uint)rounds;

/// Encrypt a file (DOES NOT store encryption salt in the file header)
/// Using format https://github.com/rnapier/RNCryptor/wiki/Data-Format
- (BOOL)encryptFromURL:(NSURL *)sourceURL toURL:(NSURL *)targetURL key:(NSData *)key error:(NSError **)error;

/// Decrypt a file.
/// Both the legacy and the current file formats are supported.
- (BOOL)decryptFromURL:(NSURL *)sourceURL toURL:(NSURL *)targetURL key:(NSData *)key error:(NSError **)error;

/// Encrypt a file (stores encryption salt in the file header)
/// Using format https://github.com/rnapier/RNCryptor/wiki/Data-Format
- (BOOL)encryptFromURL:(NSURL *)sourceURL toURL:(NSURL *)targetURL passphrase:(NSString *)passphrase error:(NSError **)error;

/// Decrypt a file.
/// Both the legacy and the current RNCryptor file formats are supported.
/// For the current file format encryption salt from the file header will be used to construct the encryption key.
/// https://github.com/rnapier/RNCryptor/wiki/Data-Format
- (BOOL)decryptFromURL:(NSURL *)sourceURL toURL:(NSURL *)targetURL passphrase:(NSString *)passphrase error:(NSError **)error;


@end
