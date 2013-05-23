//
//  PSPDFStream.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
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
///
/// @warning This might be slow for large streams.
- (NSURL *)fileURLWithAssetName:(NSString *)assetName document:(PSPDFDocument *)document page:(NSUInteger)page;

/// File URL with generic path. Path needs to be writable and any directory needs to be created.
///
/// @warning This might be slow for large streams.
- (NSURL *)fileURLWithPath:(NSString *)path;

@end

// Helper, useful when dealing with appearance streams.
// Returns CGRectZero if stream BBox not found.
extern CGRect PSPDFBoundingBoxFromStream(CGPDFStreamRef streamRef);

extern CGAffineTransform PSPDFMatrixFromStream(CGPDFStreamRef streamRef);
