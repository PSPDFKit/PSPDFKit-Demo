//
//  PSPDFInkAnnotation.h
//  PSPDFKit
//
//  Copyright 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFAnnotation.h"

/// PDF Ink Annotation. (Free Drawing)
@interface PSPDFInkAnnotation : PSPDFAnnotation

/// Array of lines.
@property (nonatomic, strong) NSArray *lines;

/// Array of UIBezierPath.
@property (nonatomic, strong) NSArray *paths;

/// Designated initializer.
- (id)initWithAnnotationDictionary:(CGPDFDictionaryRef)annotDict inAnnotsArray:(CGPDFArrayRef)annotsArray;

/// Rebuilds paths using the data in lines.
- (void)rebuildPaths;

- (void)clearAllData;

- (void)clearCachedPaths;

@end
