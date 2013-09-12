//
//  PSPDFAbstractTextOverlayAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAnnotation.h"

@interface PSPDFAbstractTextOverlayAnnotation : PSPDFAnnotation

/// Convenience initializer that creates a text annotation from glyphs.
/// Get the `pageRotationTransform` from [document pageInfoForPage:].pageRotationTransform.
+ (instancetype)textOverlayAnnotationWithGlyphs:(NSArray *)glyphs pageRotationTransform:(CGAffineTransform)pageRotationTransform;

/// Helper that will query the associated PSPDFDocument to get the highlighted content.
/// (Because we actually just write rects, it's not easy to get the underlying text)
- (NSString *)highlightedString;

@end
