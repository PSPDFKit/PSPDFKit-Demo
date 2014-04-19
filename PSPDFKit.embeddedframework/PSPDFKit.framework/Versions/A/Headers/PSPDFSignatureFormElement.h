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

#import "PSPDFAbstractTextRenderingFormElement.h"
#import "PSPDFDigitalSignatureVerificationController.h"
#import "PSPDFDigitalSignatureSigningHandler.h"

@class PSPDFInkAnnotation;

/// Signature Form Element.
@interface PSPDFSignatureFormElement : PSPDFAbstractTextRenderingFormElement

/// The digital signature verification handler.
@property (nonatomic, strong, readonly) id<PSPDFDigitalSignatureVerificationHandler> verificationHandler;

/// Allows to check if the signature could be verified.
@property (nonatomic, assign, readonly) BOOL verified;

/// The signer name, if set.
@property (nonatomic, copy) NSString *XSigner;

/// Searches the document for an ink signature that overlaps the form element.
/// @note This can be used as a replacement for a digital signature.
- (PSPDFInkAnnotation *)overlappingInkSignature;

@end

@interface PSPDFSignatureFormElement (SubclassingHooks)

- (void)drawArrowWithText:(NSString *)text andColor:(UIColor *)color inContext:(CGContextRef)context;

@end
