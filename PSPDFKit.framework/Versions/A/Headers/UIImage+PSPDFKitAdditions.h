//
//  UIImage+PSPDFKitAdditions.h
//  PSPDFKit
//
//  Created by Matt Gemmell on 20/08/2008.
//  Copyright 2008 Instinctive Code.
//  Heavily fixed and modified by Peter Steinberger 24/04/2010
//
// http://mattgemmell.com/2010/07/05/mgimageutilities

#import <UIKit/UIKit.h>

@interface UIImage (PSPDFKitAdditions)

typedef enum {
    PSPDFImageResizeCrop,	// analogous to UIViewContentModeScaleAspectFill, i.e. "best fit" with no space around.
    PSPDFImageResizeCropStart,
    PSPDFImageResizeCropEnd,
    PSPDFImageResizeScale	// analogous to UIViewContentModeScaleAspectFit, i.e. scale down to fit, leaving space around if necessary.
} PSPDFImageResizingMethod;

// modified by @steipete
- (UIImage *)pspdf_imageToFitSize:(CGSize)fitSize method:(PSPDFImageResizingMethod)resizeMethod honorScaleFactor:(BOOL)honorScaleFactor;


// simple image cache that is used to display thumbnails
// it's cleared as long as a PSPDFViewController is open, on a memory warning
// if you use this on your own, it's advised to put [UIImage pspdf_clearCache] in yout AppDelegate's applicationDidReceiveMemoryWarning

+ (id)pspdf_cachedImageWithContentsOfFile:(NSString *)path;
+ (void)pspdf_clearCache;
+ (UIImage*)pspdf_imageWithContentsOfResolutionIndependentFile:(NSString *)path;
- (id)initWithContentsOfResolutionIndependentFile_pspdf:(NSString *)path;

@end
