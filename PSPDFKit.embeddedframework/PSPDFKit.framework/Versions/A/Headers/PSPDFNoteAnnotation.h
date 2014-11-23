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
/// @note Note annotations are rendered as fixed size; much like how Adobe Acrobat renders them.
/// PSPDFKit will always render note annotations at a fixed size of 32x32pt.
/// We recommend that you set the `boundingBox` to the same value.
@interface PSPDFNoteAnnotation : PSPDFAnnotation

/// Initialize with text contents.
- (instancetype)initWithContents:(NSString *)contents;

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
