//
//  PSPDFPageRenderer.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFPageInfo;

// PDF rendering options. kPSPDFIgnoreDisplaySettings is only honored when using the renderImageForPage method in PSPDFDocument.
extern NSString *kPSPDFIgnoreDisplaySettings; // Always draw pixels with a 1.0 scale.
extern NSString *kPSPDFPageColor;             // Multiplies a color used to color a page.
extern NSString *kPSPDFContentOpacity;        // Opacity of the pdf content can be ajusted.
extern NSString *kPSPDFInvertRendering;       // Inverts the rendering output.
extern NSString *kPSPDFInterpolationQuality;  // Set custom interpolation quality. Defaults to kCGInterpolationHigh.

/// PDF rendering code.
@interface PSPDFPageRenderer : NSObject

/// Renders a page inside a rectangle. Set context CTM and ClipRect to control rendering.
/// Returns the renderingRectangle.
+ (CGRect)renderPageRef:(CGPDFPageRef)page inContext:(CGContextRef)context inRectangle:(CGRect)rectangle pageInfo:(PSPDFPageInfo *)pageInfo withAnnotations:(NSArray *)annotations options:(NSDictionary *)options;

/// Render a page; defined by point and zoom. Use zoom=100 and point = CGPointMake(0, 0) for defaults.
+ (CGSize)renderPage:(CGPDFPageRef)page inContext:(CGContextRef)context atPoint:(CGPoint)point withZoom:(float)zoom pageInfo:(PSPDFPageInfo *)pageInfo withAnnotations:(NSArray *)annotations options:(NSDictionary *)options;

@end
