//
//  PSPDFLineAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFAnnotation.h"

typedef NS_ENUM(NSInteger, PSPDFLineEndType) {
    PSPDFLineEndTypeNone,
    PSPDFLineEndTypeSquare,
    PSPDFLineEndTypeCircle,
    PSPDFLineEndTypeDiamond,
    PSPDFLineEndTypeOpenArrow,
    PSPDFLineEndTypeClosedArrow,
    PSPDFLineEndTypeButt,
    PSPDFLineEndTypeReverseOpenArrow,
    PSPDFLineEndTypeReverseClosedArrow,
    PSPDFLineEndTypeSlash
};

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

/// Transforms line enumeration <-> line strings (PDF reference).
+ (NSValueTransformer *)lineEndTypeTransformer;

@end
