//
//  PSPDFShapeAnnotation.h
//  PSPDFKit
//
//  Copyright 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFAnnotation.h"

typedef NS_ENUM(NSInteger, PSPDFShapeAnnotationType) {
    PSPDFShapeAnnotationUnknown,
    PSPDFShapeAnnotationSquare,
    PSPDFShapeAnnotationCircle
};

/// PDF Shape Annotation.
@interface PSPDFShapeAnnotation : PSPDFAnnotation

/// Shape type.
@property (nonatomic, assign) PSPDFShapeAnnotationType shapeType;

@end
