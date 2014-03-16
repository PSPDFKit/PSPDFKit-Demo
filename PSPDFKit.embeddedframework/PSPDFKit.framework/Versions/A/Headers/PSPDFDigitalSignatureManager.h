//
//  PSPDFDigitalSignatureManager.h
//  PSPDFKit
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFDigitalSignatureVerificationHandler.h"
#import "PSPDFDigitalSignatureRevisionDelegate.h"
#import "PSPDFDigitalSignatureSigningHandler.h"
#import "PSPDFDigitalSignatureSigningDelegate.h"

#import "PSPDFDigitalSignatureManagerDelegate.h"

extern NSString *const PSPDFDigitalSignatureManagerErrorDomain;

typedef NS_ENUM(NSUInteger, PSPDFDigitalSignatureManagerErrorCode) {
    PSPDFDigitalSignatureManagerErrorNone = noErr,
    // X509 errors are within 0 and 50, see x509_vfy.h (OpenSSL)
    PSPDFDigitalSignatureManagerErrorCannotParseSignature = 1000
};

/// Manages signatures.
/// Only available for PSPDFKit Complete with OpenSSL.
@interface PSPDFDigitalSignatureManager : NSObject

/// Returns the shared instance of the signature manager.
+ (PSPDFDigitalSignatureManager *)sharedManager;

@property (atomic, weak) id<PSPDFDigitalSignatureManagerDelegate> delegate;

/// @name Certificates and Signing Identities

/// List of trusted certificates, in the form of PSPDFDigitalCertificate objects.
- (NSArray *)trustedCertificates;

/// List of signing identities, in the form of PSPDFDigitalSigningIdentity objects.
- (NSArray *)signingIdentities;

/// @name Signature Handlers for Signing and Verification

/// The list of available signing handler classes. Each should conform to PSPDFDigitalSigningHandler.
- (NSArray *)signingHandlers;

/// Provide a verification handler for the given signature. A handler is chosen by searching for a filter match first, and then by subFilter.
- (Class<PSPDFDigitalSignatureVerificationHandler>)verificationHandlerForSignature:(PSPDFDigitalSignatureDictionary *)signature;

/// Convenience method that allocates and initialises a suitable verification handler.
- (id<PSPDFDigitalSignatureVerificationHandler>)verificationHandlerInstanceForSignature:(PSPDFDigitalSignatureDictionary *)signature documentProvider:(PSPDFDocumentProvider *)documentProvider;

/// @name Signing and Revision Delegates

- (void)notifiyDelegatesPDFRevisionRequested:(NSData *)pdfData verificationHandler:(id<PSPDFDigitalSignatureVerificationHandler>)handler;

- (void)notifiyDelegatesPDFSigned:(PSPDFDocument *)document signingHandler:(id<PSPDFDigitalSignatureSigningHandler>)handler;

- (BOOL)revisionsSupported;

/// @name Signed Document Output

- (NSString *)outputPathForSignedDocumentFromDocument:(PSPDFDocument *)document;

@end
