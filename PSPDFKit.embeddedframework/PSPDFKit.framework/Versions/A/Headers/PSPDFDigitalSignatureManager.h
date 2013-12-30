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

extern NSString *const PSPDFDigitalSignatureManagerErrorDomain;

typedef NS_ENUM(NSUInteger, PSPDFDigitalSignatureManagerErrorCode) {
    PSPDFDigitalSignatureManagerErrorNone = noErr,
    // X509 errors are within 0 and 50, see x509_vfy.h (OpenSSL)
    PSPDFDigitalSignatureManagerErrorCannotParseSignature = 1000
};

/// Manages signatures. Requires OpenSSL.
@interface PSPDFDigitalSignatureManager : NSObject

/// Returns the shared instance of the signature manager.
+ (PSPDFDigitalSignatureManager *)sharedManager;

/// @name Managing Signature Handlers

/// Default handler, used when no other handler matches given filter and subFilter. The default default handler is `PSPDFDigitalSignatureVerificationController`.
@property (atomic, strong) Class<PSPDFDigitalSignatureVerificationHandler> defaultHandler;

/// Provide a handler for the given signature. A handler is chosen by searching for a filter match first, and then by subFilter.
- (Class<PSPDFDigitalSignatureVerificationHandler>)verificationHandlerForSignature:(PSPDFDigitalSignatureDictionary *)signature;

/// Convenience method that allocates and initialises a suitable handler.
- (id<PSPDFDigitalSignatureVerificationHandler>)verificationHandlerInstanceForSignature:(PSPDFDigitalSignatureDictionary *)signature documentProvider:(PSPDFDocumentProvider *)documentProvider;

/// The current handlers keyed by the filter attribute. These are tried first.
- (NSArray *)verificationHandlers;

- (void)addVerificationHandler:(Class<PSPDFDigitalSignatureVerificationHandler>)handler;
- (void)removeVerificationHandler:(Class<PSPDFDigitalSignatureVerificationHandler>)handler;

/// @name Managing Revision Delegates

/// Register to be notified when signed revisions are requested, in order to show them in the UI.
- (void)registerForReceivingRequestsToViewRevisions:(id<PSPDFDigitalSignatureRevisionDelegate>)delegate;

- (NSArray *)currentRevisionDelegates;

/// Deregister from being notified when signed revisions are requested.
- (void)deregisterFromReceivingRequestsToViewRevisions:(id<PSPDFDigitalSignatureRevisionDelegate>)delegate;

- (void)notifiyDelegatesPDFRevisionRequested:(NSData *)pdfData verificationHandler:(id<PSPDFDigitalSignatureVerificationHandler>)handler;

/// @name Managing Certificates

/// The current list of trusted certificates.
- (NSArray *)certificates;

/// Add your own trusted certificates here.
/// The expectation is that the data is in PKCS#7 format, as exported from Adobe Acrobat.
- (BOOL)addCertificate:(NSData *)certificate error:(NSError **)error;

/// Remove a certificate from the list of trusted certificates (by reference).
- (void)removeCertificate:(NSData *)certificate;

/// Whether or not to trust the Adobe CA certificate. Default is YES.
@property (atomic, assign) BOOL useAdobeCA;

@end
