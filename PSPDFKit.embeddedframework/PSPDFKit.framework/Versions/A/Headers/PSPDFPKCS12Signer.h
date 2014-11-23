//
//  PSPDFPKCS12Signer.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFSigner.h"
#import "PSPDFPKCS12.h"

/// Sets `filter` to `Adobe.PPKLite` and `subFilter` to `adbe.pkcs7.detached`.
@interface PSPDFPKCS12Signer : PSPDFSigner

/// Creates a new PKCS12 signer with the specified display name. The certificate
/// and private key should be contained in p12.
- (instancetype)initWithDisplayName:(NSString *)name PKCS12:(PSPDFPKCS12 *)p12 NS_DESIGNATED_INITIALIZER;

/// Signs the element using provided password to open the p12 container (to get the certificate and the private key).
/// Use it only for non-interactive signing process.
- (void)signFormElement:(PSPDFSignatureFormElement *)element usingPassword:(NSString *)password writeTo:(NSString *)path completion:(void (^)(BOOL success, PSPDFDocument *document, NSError *error))completionBlock;

@end
