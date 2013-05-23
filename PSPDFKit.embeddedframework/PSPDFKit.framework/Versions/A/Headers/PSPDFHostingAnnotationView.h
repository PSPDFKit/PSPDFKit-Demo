//
//  PSPDFHostingAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
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
