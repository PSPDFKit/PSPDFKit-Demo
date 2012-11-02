//
//  PSPDFStream.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFDocument;

// Allows conversion of a CGPDFStreamRef to a file object.
@interface PSPDFStream : NSObject

- (id)initWithStream:(CGPDFStreamRef)stream;

@property (nonatomic, assign, readonly) CGPDFStreamRef stream;

// Stream dictionary.
- (NSDictionary *)dictionary;

// File URL from the converted stream.
- (NSURL *)fileURLWithAssetName:(NSString *)assetName document:(PSPDFDocument *)document page:(NSUInteger)page;

@end
