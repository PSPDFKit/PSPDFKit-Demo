//
//  UIColor+PSPDFKitAdditions.h
//  PSPDFKit
//
//  Copyright (c) 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIColor (PSPDFKitAdditions)

/// Given an array of floats, applies the rules described in the PDF 1.7 Reference (page 607) to derive a UIColor instance.
/// nil argument implies clear/transparent color.
/// returns nil if no color could be derived.
- (id)initWithCGPDFArray:(CGPDFArrayRef)realArray;

+ (UIColor *)colorWithCGPDFArray:(CGPDFArrayRef)realArray;

@end
