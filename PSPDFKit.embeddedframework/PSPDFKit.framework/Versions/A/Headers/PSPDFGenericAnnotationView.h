//
//  PSPDFGenericAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFAnnotationView.h"
#import "PSPDFRenderQueue.h"

@class PSPDFAnnotation;

///
/// Generic annotation view that listens on annotation changes.
///
@interface PSPDFGenericAnnotationView : UIView <PSPDFAnnotationView>

/// Designated initializer.
- (id)initWithAnnotation:(PSPDFAnnotation *)annotation;

@end

@interface PSPDFGenericAnnotationView (SubclassingHooks)

// Called when any annotation changes. Must call super on this.
- (void)annotationsChanged:(NSNotification *)notification;

@end
