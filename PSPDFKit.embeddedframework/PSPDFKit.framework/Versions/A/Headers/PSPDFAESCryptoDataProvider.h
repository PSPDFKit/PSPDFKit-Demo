//
//  PSPDFAESCryptoDataProvider.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"

// The default number of PBKDF rounds is 50000.
extern uint const PSPDFDefaultPBKDFNumberOfRounds;

/**
 This class allows a transparent decryption of AES256 encrypted files (using CBC and an initial 16 byte IV vector)
 The IV vector for the file is written in the first 16 bytes of the file to read.
 Use the provided encryption tool to prepare your documents.

 Ensure your passphrase/salt are also protected within the binary, or at least obfuscated.

 Encryption marginally slows down rendering, since everything is decrypted on the fly.
 Only available in PSPDFKit Annotate or Source.
 */
@interface PSPDFAESCryptoDataProvider : NSObject

/// Designated initializer with the passphrase and salt.
/// URL must be a file-based URL.
- (id)initWithURL:(NSURL *)URL passphrase:(NSString *)passphrase salt:(NSString *)salt rounds:(uint)rounds;

/// Initializer with the passphrase and salt as NSData rather than NSString.
/// URL must be a file-based URL.
- (id)initWithURL:(NSURL *)URL passphraseData:(NSData *)passphraseData salt:(NSData *)saltData rounds:(uint)rounds;

/// Designated initializer with a prepared, stretched, binary key.
/// Warning: only use this if the key is cryptographically random and of length kCCKeySizeAES256.
/// URL must be a file-based URL.
- (id)initWithURL:(NSURL *)URL binaryKey:(NSData *)key;

/// PSPDFCryptoDataProvider will be retained as long as you retain this.
@property (nonatomic, readonly) CGDataProviderRef dataProvider;

/// Helper to detect if this CGDataProviderRef is handled by PSPDFAESCryptoDataProvider.
+ (BOOL)isAESCryptoDataProvider:(CGDataProviderRef)dataProviderRef;

/// Feature only available in PSPDFKit Annotate.
+ (BOOL)isAESCryptoFeatureAvailable;

@end
