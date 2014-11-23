//
//  PSPDFInkAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAnnotation.h"

/// PDF Ink Annotation. (Free Drawing)
/// Lines are automatically transformed when the `boundingBox` is changed.
@interface PSPDFInkAnnotation : PSPDFAnnotation

/// Designated initializer.
- (instancetype)initWithLines:(NSArray *)lines;

/// Array of arrays of boxed `CGPoints`.
/// Example: `annotation.lines = @[@[BOXED(CGPointMake(100,100)), BOXED(CGPointMake(100,200)), BOXED(CGPointMake(150,300))]]`;
/// @warning: After setting lines, `boundingBox` will be automatically recalculated.
@property (nonatomic, copy) NSArray *lines;

/// The `UIBezierPath` will be dynamically crated from the lines array.
@property (nonatomic, copy, readonly) UIBezierPath *bezierPath;

/// Returns YES if `lines` doesn't contain any points.
- (BOOL)isEmpty;

/// Will return YES if this ink annotation is in the natural drawing style.
/// This is a proprietary extension - other viewer will not be able to detect this.
@property (nonatomic, assign) BOOL naturalDrawingEnabled;

/// Will return YES if this ink annotation is a PSPDFKit signature.
/// This is a proprietary extension - other viewer will not be able to detect this.
@property (nonatomic, assign) BOOL isSignature;

/// By default, setting the `boundingBox` will transform all points in the lines array.
/// Use this setter to manually change the `boundingBox` without changing lines.
- (void)setBoundingBox:(CGRect)boundingBox transformLines:(BOOL)transformLines;

/// Generate new line array by applying transform.
/// This is used internally when `boundingBox` is changed.
- (NSArray *)copyLinesByApplyingTransform:(CGAffineTransform)transform;

@end

PSPDFKIT_EXTERN_C_BEGIN

// Helper to convert `UIBezierPath` into an array of points (of `CGPoints` inside `NSValues`).
NSArray *PSPDFBezierPathGetPoints(UIBezierPath *path);

// Calculates the bounding box from lines.
CGRect PSPDFBoundingBoxFromLines(NSArray *lines, CGFloat lineWidth);

// Calculates the natural drawing bounding box from lines.
CGRect PSPDFNaturalDrawingBoundingBoxFromLines(NSArray *lines);

// Returns a new set of lines, with transform applied.
NSArray *PSPDFCopyLinesByApplyingTransform(NSArray *lines, CGAffineTransform transform);

// Calls `PSPDFIncrementalBezierPathFromPoints` with a `nil` `cachedPath`.
// @see PSPDFIncrementalBezierPathFromPoints
UIBezierPath *PSPDFBezierPathFromPoints(NSArray *pointArray, BOOL spline, CGAffineTransform transform);

// Create a spline path or regular path from an array of points.
// If you specify the `cachedPath` (an initially empty path), the method can optimize it's calculations by just computing the bezier segments
// for the last two points in `pointArray`. The `cachedPath` will be modified and should be passed in when you next call this method after the `pointArray` grows.
UIBezierPath *PSPDFIncrementalBezierPathFromPoints(NSArray *pointArray, BOOL spline, CGAffineTransform transform, UIBezierPath *cachedPath);

// Calls `PSPDFIncrementalBezierPathFromLines` with a `nil` `cachedPath`.
// @see PSPDFIncrementalBezierPathFromLines
UIBezierPath *PSPDFBezierPathFromLines(NSArray *lines, BOOL spline, CGFloat lineWidth, CGAffineTransform transform);

// Create a spline path or regular path from lines (array of point arrays).
// If you specify the `cachedPath` (an initially empty path) and if `lines` has just one element, the method can optimize it's calculations by just computing the bezier segments
// for the last two points of the line. The `cachedPath` will be modified and should be passed in when you next call this method after the line grows.
// @note A regular path might be created if there's too much data, despite the `spline` parameter being set.
// @see PSPDFIncrementalBezierPathFromPoints
UIBezierPath *PSPDFIncrementalBezierPathFromLines(NSArray *lines, BOOL spline, CGFloat lineWidth, CGAffineTransform transform, UIBezierPath *cachedPath);

// Will convert view lines to PDF lines (operates on every point)
// Get the `cropBox` and rotation from `PSPDFPageInfo`.
// bounds should be the size of the view.
NSArray *PSPDFConvertViewLinesToPDFLines(NSArray *lines, CGRect cropBox, NSUInteger rotation, CGRect bounds);

// Converts a single line of boxed `CGPoints`.
NSArray *PSPDFConvertViewLineToPDFLines(NSArray *line, CGRect cropBox, NSUInteger rotation, CGRect bounds);

// Will convert PDF lines to view lines (operates on every point)
NSArray *PSPDFConvertPDFLinesToViewLines(NSArray *lines, CGRect cropBox, NSUInteger rotation, CGRect bounds);

PSPDFKIT_EXTERN_C_END
