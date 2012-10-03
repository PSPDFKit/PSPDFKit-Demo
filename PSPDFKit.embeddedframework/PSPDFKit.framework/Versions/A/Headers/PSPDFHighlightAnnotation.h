//
//  HighlightAnnotation.h
//  PSPDFKit
//
//  Copyright 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFAnnotation.h"

typedef NS_ENUM(NSInteger, PSPDFHighlightAnnotationType) {
    PSPDFHighlightAnnotationUnknown = 0,
    PSPDFHighlightAnnotationHighlight,
    PSPDFHighlightAnnotationUnderline,
    PSPDFHighlightAnnotationStrikeOut
};

/// Text Highlight Annotation (Highlight, StrikeOut, Underline)
/// Important! If you programmatically create a highlight annotation, you need to both set the boundingBox AND the rects array. (the rects array contains boxed variants of CGRect (NSValue))
@interface PSPDFHighlightAnnotation : PSPDFAnnotation

/// Highlight subtype.
@property (nonatomic, assign) PSPDFHighlightAnnotationType highlightType;

/// Coordinates for highlight annotation.
@property (nonatomic, strong) NSArray *rects;

- (id)initWithAnnotationDictionary:(CGPDFDictionaryRef)annotDict inAnnotsArray:(CGPDFArrayRef)annotsArray;

- (id)initWithType:(PSPDFHighlightAnnotationType)annotationType;

- (void)setType:(PSPDFHighlightAnnotationType)annotationType withDefaultColor:(BOOL)useDefaultColor;

/// Converts "Highlight" into PSPDFHighlightAnnotationHighlight, etc
+ (PSPDFHighlightAnnotationType)highlightTypeFromTypeString:(NSString *)typeString;

@end
