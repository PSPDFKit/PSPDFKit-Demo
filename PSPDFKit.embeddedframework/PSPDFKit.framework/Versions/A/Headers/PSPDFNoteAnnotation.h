//
//  PSPDFNoteAnnotation.h
//  PSPDFKit
//
//  Copyright 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFAnnotation.h"

/// PDF Note (Text) Annotation.
@interface PSPDFNoteAnnotation : PSPDFAnnotation

/// Icon name.
@property (nonatomic, strong) NSString *iconName;

/// Designated initializer.
- (id)initWithAnnotationDictionary:(CGPDFDictionaryRef)annotDict inAnnotsArray:(CGPDFArrayRef)annotsArray;

/// Custom HitTest because we have custom widht/height here.
- (BOOL)hitTest:(CGPoint)point withViewBounds:(CGRect)bounds;

@end
