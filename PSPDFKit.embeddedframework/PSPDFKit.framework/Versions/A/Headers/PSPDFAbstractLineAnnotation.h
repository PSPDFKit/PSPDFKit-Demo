//
//  PSPDFAbstractLineAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAnnotation.h"
#import "PSPDFLineHelper.h"

// Common methods for Line and PolyLine.
@interface PSPDFAbstractLineAnnotation : PSPDFAnnotation

/// Starting line end type.
@property (nonatomic, assign) PSPDFLineEndType lineEnd1;

/// Ending line end type.
@property (nonatomic, assign) PSPDFLineEndType lineEnd2;

/// The path of the line.
@property (nonatomic, copy, readonly) UIBezierPath *bezierPath;

/// By default, setting the `boundingBox` will transform the annotation.
/// Use this setter to manually change the boundingBox without changing the points.
- (void)setBoundingBox:(CGRect)boundingBox transformPoints:(BOOL)transformPoints;

@end
