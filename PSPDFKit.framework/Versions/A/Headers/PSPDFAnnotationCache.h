//
//  PSPDFAnnotationCache.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSPDFKitGlobal.h"
#import "PSPDFAnnotationView.h"

@class PSPDFDocument, PSPDFAnnotation;

@interface PSPDFAnnotationCache : NSObject

/// Enqueues a annotationView for later reuse
- (void)recycleAnnotationView:(id<PSPDFAnnotationView>)annotationView;

/// Dequeues an annotation view, if available from the cache.
/// If there's a match with the current annotation, this view is picked in favor of a random cached view.
- (UIView <PSPDFAnnotationView>*)dequeueViewFromCacheForAnnotation:(PSPDFAnnotation *)annotation class:(Class)annotationViewClass;

/// Clears all cached objects
- (void)clearAllObjects;

@end
