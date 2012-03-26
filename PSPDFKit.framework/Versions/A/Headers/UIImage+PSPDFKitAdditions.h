//
//  UIImage+PSPDFKitAdditions.h
//  PSPDFKit
//
//  Created by Matt Gemmell on 20/08/2008.
//  Heavily fixed and modified by Peter Steinberger
//  Copyright 2011 Peter Steinberger. All rights reserved.
//  (Copyright 2008 Instinctive Code)
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (PSPDFKitAdditions)

typedef enum {
    PSPDFImageResizeCrop,	// analogous to UIViewContentModeScaleAspectFill, i.e. "best fit" with no space around.
    PSPDFImageResizeCropStart,
    PSPDFImageResizeCropEnd,
    PSPDFImageResizeScale	// analogous to UIViewContentModeScaleAspectFit, i.e. scale down to fit, leaving space around if necessary.
} PSPDFImageResizingMethod;

/// Returns a new image that is resize to fitSize.
- (UIImage *)pspdf_imageToFitSize:(CGSize)fitSize method:(PSPDFImageResizingMethod)resizeMethod honorScaleFactor:(BOOL)honorScaleFactor;

/// Load images via path, looking automatically for a @2x option.
+ (UIImage*)pspdf_imageWithContentsOfResolutionIndependentFile:(NSString *)path;

/// Load images via path, looking automatically for a @2x option.
- (id)initWithContentsOfResolutionIndependentFile_pspdf:(NSString *)path;

/// Creates a new images that is already preloaded to draw on screen.
+ (UIImage *)pspdf_preloadedImageWithContentsOfFile:(NSString *)path;

/// Creates a new image that is optimized for the screen. (ARGB, not ABGR)
- (UIImage *)pspdf_preloadedImage;

/// Creates a new image that is eventually decompressed using libjpeg-turbo.
+ (UIImage *)pspdf_preloadedImageWithContentsOfFile:(NSString *)imagePath useJPGTurbo:(BOOL)useJPGTurbo;

/// Calculates scale for images.
+ (CGFloat)pspdf_scaleForImageSize:(CGSize)imageSize bounds:(CGSize)boundsSize;

/// Load images from the bundle.
+ (UIImage *)pspdf_imageNamed:(NSString *)imageName bundle:(NSString *)bundleName;

@end
