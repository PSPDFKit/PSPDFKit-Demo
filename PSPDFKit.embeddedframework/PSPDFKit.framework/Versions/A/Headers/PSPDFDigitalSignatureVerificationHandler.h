//
//  PSPDFDigitalSignatureVerificationHandler.h
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
#import "PSPDFBaseViewController.h"

typedef NS_ENUM(NSUInteger, PSPDFDigitalSignatureVerificationStatusSeverity) {
    PSPDFDigitalSignatureVerificationStatusSeverityOK      = 1,
    PSPDFDigitalSignatureVerificationStatusSeverityWarning = 2,
    PSPDFDigitalSignatureVerificationStatusSeverityError   = 3,
};

/// Only available for PSPDFKit Complete with OpenSSL.
@protocol PSPDFDigitalSignatureVerificationHandler <NSObject>

/** Filter and subfilter are used in the signature meta data in the pdf to represent which signature handler can be used to deal with
    that particular signature. Example filter values are Adobe.PPKLite, Entrust.PPKEF, CICI.SignIt, and VeriSign.PPKVS. The subfilter
    is optional and gives further details on the encoding or format of the signature. Any handler that supports this subfilter
    could be used to verify the signature. Given this, an implementation might choose to ignore one of the values.
    @param filter The filter value.
    @param subFilter The subfilter value (can be nil).
    @return Whether or not this handler should be used to verify a signature with the given filter and subfilter.
 */
+ (BOOL)supportsFilter:(NSString *)filter withSubFilter:(NSString *)subFilter;

/// Designated initializer.
- (id)initWithSignature:(PSPDFDigitalSignatureDictionary *)signature documentProvider:(PSPDFDocumentProvider *)documentProvider;

/// The signature dictionary holding signature informations.
@property (nonatomic, strong, readonly) PSPDFDigitalSignatureDictionary *signature;

/// The source document provider.
@property (nonatomic, weak, readonly) PSPDFDocumentProvider *documentProvider;

/// A view controller to be presented to the user showing the results of the verification.
- (UIViewController *)resultsViewController;

/// Whether or not the signature verifies.
@property (nonatomic, assign, readonly) BOOL verified;

/// A set of `PSPDFSignatureVerificationStatus` objects conforming to the `PSPDFSignatureVerificationStatus` protocol.
/// These should detail any errors or warnings received during verification.
@property (nonatomic, copy, readonly) NSSet *errors;

/// Return YES if the PDF has received incremental updates after being signed and no otherwise. Need not depend on the signature being valid.
- (BOOL)signedVersionLaterUpdated;

/// PDF data for the revision that was signed. Return nil if unavailable.
- (NSData *)dataForSignedRevision;

@optional

/// The parent object that saved the signature. Might be a `PSPDFSignatureFormElement`.
@property (nonatomic, weak) id signatureSource;


@end

/// Return objects conforming to this protocol during a custom signature verification.
/// Only available for PSPDFKit Complete with OpenSSL.
@protocol PSPDFSignatureVerificationStatus <NSObject>

/** The severity of the status.
 
 Use `PSPDFDigitalSignatureVerificationStatusSeverityError` in situations where the signature is wrong and
 the document has been tampered with, `PSPDFDigitalSignatureVerificationStatusSeverityWarning` in situations where the signature does verify but wth caveats such as an expired certificate, and
 `PSPDFDigitalSignatureVerificationStatusSeverityOK` if the status is considered to not be worth warning the user about.
 */
- (PSPDFDigitalSignatureVerificationStatusSeverity)severity;

/// The description of the status that will be shown in the UI.
- (NSString *)statusDescription;

@end
