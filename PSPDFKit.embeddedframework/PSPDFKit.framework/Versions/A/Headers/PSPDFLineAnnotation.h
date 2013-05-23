//
//  PSPDFLineAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAnnotation.h"
#import "PSPDFLineHelper.h"

/// PDF Line annotation.
@interface PSPDFLineAnnotation : PSPDFAnnotation

/// Starting point.
@property (nonatomic, assign) CGPoint point1;

/// End point.
@property (nonatomic, assign) CGPoint point2;

/// Start line type.
@property (nonatomic, assign) PSPDFLineEndType lineEnd1;

/// End line type.
@property (nonatomic, assign) PSPDFLineEndType lineEnd2;

/// By default, setting the boundingBox will transform the line.
/// Use this setter to manually change the boundingBox without changing the line.
- (void)setBoundingBox:(CGRect)boundingBox transformLine:(BOOL)transformLine;

/// Transforms line end type <-> line end string (PDF reference).
+ (NSValueTransformer *)lineEndTypeTransformer;

@end
