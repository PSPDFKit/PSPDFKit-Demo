//
//  PSPDFSignatureFormElement.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFFormElement.h"
#import "PSPDFDigitalSignatureVerificationController.h"

@class PSPDFInkAnnotation;

/// Signature Form Element.
@interface PSPDFSignatureFormElement : PSPDFFormElement

@property (nonatomic, weak, readonly) id<PSPDFDigitalSignatureVerificationHandler> verificationHandler;

@property (nonatomic, assign, readonly) BOOL verified;

/// Searches the document for an ink signature that overlaps the form element.
/// @note This can be used as a replacement for a digital signature.
- (PSPDFInkAnnotation *)overlappingInkSignature;

@end
