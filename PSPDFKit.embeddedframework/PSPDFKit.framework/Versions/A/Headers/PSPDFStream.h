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

@class PSPDFDocument;

/// Allows conversion of a `CGPDFStreamRef` to a file object.
/// A Stream has dictionary data and stream data. Might be anything (like page commands, a video, an image)
@interface PSPDFStream : NSObject <NSCopying>

/// Get the stream from an object that can provide a stream.
/// `options` is currently unused.
+ (PSPDFStream *)streamFromStreamProvider:(id<PSPDFStreamProvider>)streamProvider options:(NSDictionary *)options error:(NSError *__autoreleasing*)error;

/// Designated initializer
- (instancetype)initWithStream:(CGPDFStreamRef)stream;

/// Referenced stream. Warning! Only valid as long as the parent `CGPDFDocument` is not closed.
@property (nonatomic, assign, readonly) CGPDFStreamRef stream;

/// Stream dictionary.
- (NSDictionary *)dictionary;

/// If CGPDFDataFormat is `CGPDFDataFormatJPEGEncoded`, we can extract the image.
- (UIImage *)image;

/// Stream data. Format will be returned.
- (NSData *)dataUsingFormat:(CGPDFDataFormat *)dataFormat;

/// Stream size.
- (size_t)dataLength;

/// Text representation. Only attempt a conversion if you're sure this is text, will be garbage if content is an image.
- (NSString *)stringValue;

/// File URL from the converted stream.
/// @warning This might be slow for large streams.
- (NSURL *)fileURLWithAssetName:(NSString *)assetName UID:(NSString *)UID page:(NSUInteger)page error:(NSError *__autoreleasing*)error;

/// File URL with generic path. Path needs to be writable and any directory needs to be created.
///
/// @warning This might be slow for large streams.
- (NSURL *)fileURLWithPath:(NSString *)path error:(NSError *__autoreleasing*)error;

@end

// Helper, useful when dealing with appearance streams.
// Returns `CGRectZero` if stream BBox not found.
extern CGRect PSPDFBoundingBoxFromStream(CGPDFStreamRef streamRef);

// Extract the transform matrix from a stream object, if any set.
extern CGAffineTransform PSPDFMatrixFromStream(CGPDFStreamRef streamRef);
