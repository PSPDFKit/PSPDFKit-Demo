//
//  PSCColoredHighlightAnnotation.m
//  PSPDFCatalog
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import "PSCColoredHighlightAnnotation.h"

@implementation PSCColoredHighlightAnnotation

- (void)setType:(PSPDFHighlightAnnotationType)highlightType withDefaultColor:(BOOL)useDefaultColor {
    [super setType:highlightType withDefaultColor:useDefaultColor];

    if (highlightType == PSPDFHighlightAnnotationHighlight) {
        self.color = [UIColor colorWithRed:0.000 green:0.405 blue:1.000 alpha:0.470];
    }
}

@end
