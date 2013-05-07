//
//  PSPDFWidgetAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
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
