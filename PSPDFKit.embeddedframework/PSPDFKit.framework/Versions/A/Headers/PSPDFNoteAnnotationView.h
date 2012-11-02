//
//  PSPDFTextAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFAnnotationView.h"

@class PSPDFNoteAnnotation;

/// Note annotations are handled as subviews to be draggable.
@interface PSPDFNoteAnnotationView : UIView <PSPDFAnnotationView>

/// Designated initializer.
- (id)initWithAnnotation:(PSPDFNoteAnnotation *)textAnnotation;

@end
