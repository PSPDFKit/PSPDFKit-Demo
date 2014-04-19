//
//  PSPDFAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFAnnotationViewProtocol.h"
#import "PSPDFRenderQueue.h"

@class PSPDFAnnotation;

/// Generic annotation view that listens on annotation changes.
@interface PSPDFAnnotationView : UIView <PSPDFAnnotationViewProtocol>

/// The currently set annotation.
@property (nonatomic, strong) PSPDFAnnotation *annotation;

/// Associated weak reference to the `PSPDFPageView` the annotation is displayed on.
@property (nonatomic, weak) PSPDFPageView *pageView;

@end

@interface PSPDFAnnotationView (SubclassingHooks)

// Called when any annotation changes.
- (void)annotationChangedNotification:(NSNotification *)notification NS_REQUIRES_SUPER;

// Animated change notifications. Defaults to YES.
@property (nonatomic, assign) BOOL shouldAnimatedAnnotationChanges;

@end

@interface PSPDFAnnotationView (Private)

- (void)enableKeyboardSupport;

@end
