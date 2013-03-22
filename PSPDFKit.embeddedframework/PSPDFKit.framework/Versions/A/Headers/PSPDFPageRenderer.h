//
//  PSPDFPageRenderer.h
//  PSPDFKit
//
//  Copyright 2011-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFPageInfo, PSPDFAnnotation;

// PDF rendering options.
extern NSString *const kPSPDFPageColor;               // Multiplies a color used to color a page.
extern NSString *const kPSPDFContentOpacity;          // Opacity of the pdf content can be adjusted.
extern NSString *const kPSPDFInvertRendering;         // Inverts the rendering output. Default is NO.
extern NSString *const kPSPDFInterpolationQuality;    // Set custom interpolation quality. Defaults to kCGInterpolationHigh.
extern NSString *const kPSPDFDisablePageRendering;    // Set to YES to NOT draw page content. (Use to just draw an annotation)
extern NSString *const kPSPDFRenderOverlayAnnotations;// Set to YES to render annotations that have isOverlay = YES set.
extern NSString *const kPSPDFIgnorePageClip;          // If YES, will draw outside of page area.
extern NSString *const kPSPDFAllowAntiAliasing;       // Enabled/Disables antialiasing. Defaults to YES.
extern NSString *const kPSPDFBackgroundFillColor;     // Allows custom render color. Default is white.
extern NSString *const kPSPDFPDFBox;                  // Allows custom PDF box (if pageInfo is nil)

/// PDF rendering code.
@interface PSPDFPageRenderer : NSObject

/// Setup the graphics context to the current PDF.
+ (void)setupGraphicsContext:(CGContextRef)context inRectangle:(CGRect)displayRectangle pageInfo:(PSPDFPageInfo *)pageInfo;

/// Renders a page inside a rectangle. Set context CTM and ClipRect to control rendering.
/// Returns the renderingRectangle.
+ (CGRect)renderPageRef:(CGPDFPageRef)page inContext:(CGContextRef)context inRectangle:(CGRect)rectangle pageInfo:(PSPDFPageInfo *)pageInfo withAnnotations:(NSArray *)annotations options:(NSDictionary *)options;

/// Render a page; defined by point and zoom. Use zoom=100 and point = CGPointMake(0, 0) for defaults.
+ (CGSize)renderPage:(CGPDFPageRef)page inContext:(CGContextRef)context atPoint:(CGPoint)point withZoom:(float)zoom pageInfo:(PSPDFPageInfo *)pageInfo withAnnotations:(NSArray *)annotations options:(NSDictionary *)options;

/// Renders a particular appearance stream (A PDF within a PDF) into a context.
/// Will return NO if rendering failed.
+ (BOOL)renderAppearanceStream:(PSPDFAnnotation *)annotation inContext:(CGContextRef)context;

@end
