//
//  PSPDFConverter.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"


/// Get string from CGPDFDictionary.
extern inline NSString *PSPDFDictionaryGetString(CGPDFDictionaryRef pdfDict, NSString *key);

/// Get string from CGPDFArray.
extern inline NSString *PSPDFArrayGetString(CGPDFArrayRef pdfArray, size_t index);

/// Get the PDF object at the specific PDF path.
extern id PSPDFDictionaryGetObjectForPath(CGPDFDictionaryRef pdfDict, NSString *keyPath);

/// Convert a single PDF object to the corresponding CoreFoundation-object.
extern id PSPDFConvertPDFObject(CGPDFObjectRef objectRef);

/// Convert a PDF object but only if it can be converted to a string.
extern NSString *PSPDFConvertPDFObjectAsString(CGPDFObjectRef objectRef);

/// Converts a CGPDFDictionary into an NSDictionary.
extern NSDictionary *PSPDFConvertPDFDictionary(CGPDFDictionaryRef pdfDict);

/// Converts a CGPDFArray into an NSArray.
extern NSArray *PSPDFConvertPDFArray(CGPDFArrayRef pdfArray);

///////////////////////////////////////////////////////////////////////////////////////////

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

/// Helper that aligns rectables depending on PSPDFRectAlignment. (usually used to center)
CGRect PSPDFAlignRectangles(CGRect alignee, CGRect aligner, PSPDFRectAlignment alignment);

/// Alignment helper that allows offsets.
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

/// Builds a rect out of two CGPoints.
inline CGRect PSPDFCGRectFromPoints(CGPoint p1, CGPoint p2);

#define PSPDFDegreesToRadians(degrees) (degrees * M_PI / 180)

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
