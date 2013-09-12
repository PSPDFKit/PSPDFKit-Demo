//
//  PSPDFUnderlineAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAbstractTextOverlayAnnotation.h"

/// Text Underline Annotation
///
/// @warning If you programmatically create a underline annotation, you need to both set the boundingBox AND the rects array. The rects array contains boxed variants of CGRect (NSValue).
@interface PSPDFUnderlineAnnotation : PSPDFAbstractTextOverlayAnnotation

/// Designated initializer.
- (id)init;

@end
