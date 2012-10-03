//
//  PSPDFGradientView.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

/// Display a gradient.
@interface PSPDFGradientView : UIView

typedef NS_ENUM(NSInteger, PSPDFGradientViewDirection) {
	PSPDFGradientViewDirectionHorizontal,
	PSPDFGradientViewDirectionVertical
};

/// Gradient direction. Defaults to PSPDFGradientViewDirectionHorizontal.
@property (nonatomic, assign) PSPDFGradientViewDirection direction;

/// Gradient colors.
@property (nonatomic, copy) NSArray *colors;

/// Gradient location. Array of NSNumber objects that define the location of each color.
/// Defaults to nil; which is a uniform spread.
@property (nonatomic, copy) NSArray *locations;

@end
