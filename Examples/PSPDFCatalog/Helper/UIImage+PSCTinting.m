//
//  UIImage+PSCTinting.m
//  PSPDFCatalog
//
//  Copyright (c) 2013-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "UIImage+PSCTinting.h"

@implementation UIImage (PSCTinting)

- (UIImage *)psc_imageTintedWithColor:(UIColor *)color fraction:(CGFloat)fraction {
    if (color) {
        CGRect rect = (CGRect){CGPointZero, self.size};
        UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.f);
        [color set];
        UIRectFill(rect);
        [self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.f];

        if (fraction > 0.f) {
            [self drawInRect:rect blendMode:kCGBlendModeSourceAtop alpha:fraction];
        }
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        // Preserve accessibility label if set.
        if (self.accessibilityLabel) image.accessibilityLabel = self.accessibilityLabel;

        return image;
    }
    return self;
}

@end
