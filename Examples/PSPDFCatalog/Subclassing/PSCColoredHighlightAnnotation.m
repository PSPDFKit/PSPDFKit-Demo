//
//  PSCColoredHighlightAnnotation.m
//  PSPDFCatalog
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
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
