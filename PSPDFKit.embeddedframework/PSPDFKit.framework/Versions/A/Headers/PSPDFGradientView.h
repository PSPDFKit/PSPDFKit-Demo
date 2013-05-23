//
//  PSPDFGradientView.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
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
