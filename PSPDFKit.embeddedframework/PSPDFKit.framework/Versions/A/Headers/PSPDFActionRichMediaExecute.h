//
//  PSPDFActionRichMediaExecute.h
//  PSPDFKit
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFAction.h"

@class PSPDFRichMediaAnnotation;

/// A rich-media-execute action identifies a rich media annotation and specifies a command to be sent to that annotation’s handler. (See Section 9.6, “Rich Media” on page 76. of the Adobe® Supplement to the ISO 32000)
@interface PSPDFActionRichMediaExecute : PSPDFAction

/// Designated initializers
- (id)init;

- (id)initWithPDFDictionary:(CGPDFDictionaryRef)actionDictionary documentRef:(CGPDFDocumentRef)documentRef;

/// The rich media action command.
@property (nonatomic, copy) NSString *command;

/// The rich media action command argument
@property (nonatomic, copy) NSString *argument;

/// The associated screen annotation. Optional. Will link to an already existing annotation.
@property (nonatomic, strong) PSPDFRichMediaAnnotation *annotation;


@end
