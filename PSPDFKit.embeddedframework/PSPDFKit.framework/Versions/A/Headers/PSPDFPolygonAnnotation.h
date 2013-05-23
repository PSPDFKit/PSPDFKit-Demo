//
//  PSPDFPolygonAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAnnotation.h"
#import "PSPDFLineHelper.h"

typedef NS_ENUM(NSInteger, PSPDFPolygonAnnotationType) {
    PSPDFPolygonAnnotationUnknown,
    PSPDFPolygonAnnotationPolygon,
    PSPDFPolygonAnnotationPolyLine
};

/// Polygon annotations (PDF 1.5) display closed polygons on the page. Such polygons may have any number of vertices connected by straight lines. Polyline annotations (PDF 1.5) are similar to polygons, except that the first and last vertex are not implicitly connected.
@interface PSPDFPolygonAnnotation : PSPDFAnnotation

/// Initialize annotation with a polygon type. Designated initializer.
- (id)initWithPolygonType:(PSPDFPolygonAnnotationType)polygonType;

/// Polygon Type.
///
/// The highlight type is inferred from typeString and will not be serialized to disk.
/// Setting the highlight type will also update the typeString.
@property (nonatomic, assign) PSPDFPolygonAnnotationType polygonType;

/// The points of the polygon.
///
/// Contains NSValue objects that box a CGPoint.
/// @warning This values is generated on-the-fly from an internal representation, so use carefully.
@property (nonatomic, copy) NSArray *points;

/// The path of the polygon.
@property (nonatomic, assign, readonly) CGPathRef bezierPath;

/// Start line type.
@property (nonatomic, assign) PSPDFLineEndType lineEnd1;

/// End line type.
@property (nonatomic, assign) PSPDFLineEndType lineEnd2;

/// By default, setting the boundingBox will transform the polygon.
/// Use this setter to manually change the boundingBox without changing the polygon.
- (void)setBoundingBox:(CGRect)boundingBox transformPolygon:(BOOL)transformPolygon;

/// @name Transformers

/// Polygon Type String <-> PSPDPolygonAnnotationType transformer.
+ (NSValueTransformer *)polygonTypeTransformer;

/// Line End String <-> PSPDFLineEndType transformer.
+ (NSValueTransformer *)lineEndTypeTransformer;

@end
