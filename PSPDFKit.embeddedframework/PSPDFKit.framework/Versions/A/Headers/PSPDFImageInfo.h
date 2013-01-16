//
//  PSPDFImageInfo.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PSPDFDocument;

@interface PSPDFImageInfo : NSObject

@property (nonatomic, copy) NSString* imageID;
@property (nonatomic, assign) int pixelWidth;
@property (nonatomic, assign) int pixelHeight;
@property (nonatomic, assign) int bitsPerComponent;
@property (nonatomic, assign) double displayWidth;
@property (nonatomic, assign) double displayHeight;
@property (nonatomic, assign) double horizontalResolution;
@property (nonatomic, assign) double verticalResolution;
@property (nonatomic, readonly, assign) CGPoint *vertices;

@property (atomic, weak) PSPDFDocument *document;
@property (nonatomic, assign) NSUInteger page;

- (BOOL)isPointInImage:(CGPoint)point;

/// Rect that spans the 4 points.
- (CGRect)boundingBox;

/// The actual image. Will be extracted on the fly. Might have other dimensions than the displayed dimensions.
- (UIImage *)image;

/// Some PDF images are in CMYK color space, which is not a supported encoding.
/// (UIImageJPEGRepresentation will return nil in that case)
/// This method checks against this case and converts the image into RGB color space.
- (UIImage *)imageInRGBColorSpace;


@end
