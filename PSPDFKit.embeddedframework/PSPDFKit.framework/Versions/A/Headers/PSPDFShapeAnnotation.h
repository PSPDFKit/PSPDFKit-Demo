//
//  PSPDFShapeAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFAnnotation.h"

typedef NS_ENUM(NSInteger, PSPDFShapeAnnotationType) {
    PSPDFShapeAnnotationUnknown,
    PSPDFShapeAnnotationSquare,
    PSPDFShapeAnnotationCircle
};

/// PDF Shape Annotation.
@interface PSPDFShapeAnnotation : PSPDFAnnotation

/// Designated initializer.
- (id)initWithShapeType:(PSPDFShapeAnnotationType)shapeType;

/// Shape type.
@property (nonatomic, assign) PSPDFShapeAnnotationType shapeType;

@end
