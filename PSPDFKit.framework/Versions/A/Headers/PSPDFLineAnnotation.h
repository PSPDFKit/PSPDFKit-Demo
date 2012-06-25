//
//  PSPDFLineAnnotation.h
//  PSPDFKit
//
//  Copyright 2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
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

@interface PSPDFLineAnnotation : PSPDFAnnotation

@property (nonatomic, assign) CGPoint point1;
@property (nonatomic, assign) CGPoint point2;

@property (nonatomic, assign) PSPDFLineEndType lineEnd1;
@property (nonatomic, assign) PSPDFLineEndType lineEnd2;

@end
