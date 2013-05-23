//
//  PSPDFAnnotationController.h
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

@class PSPDFViewController;

// Handles annotation cache and view creation.
@interface PSPDFAnnotationViewCache : NSObject

// Designated Initializer.
- (id)initWithPDFController:(PSPDFViewController *)pdfController;

// Prepare annotation view.
- (UIView <PSPDFAnnotationViewProtocol> *)prepareAnnotationViewForAnnotation:(PSPDFAnnotation *)annotation frame:(CGRect)annotationRect pageView:(PSPDFPageView *)pageView;

// Handle annotation action.
- (void)handleTouchUpForAnnotationIgnoredByDelegate:(PSPDFLinkAnnotationView *)annotationView;

/// @name Cache

/// Enqueues a annotationView for later reuse
- (void)recycleAnnotationView:(id<PSPDFAnnotationViewProtocol>)annotationView;

/// Dequeues an annotation view, if available from the cache.
/// If there's a match with the current annotation, this view is picked in favor of a random cached view.
- (UIView <PSPDFAnnotationViewProtocol> *)dequeueViewFromCacheForAnnotation:(PSPDFAnnotation *)annotation class:(Class)annotationViewClass;

/// Clears all cached objects.
- (void)clearCache;


// Attached PDFController.
@property (nonatomic, weak) PSPDFViewController *pdfController;

@end


@interface PSPDFAnnotationViewCache (SubclassingHooks)

/// Annotation factory for built-in types.
/// Can be overridden, but usually reacting to the various annotation-delegate methods is enough.
- (UIView <PSPDFAnnotationViewProtocol> *)createAnnotationViewForAnnotation:(PSPDFAnnotation *)annotation frame:(CGRect)annotationRect;

@end
