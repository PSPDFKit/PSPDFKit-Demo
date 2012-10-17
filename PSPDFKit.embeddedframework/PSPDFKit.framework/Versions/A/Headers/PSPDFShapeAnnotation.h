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

- (id)initWithType:(PSPDFShapeAnnotationType)annotationType;

/// Shape type.
@property (nonatomic, assign) PSPDFShapeAnnotationType shapeType;

@end
