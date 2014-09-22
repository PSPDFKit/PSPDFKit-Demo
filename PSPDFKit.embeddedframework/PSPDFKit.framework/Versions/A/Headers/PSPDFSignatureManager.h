//
//  PSPDFSignatureManager.h
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

#import "PSPDFX509.h"
#import "PSPDFSigner.h"


@interface PSPDFSignatureManager : NSObject

+ (instancetype)sharedManager;

/// Returns all registered signers
- (NSArray *)registeredSigners;

/// Registers a signer
- (void)registerSigner:(PSPDFSigner *)signer;

/// Returns the trusted certificate stack.
- (NSArray *)trustedCertificates;

/// Adds a trusted certificate to the stack
- (void)addTrustedCertificate:(PSPDFX509 *)x509;

@end
