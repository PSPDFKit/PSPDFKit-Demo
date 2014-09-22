//
//  PSPDFNoteAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PSPDFAnnotationView.h"

@class PSPDFNoteAnnotation;

/// Note annotations are handled as subviews to be draggable.
@interface PSPDFNoteAnnotationView : PSPDFAnnotationView

/// Designated initializer.
- (instancetype)initWithAnnotation:(PSPDFAnnotation *)noteAnnotation;

/// Image of the rendered annotation.
@property (nonatomic, strong) UIImageView *annotationImageView;

@end

@interface PSPDFNoteAnnotationView (SubclassingHooks)

// Override to customize the image tinting.
- (UIImage *)renderNoteImage;

// Force image re-render.
- (void)updateImageAnimated:(BOOL)animated;

@end
