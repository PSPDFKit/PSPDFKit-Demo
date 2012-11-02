//
//  UIColor+PSPDFKitAdditions.h
//  PSPDFKit
//
//  Copyright (c) 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@interface UIColor (PSPDFKitAdditions)

/// Given an array of floats, applies the rules described in the PDF 1.7 Reference (page 607) to derive a UIColor instance.
/// nil argument implies clear/transparent color.
/// returns nil if no color could be derived.
- (id)initWithCGPDFArray:(CGPDFArrayRef)arrayRef;

/// Searches for the "C" entry in the CGPDFDictionaryRef and calls initWithCGPDFArray.
- (id)initWithCGPDFDictionary:(CGPDFDictionaryRef)dictionaryRef;

- (UIColor *)pspdf_colorByMultiplyingByRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

- (UIColor *)pspdf_colorByMultiplyingBy:(CGFloat)value;

/// Returns name of the current color (compared against an internal database)
- (NSString *)pspdf_closestAnnotationColorName;

/// Return name closest compared to dictionary 'colorNames'
- (NSString *)pspdf_closestColorNameFromSelection:(NSDictionary *)colorNames;

/// Color that matches the system color for selection.
+ (UIColor *)pspdf_selectionColor;
+ (CGFloat)pspdf_selectionAlpha;

/// Property list support
+ (UIColor *)pspdf_colorFromPropertyRepresentation:(id)colorObject;
- (id)pspdf_propertyRepresentation;

/// Derived colors
- (UIColor *)pspdf_lightenedColor;
- (UIColor *)pspdf_darkenedColor;

// Ensures the underlying color space of the UIColor is RGB.
- (UIColor *)pspdf_colorInRGBColorSpace;

// Returns a UIColor by scanning the string for a hex number and passing that to +[UIColor pspdf_colorWithRGBHex:]
// Skips any leading whitespace and ignores any trailing characters
+ (UIColor *)pspdf_colorWithHexString:(NSString *)string;

+ (UIColor *)pspdf_colorWithRGBHex:(UInt32)hex allowTransparancy:(BOOL)allowTransparancy;

@end
