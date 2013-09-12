//
//  PSPDFAnnotationViewProtocol.h
//  PSPDFKit
//
//  Copyright (c) 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"

@class PSPDFAnnotation;

/// Conforming to this protocol indicates instances can present an annotation and react events such as page show/hide (to pause video, for example)
@protocol PSPDFAnnotationViewProtocol <NSObject>

@optional

/// Represented annotation this object is presenting.
@property (nonatomic, strong) PSPDFAnnotation *annotation;

/// Allows ordering of annotation views.
@property (nonatomic, assign) NSUInteger zIndex;

/// Allows adapting to the outer zoomScale. Re-set after zooming.
@property (nonatomic, assign) CGFloat zoomScale;

/// Allows adapting to the initial pdfScale
@property (nonatomic, assign) CGFloat PDFScale;

/// Called when page will be displayed. Only available in pageCurl mode.
- (void)willShowPage:(NSUInteger)page;

/// Called when pageView is displayed.
- (void)didShowPage:(NSUInteger)page;

/// Called when pageView will be hidden. Only available in pageCurl mode.
- (void)willHidePage:(NSUInteger)page;

/// Called when pageView is hidden.
- (void)didHidePage:(NSUInteger)page;

/// Called initially and when the parent page size is changed. (e.g. rotation)
- (void)didChangePageBounds:(CGRect)bounds;

@end
