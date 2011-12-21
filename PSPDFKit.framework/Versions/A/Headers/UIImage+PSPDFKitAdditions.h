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

/// Loads a custom UIImage that keeps the image cache.
+ (UIImage *)pspdf_cachedImageForPath:(NSString *)path;

/// Loads a custom UIImage that keeps the image cache.
+ (UIImage *)pspdf_cachedImageForUrl:(NSURL *)url;

/// forces a image decompression, can be invoked off-screen in a thread.
- (void)pspdf_decompressImage;

/// calculates scale for images.
+ (CGFloat)pspdf_scaleForImageSize:(CGSize)imageSize bounds:(CGSize)boundsSize;

/// load images from the bundle.
+ (UIImage *)pspdf_imageNamed:(NSString *)imageName bundle:(NSString *)bundleName;

@end
