//
//  PSPDFDigitalSignatureSigningHandler.h
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
#import "PSPDFDocumentProvider.h"
#import "PSPDFDigitalSignatureDictionary.h"

@class PSPDFSignatureFormElement;
@class PSPDFBaseViewController;

/// Only available for PSPDFKit Complete with OpenSSL.
@protocol PSPDFDigitalSignatureSigningHandler <NSObject>

/// The name of the preferred signature handler to use when validating this signature. If the Prop_Build entry is not present, it is also the name of the signature handler that was used to create the signature. If Prop_Build is present, it can be used to determine the name of the handler that created the signature (which is typically the same as Filter but is not re- quired to be). An application may substitute a different handler when verify- ing the signature, as long as it supports the specified SubFilter format. Example signature handlers are Adobe.PPKLite, Entrust.PPKEF, CICI.SignIt, and VeriSign.PPKVS.
+ (NSString *)filter;

/// A name that describes the encoding of the signature value and key information in the signature dictionary. An application may use any handler that supports this format to validate the signature. PDF 1.6 defines the following values for public-key cryptographic signatures: adbe.x509.rsa_sha1, adbe.pkcs7.detached, and adbe.pkcs7.sha1 (see Section 8.7.2, “Signature Interoperability”). Other values can be defined by third par- ty developers, subject to the restriction that all names beginning with the adbe. prefix be reserved for future versions of PDF. All third party names must be registered with Adobe Systems. (See PDF Spec, Appendix E).
+ (NSString *)subFilter;

/// The name displayed in the PSPDFKit UI to offer the use of this handler to the user.
+ (NSString *)displayName;

- (id)initWithSignatureField:(PSPDFSignatureFormElement *)signatureField;

@property (nonatomic, strong, readonly) PSPDFSignatureFormElement *signatureField;

@property (nonatomic, weak, readonly) PSPDFDocumentProvider *documentProvider;

/// Output PDF with new signature to given location.
- (PSPDFDocument *)signDocumentOutputPath:(NSString *)outputPath options:(NSDictionary *)options error:(NSError **)error;

/// A view controller to be presented to the user to choose options and activate the signing of the document.
- (UIViewController *)signingViewController;

@end
