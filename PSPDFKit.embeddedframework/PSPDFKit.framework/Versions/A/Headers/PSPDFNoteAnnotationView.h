//
//  PSPDFNoteAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFGenericAnnotationView.h"

@class PSPDFNoteAnnotation;

/// Note annotations are handled as subviews to be draggable.
@interface PSPDFNoteAnnotationView : PSPDFGenericAnnotationView

/// Designated initializer.
- (id)initWithAnnotation:(PSPDFNoteAnnotation *)noteAnnotation;

/// Image of the rendered annotation.
@property (nonatomic, strong) UIImageView *annotationImageView;

@end

@interface PSPDFNoteAnnotationView (SubclassingHooks)

// Override to customize the image tinting.
- (UIImage *)renderNoteImage;

@end
