//
//  PSPDFNoteAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFGenericAnnotationView.h"

@class PSPDFNoteAnnotation;

/// Note annotations are handled as subviews to be draggable.
@interface PSPDFNoteAnnotationView : PSPDFGenericAnnotationView

/// Designated initializer.
- (id)initWithAnnotation:(PSPDFAnnotation *)noteAnnotation;

/// Image of the rendered annotation.
@property (nonatomic, strong) UIImageView *annotationImageView;

@end

@interface PSPDFNoteAnnotationView (SubclassingHooks)

// Override to customize the image tinting.
- (UIImage *)renderNoteImage;

@end
