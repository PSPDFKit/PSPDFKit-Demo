//
//  PSPDFDigitalSignatureX509VerificationStatus.h
//  PSPDFKit
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFDigitalSignatureVerificationHandler.h"

@interface PSPDFDigitalSignatureX509VerificationStatus : NSObject <PSPDFSignatureVerificationStatus>

- (id)initWithError:(int)error;
@property (nonatomic, assign) int error;
@property (nonatomic, assign) PSPDFDigitalSignatureVerificationStatusSeverity severity;

@end
