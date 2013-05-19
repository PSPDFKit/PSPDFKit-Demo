//
//  PSPDFGeometry.h
//  PSPDFKit
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PSPDFDegreesToRadians(degrees) ((CGFloat)degrees * (CGFloat)M_PI / 180.f)
#define PSPDFRadiansToDegrees(degrees) ((CGFloat)degrees * (180.f / (CGFloat)M_PI))

/// Calculates the minimum bounding rect.
///
/// The minimum bounding rect is the smallest possible rectangle that contains all points.
/// @note If you provide an array with 0 points, CGRectZero will be returned.
extern CGRect PSPDFCalculateMinimumBoundingRect(CGPoint *points, NSUInteger count);

/// Inverts edge insets by multiplying top, bottom, left, and right with -1.0.
extern UIEdgeInsets PSPDFInvertEdgeInsets(UIEdgeInsets edgeInsets);

typedef NS_ENUM(NSInteger, PSPDFRectAlignment) {
    PSPDFRectAlignCenter = 0,
    PSPDFRectAlignTop,
    PSPDFRectAlignTopLeft,
    PSPDFRectAlignTopRight,
    PSPDFRectAlignLeft,
    PSPDFRectAlignBottom,
    PSPDFRectAlignBottomLeft,
    PSPDFRectAlignBottomRight,
    PSPDFRectAlignRight
};

/// Returns scale to fit a size within another size.
extern CGFloat PSPDFScaleForSizeWithinSize(CGSize targetSize, CGSize boundsSize);

/// Returns scale to fit a size within another size, with optional zooming.
extern CGFloat PSPDFScaleForSizeWithinSizeWithOptions(CGSize targetSize, CGSize boundsSize, BOOL zoomMinimalSize, BOOL fitToWidthEnabled);

/// Helper to calculate new size for specific scale and size.
extern CGSize PSPDFSizeForScale(CGSize size, CGFloat scale);

/// Helper that aligns rectangles depending on PSPDFRectAlignment. (usually used to center)
extern CGRect PSPDFAlignRectangles(CGRect alignee, CGRect aligner, PSPDFRectAlignment alignment);

/// Alignment helper that allows offsets.
extern CGRect PSPDFAlignSizeWithinRectWithOffset(CGSize targetSize, CGRect bounds, CGFloat widthOffset, CGFloat heightOffset, PSPDFRectAlignment alignment);

// Divides a source rectangle into two component rectangles, skipping the given amount of padding in between them.
void PSPDFRectDivideWithPadding(CGRect rect, CGRect *slicePtr, CGRect *remainderPtr, CGFloat sliceAmount, CGFloat padding, CGRectEdge edge);

/// Normalizes rotation values (returns something between 0 and 359)
extern NSUInteger PSPDFNormalizeRotation(NSInteger rotation);

/// Apply rotation to specific rect
extern CGRect PSPDFApplyRotationToRect(CGRect pageRect, NSInteger rotation);

/// Get the affine transform for specific pageRect and rotation.
extern CGAffineTransform PSPDFGetTransformFromPageRectAndRotation(CGRect pageRect, NSInteger rotation);

/// Convert a view point to a pdf point. bounds is from the view (usually PSPDFPageView.bounds)
extern CGPoint PSPDFConvertViewPointToPDFPoint(CGPoint viewPoint, CGRect cropBox, NSUInteger rotation, CGRect bounds);

/// Convert a pdf point to a view point.
extern CGPoint PSPDFConvertPDFPointToViewPoint(CGPoint pdfPoint, CGRect cropBox, NSUInteger rotation, CGRect bounds);

/// Convert a pdf rect to a normalized view rect.
extern CGRect PSPDFConvertPDFRectToViewRect(CGRect pdfRect, CGRect cropBox, NSUInteger rotation, CGRect bounds);

/// Convert a view rect to a normalized pdf rect
extern CGRect PSPDFConvertViewRectToPDFRect(CGRect viewRect, CGRect cropBox, NSUInteger rotation, CGRect bounds);

/// Normalizes a rect. PDF rect's might have negative width/height, this turns them around.
extern inline CGRect PSPDFNormalizeRect(CGRect rect);

/// Builds a rect out of two CGPoints.
extern inline CGRect PSPDFCGRectFromPoints(CGPoint p1, CGPoint p2);
