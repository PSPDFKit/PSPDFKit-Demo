//
//  PSPDFDecryptorInputStream.h
//  PSPDFKit
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

@interface PSPDFCryptoInputStream : NSInputStream

- (instancetype)initWithInputStream:(NSInputStream *)stream decryptionBlock:(NSInteger (^)(PSPDFCryptoInputStream *superStream, uint8_t *buffer, NSInteger len))decryptionBlock;

/// Set the decryption handler. If no decryption block is called, this input stream will simply pass the data through.
/// Return the length of the decrypted buffer. This block is assuming you are decrypting inline.
/// @note Set this property before the input stream is being used.
@property (nonatomic, copy) NSInteger (^decryptionBlock)(PSPDFCryptoInputStream *stream, uint8_t *buffer, NSInteger len);

@end
