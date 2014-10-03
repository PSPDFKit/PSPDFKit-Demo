//
//  PSPDFImageInfo.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

@class PSPDFDocumentProvider;

/// Defines the position if an image in the PDF.
@interface PSPDFImageInfo : NSObject <NSCopying, NSSecureCoding>

/// Init object with page and rotation.
- (instancetype)initWithImageID:(NSString *)imageID
                      pixelSize:(CGSize)pixelSize
               bitsPerComponent:(NSUInteger)bitsPerComponent
                      transform:(CGAffineTransform)transform
                       vertices:(CGPoint *)vertices
                           page:(NSUInteger)page
               documentProvider:(PSPDFDocumentProvider *)documentProvider NS_DESIGNATED_INITIALIZER;

// The document-global image identifier.
@property (nonatomic, copy,   readonly) NSString *imageID;

// The pixel size of the image.
@property (nonatomic, assign, readonly) CGSize pixelSize;

// The raw image bits per component.
@property (nonatomic, assign, readonly) NSUInteger bitsPerComponent;

// Transform that is applied to the image.
@property (nonatomic, assign, readonly) CGAffineTransform transform; // global transform state.

// The 4 points that define the image.
@property (nonatomic, assign, readonly) CGPoint *vertices; // [4];

// Associated document provider and page.
@property (nonatomic, weak,   readonly) PSPDFDocumentProvider *documentProvider;
@property (nonatomic, assign, readonly) NSUInteger page; // relative to `documentProvider`

// Calculated properties
@property (nonatomic, assign, readonly) CGSize displaySize;
@property (nonatomic, assign, readonly) CGFloat horizontalResolution;
@property (nonatomic, assign, readonly) CGFloat verticalResolution;

/// Hit-Testing.
- (BOOL)hitTest:(CGPoint)point;

/// Equality checking.
- (BOOL)isEqualToImageInfo:(PSPDFImageInfo *)otherImageInfo;

/// Rect that spans the 4 points.
- (CGRect)boundingBox;

/// The actual image. Will be extracted on the fly. Might have other dimensions than the displayed dimensions.
- (UIImage *)imageWithError:(NSError *__autoreleasing*)error;

/// Some PDF images are in CMYK color space, which is not a supported encoding.
/// (`UIImageJPEGRepresentation` will return nil in that case)
/// This method checks against this case and converts the image into RGB color space.
- (UIImage *)imageInRGBColorSpaceWithError:(NSError *__autoreleasing*)error;

@end
