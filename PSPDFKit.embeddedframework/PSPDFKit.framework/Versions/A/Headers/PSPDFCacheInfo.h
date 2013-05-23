//
//  PSPDFCacheInfo.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

@class PSPDFRenderReceipt;

@interface PSPDFCacheInfo : NSObject <NSCoding>

/// Designated initializer.
- (id)initWithUID:(NSString *)UID andPage:(NSUInteger)page ofSize:(CGSize)size withReceipt:(NSString *)renderReceipt;

/// UID of the document this image is referenced.
@property (nonatomic, copy, readonly) NSString *UID;

/// The document page.
@property (nonatomic, assign, readonly) NSUInteger page;

/// The image size.
@property (nonatomic, assign, readonly) CGSize size;

/// The render receipt. Allows to detect changes in the PDF such as annotation changes.
@property (nonatomic, strong) NSString *renderFingerprintString;

/// The last time the image has been accessed.
@property (atomic, strong) NSDate *lastAccessTime;

/// If the entry has a disk representation, it's set here.
@property (nonatomic, assign) NSUInteger diskSize;

/// The cached image (if memory cache or image is about to be written to disk)
@property (atomic, strong) UIImage *image;

/// Returns `YES` if the image can be scaled down to `size`.
- (BOOL)canBeScaledDownToSize:(CGSize)size;

@end
