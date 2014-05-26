//
//  PSPDFPageRenderer.h
//  PSPDFKit
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
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

// Allow custom content rendering after the PDF. Type is `PSPDFRenderDrawBlock`.
extern NSString *const PSPDFRenderDrawBlockKey;

typedef void (^PSPDFRenderDrawBlock)(CGContextRef context, NSUInteger page, CGRect cropBox, NSUInteger rotation, NSDictionary *options);

/// PDF rendering code.
@interface PSPDFPageRenderer : NSObject

/// Access the page renderer singleton.
+ (instancetype)sharedPageRenderer;
+ (void)setSharedPageRenderer:(PSPDFPageRenderer *)pageRenderer;

/// Setup the graphics context to the current PDF.
- (void)setupGraphicsContext:(CGContextRef)context rectangle:(CGRect)displayRectangle pageInfo:(PSPDFPageInfo *)pageInfo;

/// Renders a page inside a rectangle. Set context CTM and clipRect to control rendering.
/// Returns the renderingRectangle.
- (CGRect)renderPageRef:(CGPDFPageRef)page inContext:(CGContextRef)context rectangle:(CGRect)rectangle pageInfo:(PSPDFPageInfo *)pageInfo annotations:(NSArray *)annotations options:(NSDictionary *)options;

/// Renders a page; defined by point and zoom. Use `zoom=100` and `point = CGPointMake(0.f, 0.f)` for defaults.
- (CGSize)renderPageRef:(CGPDFPageRef)page inContext:(CGContextRef)context atPoint:(CGPoint)point withZoom:(double)zoom pageInfo:(PSPDFPageInfo *)pageInfo annotations:(NSArray *)annotations options:(NSDictionary *)options;

/// Override to implement custom rendering techniques (using other renderers).
- (void)drawPDFPage:(CGPDFPageRef)pageRef inContext:(CGContextRef)context pageInfo:(PSPDFPageInfo *)pageInfo;

/// Renders a particular appearance stream (A PDF within a PDF) into a context.
/// Will return NO if rendering failed.
- (BOOL)renderAppearanceStream:(PSPDFAnnotation *)annotation inContext:(CGContextRef)context error:(NSError **)error;

@end
