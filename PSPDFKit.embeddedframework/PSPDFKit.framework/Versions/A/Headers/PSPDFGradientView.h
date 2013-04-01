//
//  PSPDFGradientView.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

/// Display a gradient.
/// Because we override drawRect here, using backgroundColor will not allow cornerRadius.
/// Use colors with a single color instead.
@interface PSPDFGradientView : UIView

typedef NS_ENUM(NSInteger, PSPDFGradientViewDirection) {
    PSPDFGradientViewDirectionHorizontal,
    PSPDFGradientViewDirectionVertical
};

/// Gradient direction. Defaults to PSPDFGradientViewDirectionHorizontal.
@property (nonatomic, assign) PSPDFGradientViewDirection direction;

/// Gradient colors. One color (flat) is also supported.
@property (nonatomic, copy) NSArray *colors;

/// Gradient location. Array of NSNumber objects that define the location of each color.
/// Defaults to nil; which is a uniform spread.
@property (nonatomic, copy) NSArray *locations;

@end
