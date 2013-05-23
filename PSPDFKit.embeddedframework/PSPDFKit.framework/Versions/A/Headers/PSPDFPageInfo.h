//
//  PSPDFPageInfo.h
//  PSPDFKit
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"

@class PSPDFDocumentProvider;

/// Represents PDF page data. Managed within PSPDFDocumentProvider.
@interface PSPDFPageInfo : NSObject <NSCopying, NSCoding>

/// Init object with page and rotation.
- (id)initWithPage:(NSUInteger)page rect:(CGRect)pageRect rotation:(NSInteger)rotation documentProvider:(PSPDFDocumentProvider *)documentProvider;

/// Saved aspect ratio of current page.
@property (nonatomic, assign) CGRect pageRect;

/// Returns corrected, rotated bounds of pageRect. Is calculated on the fly.
@property (nonatomic, assign, readonly) CGRect rotatedPageRect;

/// Saved page rotation of current page. Value between 0 and 270.
/// Can be used to manually rotate pages (but needs a cache clearing and a reload)
/// On setting this, pageRotationTransform will be updated.
@property (nonatomic, assign) NSUInteger pageRotation;

/// Page transform matrix.
@property (nonatomic, assign, readonly) CGAffineTransform pageRotationTransform;

/// Referenced page.
@property (nonatomic, assign, readonly) NSUInteger page;

/// Referenced document provider.
@property (nonatomic, unsafe_unretained, readonly) PSPDFDocumentProvider *documentProvider;

/// Compare.
- (BOOL)isEqualToPageInfo:(PSPDFPageInfo *)otherPageInfo;

@end
