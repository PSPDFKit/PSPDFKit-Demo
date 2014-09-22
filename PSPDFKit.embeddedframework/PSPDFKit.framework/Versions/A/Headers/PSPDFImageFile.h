//
//  PSPDFImageFile.h
//  PSPDFKit
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import "PSPDFModernizer.h"

/// The `PSPDFImageFile` class can be used to load images with memory consumption in mind.
/// It decouples the actual `UIImage` from its file representation, allowing you to release most of
/// the memory while making it easy to reload the image data if necessary.
@interface PSPDFImageFile : NSObject <NSDiscardableContent>

/// @name Creating an Image File

/// Creates a new image file with a given path.
+ (instancetype)imageFileWithPath:(NSString *)path;

/// Creates a new image file with a given path.
- (instancetype)initWithPath:(NSString *)path NS_DESIGNATED_INITIALIZER;

/// @name Attributes

/// The underlying image. Only valid if `isContentDiscarded` is `NO`.
/// @warning Throws an exception if `isContentDiscarded` is `NO`.
@property (nonatomic, strong, readonly) UIImage *image;

/// The size of the image. Always valid.
@property (nonatomic, assign, readonly) CGSize imageSize;

/// The path of the underlying image.
@property (nonatomic, copy, readonly) NSString *path;

@end
