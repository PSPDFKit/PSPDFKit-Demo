//
//  PSPDFColorView.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

typedef NS_ENUM(NSInteger, PSPDFColorViewBorderStyle) {
    PSPDFColorViewBorderStyleSingle = 0,
    PSPDFColorViewBorderStyleTop,
    PSPDFColorViewBorderStyleMiddle,
    PSPDFColorViewBorderStyleBottom,
    PSPDFColorViewBorderStyleSingleNoShadow
};

// Draws a shape with the set color.
@interface PSPDFColorView : UIControl

// Creates the view
+ (id)colorViewWithColor:(UIColor *)color borderStyle:(PSPDFColorViewBorderStyle)borderStyle;

// Current set color.
@property (nonatomic, strong) UIColor *color;

// Current border style. Defaults to PSPDFColorViewBorderStyleSingle.
@property (nonatomic, assign) PSPDFColorViewBorderStyle borderStyle;

// Animate selection.
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end
