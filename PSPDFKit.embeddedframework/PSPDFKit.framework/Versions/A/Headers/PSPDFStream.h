//
//  PSPDFStream.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFDocument;

/// Allows conversion of a CGPDFStreamRef to a file object.
/// A Stream has dictionary data and stream data. Might be anything (like page commands, a video, an image)
@interface PSPDFStream : NSObject

/// Designated initializer
- (id)initWithStream:(CGPDFStreamRef)stream;

/// Referenced stream. Warning! Only valid as long as the parent CGPDFDocument is not closed.
@property (nonatomic, assign, readonly) CGPDFStreamRef stream;

/// Stream dictionary.
- (NSDictionary *)dictionary;

/// If CGPDFDataFormat is CGPDFDataFormatJPEGEncoded, we can extract the image.
- (UIImage *)image;

/// Stream data. Format will be returned.
- (NSData *)dataUsingFormat:(CGPDFDataFormat *)dataFormat;

/// Stream size.
- (size_t)dataLength;

/// File URL from the converted stream.
- (NSURL *)fileURLWithAssetName:(NSString *)assetName document:(PSPDFDocument *)document page:(NSUInteger)page;

/// File URL with generic path. Path needs to be writeable and any directory needs to be created.
- (NSURL *)fileURLWithPath:(NSString *)path;

@end
