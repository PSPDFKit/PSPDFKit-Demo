//
//  PSPDFActionRendition.h
//  PSPDFKit
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFAction.h"

@class PSPDFScreenAnnotation;

typedef NS_ENUM(NSUInteger, PSPDFActionRenditionOperation) {
    PSPDFActionRenditionOperationPlayStop,
    PSPDFActionRenditionOperationStop,
    PSPDFActionRenditionOperationPause,
    PSPDFActionRenditionOperationResume,
    PSPDFActionRenditionOperationPlay,
};

/// A rendition action (PDF 1.5) controls the playing of multimedia content (see PDF Refernce 1.7, 13.2, “Multimedia”).
/// @note JavaScript actions are not supported.
@interface PSPDFActionRendition : PSPDFAction

/// Designated initializers
- (id)init;

- (id)initWithPDFDictionary:(CGPDFDictionaryRef)actionDictionary documentRef:(CGPDFDocumentRef)documentRef;

/// The rendition action operation.
@property (nonatomic, assign) PSPDFActionRenditionOperation operation;

/// The associated screen annotation. Optional. Will link to an already existing annotation.
@property (nonatomic, strong) PSPDFScreenAnnotation *annotation;

@end
