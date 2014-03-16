//
//  PSPDFDigitalSignatureSigningDelegate.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFSignatureFormElement.h"

/// Only available for PSPDFKit Complete with OpenSSL.
@protocol PSPDFDigitalSignatureSigningDelegate <NSObject>

- (void)pdfSigned:(PSPDFDocument *)pdf signingHandler:(id<PSPDFDigitalSignatureSigningHandler>)handler;

@end
