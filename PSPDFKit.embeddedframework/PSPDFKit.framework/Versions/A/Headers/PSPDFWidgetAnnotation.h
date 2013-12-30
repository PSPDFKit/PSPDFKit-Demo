//
//  PSPDFWidgetAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAnnotation.h"
#import "PSPDFAction.h"

@class PSPDFPageView;

/// The PDF 'Widget' annotation.
/// A Widget usually is a button, much like a link annotation.
@interface PSPDFWidgetAnnotation : PSPDFAnnotation

/// The PDF action executed on touch.
@property (nonatomic, strong) PSPDFAction *action;

/// Overrides the parent `borderColor` to have a real backing store.
@property (nonatomic, strong) UIColor *borderColor;

/// Property to enable/disable AP stream rendering. Defaults to YES.
@property (nonatomic, assign) BOOL shouldRenderAppearanceStream;

@end
