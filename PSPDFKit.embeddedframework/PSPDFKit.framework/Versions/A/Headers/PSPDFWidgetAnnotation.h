//
//  PSPDFWidgetAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAnnotation.h"
#import "PSPDFAction.h"

/// The PDF 'Widget' annotation.
/// A Widget usually is a button, much like a link annotation.
/// @note: Widget might also represent a form object, which is not yet parsed/supported.
@interface PSPDFWidgetAnnotation : PSPDFAnnotation

/// THe PDF action executed on touch.
@property (nonatomic, strong) PSPDFAction *action;

@end
