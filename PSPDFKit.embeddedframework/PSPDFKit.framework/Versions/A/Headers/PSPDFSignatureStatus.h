//
//  PSPDFSignatureStatus.h
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


typedef int OPENSSL_X509_ERR;

typedef NS_ENUM(NSInteger, PSPDFSignatureStatusSeverity) {
	// enum order important!
    PSPDFSignatureStatusSeverityNone = 0,
    PSPDFSignatureStatusSeverityWarning,
    PSPDFSignatureStatusSeverityError,
};

@interface PSPDFSignatureStatus : NSObject

- (instancetype)initWithSigner:(NSString *)signer signingDate:(NSDate *)date wasModified:(BOOL)wasModified;

/// Adds a signature problem report to the status summary and adjusts the
/// status severity if necessary.
- (void)reportSignatureProblem:(OPENSSL_X509_ERR)error;

/// The signer name
@property (nonatomic, copy, readonly) NSString *signer;

/// The signing date
@property (nonatomic, copy, readonly) NSDate *signingDate;

/// Returns YES if the signature was modified since the document was signed,
/// NO otherwise
@property (nonatomic, readonly) BOOL wasModified;

/// Returns an array of problems as text strings
@property (nonatomic, readonly) NSArray *problems;

/// The status severity
@property (nonatomic, assign) PSPDFSignatureStatusSeverity severity;

/// Returns a status summary with the specified signer name and signing date
- (NSString *)summary;

@end
