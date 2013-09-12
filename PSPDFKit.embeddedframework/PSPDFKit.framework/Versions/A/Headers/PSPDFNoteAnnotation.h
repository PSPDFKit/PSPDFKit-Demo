//
//  PSPDFNoteAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAnnotation.h"

// We extend the width/height of note annotation to make them easier touch targets.
extern CGSize PSPDFNoteAnnotationViewFixedSize;

/// PDF Note (Text) Annotation.
@interface PSPDFNoteAnnotation : PSPDFAnnotation

/// Designated initializer.
- (id)init;

/// Note Icon name (see PSPDFKit.bundle for available icon names)
/// If set to zero, it will return to the default "Comment".
@property (nonatomic, copy) NSString *iconName;

/// Custom HitTest because we have custom width/height here.
- (BOOL)hitTest:(CGPoint)point withViewBounds:(CGRect)bounds;

- (CGRect)boundingBoxForPageViewBounds:(CGRect)pageBounds;

@end
