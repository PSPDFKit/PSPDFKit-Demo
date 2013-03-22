//
//  PSPDFHostingAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFGenericAnnotationView.h"
#import "PSPDFRenderQueue.h"

/// View that will render an annotation.
@interface PSPDFHostingAnnotationView : PSPDFGenericAnnotationView <PSPDFRenderDelegate>

/// Image View that shows the rendered annotation.
@property (nonatomic, strong, readonly) UIImageView *annotationImageView;

// Attach an internally cached image to the image view.
- (void)attachImage;

@end
