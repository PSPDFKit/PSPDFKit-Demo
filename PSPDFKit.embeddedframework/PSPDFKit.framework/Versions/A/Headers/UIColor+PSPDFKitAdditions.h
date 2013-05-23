//
//  UIColor+PSPDFKitAdditions.h
//  PSPDFKit
//
//  Copyright (c) 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"

/// Returns a lighter and a darker color to make a gradient out of 'color'.
/// variance has to be > 0 and <= 1.
extern NSArray *PSPDFGradientColorsForColor(UIColor *color);

extern NSArray *PSPDFGradientColorsForColorWithOptions(UIColor *color, CGFloat variance[2], BOOL subsituteBlackWithYellow);

/// Compares colors
extern BOOL PSPDFIsColorAboutEqualToColor(UIColor *left, UIColor *right);

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

/// Color for guide helpers.
+ (UIColor *)pspdf_guideColor;

/// Color for detail elements in the grouped table view.
+ (UIColor *)pspdf_groupTableViewBlueColor;

/// Property list support
+ (UIColor *)pspdf_colorFromPropertyRepresentation:(id)colorObject;

- (NSString *)pspdf_stringFromColor;

/// Derived colors. Default delta is 0.1f.
- (UIColor *)pspdf_lightenedColor;

- (UIColor *)pspdf_lightenedColorWithDelta:(CGFloat)delta;

- (UIColor *)pspdf_darkenedColor;

- (UIColor *)pspdf_darkenedColorWithDelta:(CGFloat)delta;

// Ensures the underlying color space of the UIColor is RGB.
- (UIColor *)pspdf_colorInRGBColorSpace;

// Calculates the total brightness of the current color.
- (CGFloat)pspdf_brightness;

// Returns a UIColor by scanning the string for a hex number and passing that to +[UIColor pspdf_colorWithRGBHex:]
// Skips any leading whitespace and ignores any trailing characters
+ (UIColor *)pspdf_colorWithHexString:(NSString *)string;

+ (UIColor *)pspdf_colorWithRGBHex:(UInt32)hex allowTransparancy:(BOOL)allowTransparancy;

// Component access.
- (CGFloat)pspdf_alphaComponent;

@end

/// Convert RGB to HSV colorspace
extern void PSPDFRGBtoHSV(float r, float g, float b, float *h, float *s, float *v);

/// Convert from RGB to HSB colorspace
extern void PSPDFRGBtoHSB(float r, float g, float b, float *h, float *s, float *v);

/// Convert from HSB to RGB colorspace
extern void PSPDFHSBtoRGB(float *r, float *g, float *b, float h, float s, float v);
