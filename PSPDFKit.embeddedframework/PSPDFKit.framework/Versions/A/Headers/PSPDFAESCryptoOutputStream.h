//
//  PSPDFAESCryptoOutputStream.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import "PSPDFCryptoOutputStream.h"

/// The PSPDFAESCryptoOutputStream Error Domain.
/// @note Used in the PSPDFAESCryptoOutputStream -(NSError *)streamError method.
extern NSString *const PSPDFAESCryptoOutputStreamErrorDomain;

/// List of documented errors within the PSPDFAESCryptoOutputStream.
/// @note Used in the PSPDFAESCryptoOutputStream -(NSError *)streamError method.
typedef NS_ENUM(NSInteger, PSPDFAESCryptoOutputStreamErrorCode) {
    PSPDFErrorCodeAESCryptoOutputStreamEncryptionFailed = 100,
    PSPDFErrorCodeAESCryptoOutputStreamCryptorFinalFailed = 170,
    PSPDFErrorCodeAESCryptoOutputStreamWritingToParentStreamFailed = 120,
    PSPDFErrorCodeAESCryptoOutputStreamFailedToAllocateMemory = 200,
    PSPDFErrorCodeAESCryptoOutputStreamUnknown = NSIntegerMax
};

/// AES decryption, RNCryptor data format  (see https://github.com/RNCryptor/RNCryptor-Spec/blob/master/RNCryptor-Spec-v3.md )
@interface PSPDFAESCryptoOutputStream : PSPDFCryptoOutputStream

/// Designated initializer with the passphrase. The encryption key salt and HMAC key salt will be saved in the file header.
- (instancetype)initWithOutputStream:(NSOutputStream *)stream passphrase:(NSString *)passphrase;

/// Check the streamStatus after calling this method. Due to AES CBC encryption is working finalized data
/// is written during this call. If it fails the streamStatus is set to NSStreamStatusError and streamError
/// holds the detailed info.
- (void)close;

@end
