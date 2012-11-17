//
//  PSPDFStampAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFAnnotation.h"

/**
 PDF Stamp annotation (signature, overlay)
 PSPDFKit has only limited support for stamp annotations that use appearance streams.
 
 An appearance stream is basically a PDF inside a PDF, and this can't be rendered without rewriting a PDF parser.
 You can disable stamp annotations in PSPDFViewController if they aren't displaying correctly.
 
 PSPDF supports the classic text stamps (those won't be displayed by Preview.app, but Adobe Acrobat can display them),
 and stamps that contain one image are also supported (often used for signatures)
*/
@interface PSPDFStampAnnotation : PSPDFAnnotation

/// Designated initializer.
- (id)init;

/// Stamp subject.
@property (nonatomic, copy) NSString *subject;

/// Stamp image, if one is found.
@property (nonatomic, strong) UIImage *image;

@end
