//
//  PSPDFNoteAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAnnotation.h"

/// PDF Note (Text) Annotation.
/// Note annotations are rendered as fixed size; much like how Adobe Acrobat renders them.
/// We recommend a size of 32px for the boundingBox.
@interface PSPDFNoteAnnotation : PSPDFAnnotation

/// Designated initializer.
- (id)init;

/// Note Icon name (see PSPDFKit.bundle for available icon names)
/// If set to zero, it will return to the default "Comment".
@property (nonatomic, copy) NSString *iconName;

@end

@interface PSPDFNoteAnnotation (SubclassingHooks)

// Image that is rendered.
- (UIImage *)renderAnnnotationIcon;

// Called to render the note image.
- (void)drawImageInContext:(CGContextRef)context boundingBox:(CGRect)boundingBox;

@end
