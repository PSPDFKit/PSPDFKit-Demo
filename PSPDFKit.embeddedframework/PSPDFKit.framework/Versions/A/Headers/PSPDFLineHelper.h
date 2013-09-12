//
//  PSPDFLineHelper.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "PSPDFAnnotation.h"

#define PSPDFAllLineEndsAreInside   1                   // Define to 1 to keep all line endings extruding from the line/polyline coordinates to a minimum
                                                        // (i.e. reverse arrow line ends are kept from jutting out past the line/polyline endpoints).
                                                        // The PDF spec is conveniently unclear on this topic, do what is most appealing visually, but
                                                        // since every other line ending is kept inside the endpoints, this is enabled here for consistency.
#define PSPDFPolyJoinStyle          kCGLineJoinMiter    // Or kCGLineJoinBevel
#define PSPDFMiterLimit             10.f                // Avoid miters turning to bevels by supplying a high miter limit

typedef NS_ENUM(NSInteger, PSPDFLineEndType) {
    PSPDFLineEndTypeNone,
    PSPDFLineEndTypeSquare,
    PSPDFLineEndTypeCircle,
    PSPDFLineEndTypeDiamond,
    PSPDFLineEndTypeOpenArrow,
    PSPDFLineEndTypeClosedArrow,
    PSPDFLineEndTypeButt,
    PSPDFLineEndTypeReverseOpenArrow,
    PSPDFLineEndTypeReverseClosedArrow,
    PSPDFLineEndTypeSlash
};

// Constructs a polyline between all given points. The two ends of this line can have a PSPDFLineEndType.
extern void PSPDFConstructPolyLine(CGPoint *points, NSUInteger pointsCount, PSPDFLineEndType lineEnd1, PSPDFLineEndType lineEnd2, CGFloat lineWidth,
                                   CGPathRef *storedLinePath, CGPathRef *storedLineEnd1FillPath, CGPathRef *storedLineEnd1StrokePath, CGPathRef *storedLineEnd2FillPath, CGPathRef *storedLineEnd2StrokePath,
                                   BOOL originUpperLeft);

// Contstructs a polyline, convenience method that uses `PSPDFConstructPolyLine` internally.
extern void PSPDFConstructPolyLineBezierPathWithPoints(NSArray *points, PSPDFLineEndType lineEnd1, PSPDFLineEndType lineEnd2, CGFloat lineWidth, BOOL originUpperLeft, UIBezierPath **outStrokePath, UIBezierPath **outFillPath);

// Draws a polyline between all given points. The two ends of this line can have a PSPDFLineEndType.
extern void PSPDFDrawPolyLine(CGContextRef context, CGPoint *points, NSUInteger pointsCount, PSPDFLineEndType lineEnd1, PSPDFLineEndType lineEnd2, CGFloat lineWidth);

// Draws a line between two points with the specified line end types.
extern void PSPDFDrawLine(CGContextRef context, CGPoint point1, CGPoint point2, PSPDFLineEndType lineEnd1, PSPDFLineEndType lineEnd2, CGFloat lineWidth);

// Returns whether the line end type requires a full line.
// A full line is required if the line end type directly "connects" to the line, e.g. for an open arrow.
extern BOOL PSPDFLineEndNeedsFullLine(PSPDFLineEndType lineEnd);

// Returns the fill and stroke paths corresponding to a given line end type.
extern void PSPDFGetPathsForLineEndType(PSPDFLineEndType endType, CGPoint *points, NSUInteger pointsCount, CGFloat lineWidth, CGPathRef *storedFillPath, CGPathRef *storedStrokePath);

// Returns the rectangle encompassing the line end at the first of two points.
extern CGRect PSPDFGetLineEndRectangle(CGPoint point1, CGPoint point2, PSPDFLineEndType lineEnd, CGFloat lineWidth);

// Transforms line end string <-> line end type (PDF reference).
extern NSString * const PSPDFLineEndTypeTransformerName;

// Will update `lineCap` and `lineJoin` depending on the `annotationType` set.
extern void PSPDFUpdateShapeLayerLineStyleForAnnotationType(CAShapeLayer *shapeLayer, PSPDFAnnotationType annotationType);

// Converts the 'dashArray' of an annotation into the array usabe in CoreGraphics.
extern CGFloat *PSPDFCreateLineDashArrayForAnnotation(PSPDFAnnotation *annotation, NSUInteger *outDashCount);
