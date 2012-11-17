//
//  PSPDFTextAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFGenericAnnotationView.h"

@class PSPDFNoteAnnotation;

/// Note annotations are handled as subviews to be draggable.
@interface PSPDFNoteAnnotationView : PSPDFGenericAnnotationView

/// Designated initializer.
- (id)initWithAnnotation:(PSPDFNoteAnnotation *)noteAnnotation;

@end
