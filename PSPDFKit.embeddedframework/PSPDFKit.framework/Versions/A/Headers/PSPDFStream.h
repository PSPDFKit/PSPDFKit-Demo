//
//  PSPDFStream.h
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
#import "PSPDFStreamProvider.h"
#import "PSPDFMacros.h"

@class PSPDFDocument;

/// Allows conversion of a `CGPDFStreamRef` to a file object.
/// A Stream has dictionary data and stream data. Might be anything (like page commands, a video, an image)
@interface PSPDFStream : NSObject <NSCopying>

/// Get the stream from an object that can provide a stream.
/// `options` is currently unused.
+ (PSPDFStream *)streamFromStreamProvider:(id<PSPDFStreamProvider>)streamProvider options:(NSDictionary *)options error:(NSError *__autoreleasing*)error;

/// @note `streamRef` shall not be nil. Initializer will return nil in that case.
- (instancetype)initWithStreamRef:(CGPDFStreamRef)streamRef NS_DESIGNATED_INITIALIZER;

/// Low level stream reference.
/// @warning Only valid as long as the parent `CGPDFDocument` is not closed.
@property (nonatomic, assign, readonly) CGPDFStreamRef streamRef;

/// Stream dictionary.
@property (nonatomic, copy, readonly) NSDictionary *dictionary;

/// Returns the converted image, if any.
/// @note If CGPDFDataFormat is `CGPDFDataFormatJPEGEncoded`, we can extract the image.
@property (nonatomic, copy, readonly) UIImage *image;

/// Returns the stream length.
@property (nonatomic, assign, readonly) NSUInteger length;

/// The `matrix` if one is defined in the stream dictionary. Will return the identity matrix if `Matrix` is not set.
@property (nonatomic, assign, readonly) CGAffineTransform matrix;

/// Returns the annotation transform matrix based on the stream bounding box, matrix and `rect`.
/// @note See PDF Reference 1.7, 12.5.5: Algorithm: Appearance streams.
/// `rect` usually is the annotation `boundingBox` property.
- (CGAffineTransform)transformMatrixWithRect:(CGRect)rect;

/// Stream data. Format will be returned.
- (NSData *)dataUsingFormat:(out CGPDFDataFormat *)dataFormat;

/// Text representation. Only attempt a conversion if you're sure this is text, will be garbage if content is an image.
- (NSString *)stringValue;


/// @name File Management

/// File URL from the converted stream.
/// @warning This might be slow for large streams.
- (NSURL *)fileURLWithAssetName:(NSString *)assetName UID:(NSString *)UID page:(NSUInteger)page error:(NSError *__autoreleasing*)error;

/// File URL with generic path. Path needs to be writable and any directory needs to be created.
///
/// @warning This might be slow for large streams.
- (NSURL *)fileURLWithPath:(NSString *)path error:(NSError *__autoreleasing*)error;

@end
