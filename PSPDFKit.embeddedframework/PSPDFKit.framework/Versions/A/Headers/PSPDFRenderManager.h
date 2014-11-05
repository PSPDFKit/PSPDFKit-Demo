//
//  PSPDFRenderManager.h
//  PSPDFKit
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import "PSPDFPlugin.h"

extern NSString *const PSPDFPageRendererPageInfoKey; // The `PSPDFPageInfo` object containing page info.

@class PSPDFAnnotation, PSPDFRenderQueue;

// Abstract interface for a page renderer.
@protocol PSPDFPageRenderer <PSPDFPlugin>

// Currently `options` contains `PSPDFPageRendererPageInfoKey`.
- (BOOL)drawPage:(NSUInteger)page inContext:(CGContextRef)context withOptions:(NSDictionary *)options error:(NSError *__autoreleasing*)error;

@optional

// Renders annotation appearance streams.
- (BOOL)renderAppearanceStream:(PSPDFAnnotation *)annotation inContext:(CGContextRef)context error:(NSError *__autoreleasing*)error;

@end

@class PSPDFPageInfo;

extern NSString *const PSPDFRenderPageColorKey;            // Multiplies a color used to color a page.
extern NSString *const PSPDFRenderContentOpacityKey;       // Opacity of the pdf content can be adjusted.
extern NSString *const PSPDFRenderInvertedKey;             // Inverts the rendering output. Default is NO.
extern NSString *const PSPDFRenderInterpolationQualityKey; // Set custom interpolation quality. Defaults to kCGInterpolationHigh.
extern NSString *const PSPDFRenderSkipPageContentKey;      // Set to YES to NOT draw page content. (Use to just draw an annotation)
extern NSString *const PSPDFRenderOverlayAnnotationsKey;   // Set to YES to render annotations that have isOverlay = YES set.
extern NSString *const PSPDFRenderSkipAnnotationArrayKey;  // Skip rendering of any annotations that are in this array.
extern NSString *const PSPDFRenderIgnorePageClipKey;       // If YES, will draw outside of page area.
extern NSString *const PSPDFRenderAllowAntiAliasingKey;    // Enabled/Disables antialiasing. Defaults to YES.
extern NSString *const PSPDFRenderBackgroundFillColorKey;  // Allows custom render color. Default is white.
extern NSString *const PSPDFRenderPDFBoxKey;               // Allows custom PDF box (if pageInfo is nil)
extern NSString *const PSPDFRenderDrawBlockKey;            // Allow custom content rendering after the PDF. `PSPDFRenderDrawBlock`.

typedef void (^PSPDFRenderDrawBlock)(CGContextRef context, NSUInteger page, CGRect cropBox, NSUInteger rotation, NSDictionary *options);

/// The PDF render mananger coordinates the PDF renderer used.
@protocol PSPDFRenderManager <NSObject>

/// Setup the graphics context to the current PDF.
- (void)setupGraphicsContext:(CGContextRef)context rectangle:(CGRect)displayRectangle pageInfo:(PSPDFPageInfo *)pageInfo;

/// The render queue.
@property (nonatomic, strong, readonly) PSPDFRenderQueue *renderQueue;

/// Returns the name of the current PDF renderer.
@property (nonatomic, copy, readonly) NSDictionary *rendererInfo;

/// Allows to set a custom renderer.
/// @note PSPDFKit will find custom renderers automatically (classes that implement <PSPDFPageRenderer> and use the one with the highest plugin priority)
/// If this is set to nil, PSPDFKit will fall back to the default core graphics renderer.
@property (atomic, strong) id<PSPDFPageRenderer> renderer;

@end
