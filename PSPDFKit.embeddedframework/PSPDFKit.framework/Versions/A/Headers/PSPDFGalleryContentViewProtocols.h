//
//  PSPDFGalleryContentViewProtocols.h
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

/// Protocol for `UIView`s that wish to be the `loadingView` of a `PSPDFGalleryContentView`.
@protocol PSPDFGalleryContentViewLoading <NSObject>
- (void)setProgress:(CGFloat)progress;
- (CGFloat)progress;
@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

/// Protocol for `UIView`s that wish to be the `loadingView` of a `PSPDFGalleryContentView`.
@protocol PSPDFGalleryContentViewError <NSObject>
- (void)setError:(NSError *)error;
- (NSError *)error;
@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

/// Protocol for `UIView`s that wish to be the `loadingView` of a `PSPDFGalleryContentView`.
@protocol PSPDFGalleryContentViewCaption <NSObject>
- (void)setCaption:(NSString *)caption;
- (NSString *)caption;
@end
