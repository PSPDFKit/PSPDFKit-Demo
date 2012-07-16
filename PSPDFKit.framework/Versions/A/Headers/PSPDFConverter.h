//
//  PSPDFConverter.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

typedef NS_ENUM(NSInteger, PSPDFRectAlignment) {
    PSPDFRectAlignCenter = 0,
    PSPDFRectAlignTop,
    PSPDFRectAlignTopLeft,
    PSPDFRectAlignTopRight,
    PSPDFRectAlignLeft,
    PSPDFRectAlignBottom,
    PSPDFRectAlignBottomLeft,
    PSPDFRectAlignBottomRight,
    PSPDFRectAlignRight
};

/// Returns scale to fit a size within another size.
CGFloat PSPDFScaleForSizeWithinSize(CGSize targetSize, CGSize boundsSize);

/// Returns scale to fit a size within another size, with optional zooming.
CGFloat PSPDFScaleForSizeWithinSizeWithOptions(CGSize targetSize, CGSize boundsSize, BOOL zoomMinimalSize, BOOL fitToWidthEnabled);

/// helper to calculate new size for specific scale and size.
CGSize PSPDFSizeForScale(CGSize size, CGFloat scale);

/// Helper that alligns rectables depending on PSPDFRectAlignment. (usually used to center)
CGRect PSPDFAlignRectangles(CGRect alignee, CGRect aligner, PSPDFRectAlignment alignment);

CGRect PSPDFAlignSizeWithinRectWithOffset(CGSize targetSize, CGRect bounds, CGFloat widthOffset, CGFloat heightOffset, PSPDFRectAlignment alignment);

/// Apply rotation to specific rect
CGRect PSPDFApplyRotationToRect(CGRect pageRect, NSInteger rotation);

/// Get the affine transform for specific pageRect and rotation.
CGAffineTransform PSPDFGetTransformFromPageRectAndRotation(CGRect pageRect, NSInteger rotation);

/// Convert a view point to a pdf point. bounds is from the view (usually PSPDFPageView.bounds)
CGPoint PSPDFConvertViewPointToPDFPoint(CGPoint viewPoint, CGRect cropBox, NSUInteger rotation, CGRect bounds);

/// Convert a pdf point to a view point.
CGPoint PSPDFConvertPDFPointToViewPoint(CGPoint pdfPoint, CGRect cropBox, NSUInteger rotation, CGRect bounds);

/// Convert a pdf rect to a normalized view rect.
CGRect PSPDFConvertPDFRectToViewRect(CGRect pdfRect, CGRect cropBox, NSUInteger rotation, CGRect bounds);

/// Convert a view rect to a normalized pdf rect
CGRect PSPDFConvertViewRectToPDFRect(CGRect viewRect, CGRect cropBox, NSUInteger rotation, CGRect bounds);

/// Normalizes a rect. PDF rect's might have negative width/height, this turns them around.
inline CGRect PSPDFNormalizeRect(CGRect rect);

///////////////////////////////////////////////////////////////////////////////////////////

/// Convert RGB to HSV colorspace
void PSPDFRGBtoHSV(float r, float g, float b, float* h, float* s, float* v);

/// Convert from RGB to HSB colorspace
extern void PSPDFRGBtoHSB(float r, float g, float b, float *h, float *s, float *v);

/// Convert from HSB to RGB colorspace
extern void PSPDFHSBtoRGB(float *r, float *g, float *b, float h, float s, float v);

/// Convert points to a spline path.
extern UIBezierPath *PSPDFSplinePathFromPoints(CGPoint p1, CGPoint p2, CGPoint p3, CGPoint p4, int divisions);

/// Convert point array to a bezier path.
UIBezierPath *PSPDFSplineWithPointArray(NSArray *pointArray, CGFloat lineWidth);

///////////////////////////////////////////////////////////////////////////////////////////

extern inline NSString *PSPDFCopyStringFromPDFDict(CGPDFDictionaryRef pdfDict, NSString *key);
extern inline NSString *PSPDFCopyNameFromPDFDict(CGPDFDictionaryRef pdfDict, NSString *key);

/// Convert a single pdf object to the corresponding CoreFoundation-object.
extern inline id PSPDFCopyPDFObject(CGPDFObjectRef objectRef);

/// Same as PSPDFCopyPDFObject, but returns [NSNull null] instead of nil.
extern inline id PSPDFCopyPDFObjectOrNSNull(CGPDFObjectRef objectRef);

/// Converts a CGPDFDictionary into a NSDictionary.
extern NSDictionary *PSPDFConvertPDFDictionary(CGPDFDictionaryRef pdfDict);

/// Converts a CGPDFArray into an NSArray.
extern NSArray *PSPDFCopyPDFArray(CGPDFArrayRef pdfArray);
