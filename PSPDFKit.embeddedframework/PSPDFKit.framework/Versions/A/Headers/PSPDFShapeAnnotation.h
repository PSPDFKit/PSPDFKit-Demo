//
//  PSPDFShapeAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAnnotation.h"

typedef NS_ENUM(NSInteger, PSPDFShapeAnnotationType) {
    PSPDFShapeAnnotationUnknown,
    PSPDFShapeAnnotationSquare,
    PSPDFShapeAnnotationCircle
};

// Controls if an AP stream should be generated for Shape annotations.
// Enabled by default. Add this with @NO to the renderingOptions dict in PSPDFDocument to override.
extern NSString *const kPSPDFGenerateAPForShape;

/// PDF Shape Annotation.
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
