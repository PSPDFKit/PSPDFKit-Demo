//
//  PSPDFFileAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFAnnotation.h"

@interface PSPDFFileAnnotation : PSPDFAnnotation

/// URL to the file content.
@property (nonatomic, strong) NSURL *URL;

/// File name, as extracted from the annotation.
@property (nonatomic, copy) NSString *fileName;

/// File appearance name. Defines how the attachment looks. Supported are PushPin, Paperclip, Graph and Tag.
@property (nonatomic, copy) NSString *appearanceName;

@end
