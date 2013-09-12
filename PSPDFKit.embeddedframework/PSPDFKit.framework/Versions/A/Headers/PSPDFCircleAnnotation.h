//
//  PSPDFCircleAnnotation.h
//  PSPDFKit
//
//  Copyright 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAnnotation.h"

/// The PDF Circle annotations (PDF 1.3) shall display an ellipse on the page.
@interface PSPDFCircleAnnotation : PSPDFAnnotation

/// Designated initializer.
- (id)init;

/// The path that represents the circle.
@property (nonatomic, strong, readonly) UIBezierPath *bezierPath;

@end
