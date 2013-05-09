//
//  PSPDFLineAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
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
