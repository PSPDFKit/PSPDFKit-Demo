//
//  PSPDFConverter.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFStream;

/// Get string from CGPDFDictionary.
extern inline NSString *PSPDFDictionaryGetString(CGPDFDictionaryRef pdfDict, NSString *key);
extern inline NSString *PSPDFDictionaryGetStringC(CGPDFDictionaryRef pdfDict, const char *key);

/// Get string from CGPDFArray.
extern inline NSString *PSPDFArrayGetString(CGPDFArrayRef pdfArray, size_t index);

/// Get the PDF object at the specific PDF path. Can access arrays or streams with #0 syntax.
extern id PSPDFDictionaryGetObjectForPath(CGPDFDictionaryRef pdfDict, NSString *keyPath);

/// Like PSPDFDictionaryGetObjectForPath, but type safe.
id PSPDFDictionaryGetObjectForPathOfType(CGPDFDictionaryRef pdfDict, NSString *keyPath, Class returnClass);
extern PSPDFStream *PSPDFDictionaryGetStreamForPath(CGPDFDictionaryRef pdfDict, NSString *keyPath);
extern NSNumber *PSPDFDictionaryGetNumberForPath(CGPDFDictionaryRef pdfDict, NSString *keyPath);
extern NSString *PSPDFDictionaryGetStringForPath(CGPDFDictionaryRef pdfDict, NSString *keyPath);
extern NSArray *PSPDFDictionaryGetArrayForPath(CGPDFDictionaryRef pdfDict, NSString *keyPath);
extern NSDictionary *PSPDFDictionaryGetDictionaryForPath(CGPDFDictionaryRef pdfDict, NSString *keyPath);

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
extern CGFloat PSPDFScaleForSizeWithinSize(CGSize targetSize, CGSize boundsSize);

/// Returns scale to fit a size within another size, with optional zooming.
extern CGFloat PSPDFScaleForSizeWithinSizeWithOptions(CGSize targetSize, CGSize boundsSize, BOOL zoomMinimalSize, BOOL fitToWidthEnabled);

/// Helper to calculate new size for specific scale and size.
extern CGSize PSPDFSizeForScale(CGSize size, CGFloat scale);

/// Helper that aligns rectangles depending on PSPDFRectAlignment. (usually used to center)
extern CGRect PSPDFAlignRectangles(CGRect alignee, CGRect aligner, PSPDFRectAlignment alignment);

/// Alignment helper that allows offsets.
extern CGRect PSPDFAlignSizeWithinRectWithOffset(CGSize targetSize, CGRect bounds, CGFloat widthOffset, CGFloat heightOffset, PSPDFRectAlignment alignment);

// Divides a source rectangle into two component rectangles, skipping the given amount of padding in between them.
void PSPDFRectDivideWithPadding(CGRect rect, CGRect *slicePtr, CGRect *remainderPtr, CGFloat sliceAmount, CGFloat padding, CGRectEdge edge);

/// Normalizes rotation values (returns something between 0 and 359)
extern NSUInteger PSPDFNormalizeRotation(NSInteger rotation);

/// Apply rotation to specific rect
extern CGRect PSPDFApplyRotationToRect(CGRect pageRect, NSInteger rotation);

/// Get the affine transform for specific pageRect and rotation.
extern CGAffineTransform PSPDFGetTransformFromPageRectAndRotation(CGRect pageRect, NSInteger rotation);

/// Convert a view point to a pdf point. bounds is from the view (usually PSPDFPageView.bounds)
extern CGPoint PSPDFConvertViewPointToPDFPoint(CGPoint viewPoint, CGRect cropBox, NSUInteger rotation, CGRect bounds);

/// Convert a pdf point to a view point.
extern CGPoint PSPDFConvertPDFPointToViewPoint(CGPoint pdfPoint, CGRect cropBox, NSUInteger rotation, CGRect bounds);

/// Convert a pdf rect to a normalized view rect.
extern CGRect PSPDFConvertPDFRectToViewRect(CGRect pdfRect, CGRect cropBox, NSUInteger rotation, CGRect bounds);

/// Convert a view rect to a normalized pdf rect
extern CGRect PSPDFConvertViewRectToPDFRect(CGRect viewRect, CGRect cropBox, NSUInteger rotation, CGRect bounds);

/// Normalizes a rect. PDF rect's might have negative width/height, this turns them around.
extern inline CGRect PSPDFNormalizeRect(CGRect rect);

/// Builds a rect out of two CGPoints.
extern inline CGRect PSPDFCGRectFromPoints(CGPoint p1, CGPoint p2);

#define PSPDFDegreesToRadians(degrees) (degrees * M_PI / 180)
#define PSPDFRadiansToDegrees(degrees) (degrees * (180 / M_PI))

///////////////////////////////////////////////////////////////////////////////////////////

/// Convert RGB to HSV colorspace
extern void PSPDFRGBtoHSV(float r, float g, float b, float* h, float* s, float* v);

/// Convert from RGB to HSB colorspace
extern void PSPDFRGBtoHSB(float r, float g, float b, float *h, float *s, float *v);

/// Convert from HSB to RGB colorspace
extern void PSPDFHSBtoRGB(float *r, float *g, float *b, float h, float s, float v);

/// Convert point array to a bezier path.
extern UIBezierPath *PSPDFSplineWithPointArray(NSArray *pointArray);
