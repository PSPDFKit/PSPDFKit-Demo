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

@class PSPDFSignedFormElementViewController, PSPDFUnsignedFormElementViewController;
@class PSPDFInkAnnotation, PSPDFSignatureInfo;

/// Signature Form Element.
@interface PSPDFSignatureFormElement : PSPDFFormElement

/// Returns either the signed or the unsigned view controller depending on if the field is signed or not.
@property (nonatomic, weak, readonly) UIViewController *viewController;

/// Returns the signed view controller if the field is signed, |nil| otherwise
@property (nonatomic, strong, readonly) PSPDFSignedFormElementViewController *signedViewController;

/// Returns the unsigned view controller if the field is unsigned, |nil| otherwise
@property (nonatomic, strong, readonly) PSPDFUnsignedFormElementViewController *unsignedViewController;

/// Returns YES if the signature field is digitally signed.
/// @note This does not mean that the signature is valid.
@property (nonatomic, readonly) BOOL isSigned;

/// Signature information.
@property (nonatomic, strong) PSPDFSignatureInfo *signatureInfo;

/// Searches the document for an ink signature that overlaps the form element.
/// @note This can be used as a replacement for a digital signature.
- (PSPDFInkAnnotation *)overlappingInkSignature;

@end

@interface PSPDFSignatureFormElement (SubclassingHooks)

- (void)drawArrowWithText:(NSString *)text andColor:(UIColor *)color inContext:(CGContextRef)context;

@end

@interface PSPDFSignaturePropBuildEntry : PSPDFModel

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *date;
@property (nonatomic, assign, readonly) NSInteger R;
@property (nonatomic, copy, readonly) NSString *OS;
@property (nonatomic, strong, readonly) NSNumber *preRelease;     // BOOL
@property (nonatomic, strong, readonly) NSNumber *nonEFontNoWarn; // BOOL
@property (nonatomic, strong, readonly) NSNumber *trustedMode;    // BOOL
@property (nonatomic, assign, readonly) NSInteger V;
@property (nonatomic, copy, readonly) NSString *REx;

@end

@interface PSPDFSignaturePropBuild : PSPDFModel

@property (nonatomic, copy, readonly) PSPDFSignaturePropBuildEntry *filter;
@property (nonatomic, copy, readonly) PSPDFSignaturePropBuildEntry *pubSec;
@property (nonatomic, copy, readonly) PSPDFSignaturePropBuildEntry *app;
@property (nonatomic, copy, readonly) PSPDFSignaturePropBuildEntry *sigQ;

@end

@interface PSPDFSignatureInfo : PSPDFModel

@property (nonatomic, assign, readonly) NSUInteger placeholderBytes;
@property (nonatomic, copy, readonly) NSData *contents;
@property (nonatomic, copy, readonly) NSArray *byteRange;
@property (nonatomic, copy, readonly) NSString *filter;
@property (nonatomic, copy, readonly) NSString *subFilter;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSDate *creationDate;
@property (nonatomic, copy, readonly) NSString *reason;
@property (nonatomic, copy, readonly) PSPDFSignaturePropBuild *propBuild;

// (Optional; PDF 1.5) An array of signature reference dictionaries.
@property (nonatomic, copy, readonly) NSArray *references;

@end
