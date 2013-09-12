//
//  PSPDFPageRenderer.h
//  PSPDFKit
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"

@class PSPDFPageInfo, PSPDFAnnotation;

// PDF rendering options.
extern NSString *const PSPDFRenderPageColor;               // Multiplies a color used to color a page.
extern NSString *const PSPDFRenderContentOpacity;          // Opacity of the pdf content can be adjusted.
extern NSString *const PSPDFRenderInverted;                // Inverts the rendering output. Default is NO.
extern NSString *const PSPDFRenderInterpolationQuality;    // Set custom interpolation quality. Defaults to kCGInterpolationHigh.
extern NSString *const PSPDFRenderSkipPageContent;         // Set to YES to NOT draw page content. (Use to just draw an annotation)
extern NSString *const PSPDFRenderOverlayAnnotations;      // Set to YES to render annotations that have isOverlay = YES set.
extern NSString *const PSPDFRenderSkipAnnotationArray;     // Skip rendering of any annotations that are in this array.
extern NSString *const PSPDFRenderIgnorePageClip;          // If YES, will draw outside of page area.
extern NSString *const PSPDFRenderAllowAntiAliasing;       // Enabled/Disables antialiasing. Defaults to YES.
extern NSString *const PSPDFRenderBackgroundFillColor;     // Allows custom render color. Default is white.
extern NSString *const PSPDFRenderPDFBox;                  // Allows custom PDF box (if pageInfo is nil)

// Can be used to use a custom subclass of the PSPDFPageRenderer. Defaults to nil, which will use PSPDFPageRenderer.class.
// Set very early (in your AppDelegate) before you access PSPDFKit. Will be used to create the singleton.
extern Class PSPDFPageRendererClass;

/// PDF rendering code.
@interface PSPDFPageRenderer : NSObject

/// Access the style manager singleton.
+ (instancetype)sharedPageRenderer;

/// Setup the graphics context to the current PDF.
- (void)setupGraphicsContext:(CGContextRef)context inRectangle:(CGRect)displayRectangle pageInfo:(PSPDFPageInfo *)pageInfo;

/// Renders a page inside a rectangle. Set context CTM and ClipRect to control rendering.
/// Returns the renderingRectangle.
- (CGRect)renderPageRef:(CGPDFPageRef)page inContext:(CGContextRef)context inRectangle:(CGRect)rectangle pageInfo:(PSPDFPageInfo *)pageInfo withAnnotations:(NSArray *)annotations options:(NSDictionary *)options;

/// Render a page; defined by point and zoom. Use zoom=100 and point = CGPointMake(0, 0) for defaults.
- (CGSize)renderPage:(CGPDFPageRef)page inContext:(CGContextRef)context atPoint:(CGPoint)point withZoom:(double)zoom pageInfo:(PSPDFPageInfo *)pageInfo withAnnotations:(NSArray *)annotations options:(NSDictionary *)options;

/// Renders a particular appearance stream (A PDF within a PDF) into a context.
/// Will return NO if rendering failed.
- (BOOL)renderAppearanceStream:(PSPDFAnnotation *)annotation inContext:(CGContextRef)context error:(NSError **)error;

@end
