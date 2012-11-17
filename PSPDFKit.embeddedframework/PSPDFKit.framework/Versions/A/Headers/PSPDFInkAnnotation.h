//
//  PSPDFInkAnnotation.h
//  PSPDFKit
//
//  Copyright 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFAnnotation.h"

// Helper to convert UIBezierPath into an array of lines (of CGPoints inside NSValues).
NSArray *PSPDFBezierPathGetPoints(UIBezierPath *path);

/// PDF Ink Annotation. (Free Drawing)
/// Lines are automatically transformed when the boundingBox is changed.
@interface PSPDFInkAnnotation : PSPDFAnnotation

/// Designated initializer.
- (id)init;

/// Array of lines (which is a array of CGPoint's)
@property (nonatomic, copy) NSArray *lines;

/// Array of UIBezierPath (a cached version of lines for faster drawing)
@property (nonatomic, copy) NSArray *paths;

/// Rebuilds paths using the data in lines.
- (void)rebuildPaths;

/// Generate new line array by applying transform.
/// This is used internally when boundingBox is changed.
- (NSArray *)copyLinesByApplyingTransform:(CGAffineTransform)transform;

@end
