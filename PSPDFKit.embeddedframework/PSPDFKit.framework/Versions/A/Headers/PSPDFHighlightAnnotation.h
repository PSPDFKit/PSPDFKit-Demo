//
//  PSPDFHighlightAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFAnnotation.h"

typedef NS_ENUM(NSInteger, PSPDFHighlightAnnotationType) {
    PSPDFHighlightAnnotationUnknown,
    PSPDFHighlightAnnotationHighlight,
    PSPDFHighlightAnnotationUnderline,
    PSPDFHighlightAnnotationStrikeOut
};

/**
 * Text Highlight Annotation (Highlight, StrikeOut, Underline)
 *
 * @warning If you programmatically create a highlight annotation, you need to both set the boundingBox AND the rects array. The rects array contains boxed variants of CGRect (NSValue).
 */
@interface PSPDFHighlightAnnotation : PSPDFAnnotation

/// Initialize annotation with a highlight type. Designated initializer.
- (id)initWithHighlightType:(PSPDFHighlightAnnotationType)annotationType;

/// Highlight Type.
///
/// The highlight type is inferred from typeString and will not be serialized to disk.
/// Setting the highlight type will also update the typeString.
@property (nonatomic, assign) PSPDFHighlightAnnotationType highlightType;

/// Helper that will query the associated PSPDFDocument to get the highlighted content.
/// (Because we actually just write rects, it's not easy to get the underlying text)
- (NSString *)highlightedString;

/// Highlight Type String <-> PSPDFHighlightAnnotationType transformer.
///
/// Sample usage: PSPDFHighlightAnnotationType highlightType = [[self.class.highlightTypeTransformer transformedValue:self.typeString] integerValue];
+ (NSValueTransformer *)highlightTypeTransformer;

@end
