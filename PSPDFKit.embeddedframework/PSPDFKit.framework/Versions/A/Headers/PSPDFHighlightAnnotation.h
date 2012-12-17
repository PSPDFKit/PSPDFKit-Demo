//
//  HighlightAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
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

/// Designated initializer.
- (id)initWithHighlightType:(PSPDFHighlightAnnotationType)annotationType;

/// Highlight subtype.
@property (nonatomic, assign) PSPDFHighlightAnnotationType highlightType;

/// Coordinates for highlight annotation (boxed CGRect's)
@property (nonatomic, strong) NSArray *rects;

/// Helper that will query the associated PSPDFDocument to get the highlighted content.
/// (Because we actually just write rects, it's not easy to get the underlying text)
- (NSString *)highlightedString;

/// Converts "Highlight" into PSPDFHighlightAnnotationHighlight, etc
+ (PSPDFHighlightAnnotationType)highlightTypeFromTypeString:(NSString *)typeString;

@end
