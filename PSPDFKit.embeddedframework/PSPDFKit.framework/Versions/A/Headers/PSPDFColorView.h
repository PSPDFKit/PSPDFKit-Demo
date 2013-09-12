//
//  PSPDFColorView.h
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

typedef NS_ENUM(NSInteger, PSPDFColorViewBorderStyle) {
    PSPDFColorViewBorderStyleSingle = 0,
    PSPDFColorViewBorderStyleTop,
    PSPDFColorViewBorderStyleMiddle,
    PSPDFColorViewBorderStyleBottom,
    PSPDFColorViewBorderStyleSingleNoShadow // When run on iOS 7, no shadow will be rendered, regardless of the option set.
};

// Draws a shape with the set color.
@interface PSPDFColorView : UIControl

// Creates the view
+ (id)colorViewWithColor:(UIColor *)color borderStyle:(PSPDFColorViewBorderStyle)borderStyle;

// Current set color.
@property (nonatomic, strong) UIColor *color;

// Current border style. Defaults to PSPDFColorViewBorderStyleSingle.
@property (nonatomic, assign) PSPDFColorViewBorderStyle borderStyle;

// If enabled, transparent color will have a red cross line. Defaults to YES.
@property (nonatomic, assign) BOOL markTransparentColor;

// Animate selection.
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end
