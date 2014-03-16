//
//  PSPDFDigitalSignatureManagerDelegate.h
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

/// Only available for PSPDFKit Complete with OpenSSL.
@protocol PSPDFDigitalSignatureManagerDelegate <NSObject>

/// @name Certificates and Signing Identities

/// Whether or not to trust the Adobe CA certificate. Default is YES.
- (BOOL)useAdobeCA;

/// List of trusted certificates, in the form of PSPDFDigitalCertificate objects.
- (NSArray *)trustedCertificates;

/// List of signing identities, in the form of PSPDFDigitalSigningIdentity objects.
- (NSArray *)signingIdentities;

/// @name Signature Handlers for Signing and Verification

/// The list of available signing handler classes. Each should conform to PSPDFKitDigitalSigningHandler.
- (NSArray *)signingHandlers;

/// The list of available verification handler classes. Each should conform to PSPDFKitDigitalVerificationHandler.
- (NSArray *)verificationHandlers;

/// @name Signing and Revision Delegates

- (NSArray *)signingDelegates;
- (NSArray *)revisionDelegates;

@optional

/// @name Signed Document Output

- (NSString *)outputPathForSignedDocumentFromDocument:(PSPDFDocument *)document;

@end
