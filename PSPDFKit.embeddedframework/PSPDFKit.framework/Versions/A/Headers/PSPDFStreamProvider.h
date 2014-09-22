//
//  PSPDFStreamProvider.h
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

@class PSPDFDocumentProvider;

// Objects that implement this protocol contain an object stream that can be extracted on-the-fly.
@protocol PSPDFStreamProvider <NSObject>

// The attached document provider where we get the stream from.
@property (nonatomic, weak, readonly) PSPDFDocumentProvider *documentProvider;

// The stream as absolute path within the pdf dictionary.
@property (nonatomic, copy, readonly) NSString *streamPath;

// Will parse the stream and also set the URL if applicible.
- (NSURL *)fileURLWithError:(NSError **)error;

@end
