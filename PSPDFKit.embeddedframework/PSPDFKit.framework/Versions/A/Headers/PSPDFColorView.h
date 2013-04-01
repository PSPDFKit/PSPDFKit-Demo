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
};

// Draws a shape with the set color.
@interface PSPDFColorView : UIControl

+ (id)colorViewWithColor:(UIColor *)color borderStyle:(PSPDFColorViewBorderStyle)borderStyle;

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) PSPDFColorViewBorderStyle borderStyle;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end
