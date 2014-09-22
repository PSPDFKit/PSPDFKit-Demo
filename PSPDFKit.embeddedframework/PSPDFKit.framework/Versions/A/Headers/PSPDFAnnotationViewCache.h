//
//  PSPDFAnnotationController.h
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
#import <UIKit/UIKit.h>

@class PSPDFViewController;

// Handles annotation cache and view creation.
@interface PSPDFAnnotationViewCache : NSObject

// Designated Initializer.
- (instancetype)initWithPDFController:(PSPDFViewController *)pdfController NS_DESIGNATED_INITIALIZER;

// Prepare annotation view.
- (UIView <PSPDFAnnotationViewProtocol> *)prepareAnnotationViewForAnnotation:(PSPDFAnnotation *)annotation frame:(CGRect)annotationRect pageView:(PSPDFPageView *)pageView;

/// @name Cache

/// Enqueues a annotationView for later reuse.
- (void)recycleAnnotationView:(id<PSPDFAnnotationViewProtocol>)annotationView;

/// Dequeues an annotation view, if available from the cache.
/// If there's a match with the current annotation, this view is picked in favor of a random cached view.
- (UIView <PSPDFAnnotationViewProtocol> *)dequeueViewFromCacheForAnnotation:(PSPDFAnnotation *)annotation class:(Class)annotationViewClass;

/// Clears all cached objects.
- (void)clearCache;

// Attached `PSPDFViewController`.
@property (nonatomic, weak) PSPDFViewController *pdfController;

@end

@interface PSPDFAnnotationViewCache (SubclassingHooks)

/// Annotation factory for built-in types.
/// Can be overridden, but usually reacting to the various annotation-delegate methods is enough.
- (UIView <PSPDFAnnotationViewProtocol> *)createAnnotationViewForAnnotation:(PSPDFAnnotation *)annotation frame:(CGRect)annotationRect;

@end
