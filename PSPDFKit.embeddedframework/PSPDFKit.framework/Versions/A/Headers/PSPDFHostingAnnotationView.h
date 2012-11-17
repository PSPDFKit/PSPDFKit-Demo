//
//  PSPDFHostingAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFGenericAnnotationView.h"
#import "PSPDFRenderQueue.h"

/// View that will render an annotation.
@interface PSPDFHostingAnnotationView : PSPDFGenericAnnotationView <PSPDFRenderDelegate>

@end
