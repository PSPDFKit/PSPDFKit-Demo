//
//  TextAnnotation.h
//  PSPDFKit
//
//  Copyright 2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSPDFAnnotation.h"

/// PDF Text (Note) Annotation.
@interface PSPDFTextAnnotation : PSPDFAnnotation

/// Icon name.
@property (nonatomic, strong) NSString *iconName;

/// Designated initializer.
- (id)initWithAnnotationDictionary:(CGPDFDictionaryRef)annotDict inAnnotsArray:(CGPDFArrayRef)annotsArray;

@end
