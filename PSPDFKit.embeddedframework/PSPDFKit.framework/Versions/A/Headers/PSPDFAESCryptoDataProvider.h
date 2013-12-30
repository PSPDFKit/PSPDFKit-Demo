//
//  PSPDFAESCryptoDataProvider.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <CommonCrypto/CommonKeyDerivation.h>
#import "PSPDFKitGlobal.h"

@class PSPDFAESDecryptor;

/// In the old legacy file format the default number of PBKDF rounds is 50000.
/// The new default is `PSPDFAESDefaultPBKDFNumberOfRounds`. (10000)
extern uint const PSPDFDefaultPBKDFNumberOfRounds;

/**
 This class allows a transparent decryption of AES256 encrypted files using
 the RNCryptor file format https://github.com/rnapier/RNCryptor/wiki/Data-Format
 Legacy PSPDFKit old file format is also supported.
 Use the provided encryption tool to prepare your documents.

 Ensure your passphrase/salt are also protected within the binary, or at least obfuscated.

 Encryption marginally slows down rendering, since everything is decrypted on the fly.
 Only available in PSPDFKit Basic/Complete.
 */
@interface PSPDFAESCryptoDataProvider : NSObject

/// Designated initializer with the passphrase and salt.
/// URL must be a file-based URL.
- (id)initWithURL:(NSURL *)URL passphrase:(NSString *)passphrase salt:(NSString *)salt rounds:(uint)rounds;

/// Initializer with the passphrase and salt as NSData rather than NSString.
/// URL must be a file-based URL.
- (id)initWithURL:(NSURL *)URL passphraseData:(NSData *)passphraseData salt:(NSData *)saltData rounds:(uint)rounds;

/// Designated initializer with the passphrase. Salt will be loaded from the header of the
/// file format (see https://github.com/rnapier/RNCryptor/wiki/Data-Format )
/// The default PRF is kCCPRFHmacAlgSHA1.
/// The number of iterations will be the new default PSPDFAESDefaultPBKDFNumberOfRounds (10000)
/// URL must be a file-based URL.
- (id)initWithURL:(NSURL *)URL passphrase:(NSString *)passphrase;

/// Designated initializer with the passphrase and customized PRF and iterations number.
/// Salt will be loaded from the header of the
/// file format (see https://github.com/rnapier/RNCryptor/wiki/Data-Format )
/// The default PRF is `kCCPRFHmacAlgSHA1`.
/// The default number of iterations is `PSPDFAESDefaultPBKDFNumberOfRounds` (10000).
/// URL must be a file-based URL.
- (id)initWithURL:(NSURL *)URL passphrase:(NSString *)passphrase PRF:(CCPseudoRandomAlgorithm)prf rounds:(uint)rounds;

/// Designated initializer with a prepared, stretched, binary key.
/// Warning: only use this if the key is cryptographically random and of length `kCCKeySizeAES256`.
/// The default PRF is `kCCPRFHmacAlgSHA1`.
/// The default number of iterations is `PSPDFAESDefaultPBKDFNumberOfRounds` (10000).
/// For legacy file format use `kCCPRFHmacAlgSHA256` and 50000 rounds.
/// URL must be a file-based URL.
- (id)initWithURL:(NSURL *)URL binaryKey:(NSData *)key;

/// `PSPDFCryptoDataProvider` will be retained as long as you retain this.
@property (nonatomic, readonly) CGDataProviderRef dataProvider;

/// Helper to detect if this `CGDataProviderRef` is handled by `PSPDFAESCryptoDataProvider`.
+ (BOOL)isAESCryptoDataProvider:(CGDataProviderRef)dataProviderRef;

/// Feature only available in PSPDFKit Basic/Complete.
+ (BOOL)isAESCryptoFeatureAvailable;

@end
