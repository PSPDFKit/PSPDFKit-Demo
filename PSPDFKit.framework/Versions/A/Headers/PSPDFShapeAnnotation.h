//
//  PSPDFShapeAnnotation.h
//  PSPDFKit
//
//  Copyright 2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSPDFAnnotation.h"

typedef enum {
    PSPDFShapeAnnotationUnknown,
    PSPDFShapeAnnotationSquare,
    PSPDFShapeAnnotationCircle
} PSPDFShapeAnnotationType;

/// PDF Shape Annotation.
@interface PSPDFShapeAnnotation : PSPDFAnnotation

/// Shape type.
@property(nonatomic, assign) PSPDFShapeAnnotationType shapeType;

@end
