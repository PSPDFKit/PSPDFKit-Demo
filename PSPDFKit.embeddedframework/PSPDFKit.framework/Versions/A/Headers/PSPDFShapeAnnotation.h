//
//  PSPDFShapeAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFAnnotation.h"

typedef NS_ENUM(NSInteger, PSPDFShapeAnnotationType) {
    PSPDFShapeAnnotationUnknown,
    PSPDFShapeAnnotationSquare,
    PSPDFShapeAnnotationCircle
};

///
/// PDF Shape Annotation.
///
@interface PSPDFShapeAnnotation : PSPDFAnnotation

/// Initialize annotation with a shape type. Designated initializer.
- (id)initWithShapeType:(PSPDFShapeAnnotationType)shapeType;

/// The Shape type.
///
/// Shape type is inferred from the typeString and won't be serialized.
/// Use [[[self.class shapeTypeTransformer] transformedValue:self.typeString] integerValue] to convert the typeString to shapeType.
@property (nonatomic, assign) PSPDFShapeAnnotationType shapeType;

/// NSString <-> Shape Type transformer.
+ (NSValueTransformer *)shapeTypeTransformer;

@end
