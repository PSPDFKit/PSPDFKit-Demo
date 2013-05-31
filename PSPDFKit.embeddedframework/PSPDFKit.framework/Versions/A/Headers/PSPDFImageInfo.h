//
//  PSPDFImageInfo.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

@class PSPDFDocument;

/// Defines the position if an image in the PDF.
@interface PSPDFImageInfo : NSObject

@property (nonatomic, copy)   NSString *imageID;
@property (nonatomic, assign) int pixelWidth;
@property (nonatomic, assign) int pixelHeight;
@property (nonatomic, assign) int bitsPerComponent;
@property (nonatomic, assign) double displayWidth;
@property (nonatomic, assign) double displayHeight;
@property (nonatomic, assign) double horizontalResolution;
@property (nonatomic, assign) double verticalResolution;
@property (nonatomic, assign) CGAffineTransform ctm; // global transform state.
@property (nonatomic, assign, readonly) CGPoint *vertices;

@property (atomic,    weak)   PSPDFDocument *document;
@property (nonatomic, assign) NSUInteger page;

/// Hit-Testing.
- (BOOL)isPointInImage:(CGPoint)point;

/// Rect that spans the 4 points.
- (CGRect)boundingBox;

/// The actual image. Will be extracted on the fly. Might have other dimensions than the displayed dimensions.
- (UIImage *)imageWithError:(NSError **)error;

/// Some PDF images are in CMYK color space, which is not a supported encoding.
/// (UIImageJPEGRepresentation will return nil in that case)
/// This method checks against this case and converts the image into RGB color space.
- (UIImage *)imageInRGBColorSpaceWithError:(NSError **)error;

@end
