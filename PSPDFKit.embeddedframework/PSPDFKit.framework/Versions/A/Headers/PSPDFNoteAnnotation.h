//
//  PSPDFNoteAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFAnnotation.h"

// We extend the width/height of note annotation to make them easier touch targets.
extern CGSize kPSPDFNoteAnnotationViewFixedSize;

/// PDF Note (Text) Annotation.
@interface PSPDFNoteAnnotation : PSPDFAnnotation

/// Designated initializer.
- (id)init;

/// Note Icon name (see PSPDFKit.bundle for available icon names)
/// If set to zero, it will return to the default "Comment".
@property (nonatomic, copy) NSString *iconName;

/// Loads a matching image from the PSPDFKit.bundle.
- (UIImage *)noteImage;

/// Custom HitTest because we have custom width/height here.
- (BOOL)hitTest:(CGPoint)point withViewBounds:(CGRect)bounds;
- (CGRect)boundingBoxForPageViewBounds:(CGRect)pageBounds;

@end
