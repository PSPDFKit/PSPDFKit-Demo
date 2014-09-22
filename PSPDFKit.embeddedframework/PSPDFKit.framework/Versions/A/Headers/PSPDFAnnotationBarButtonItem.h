//
//  PSPDFAnnotationBarButtonItem.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFSelectableBarButtonItem.h"

@class PSPDFAnnotationToolbar;

/**
 Show/Hide the annotation toolbar.

 This button checks if the annotations can be saved (according to the `annotationSaveMode` setting in `PSPDFDocument`)
 For example, if the PDF is NOT writable but you're setting `PSPDFAnnotationSaveModeEmbedded`, the button will be disabled.
 However, this button will always be visible if the save mode is set to `PSPDFAnnotationSaveModeDisabled`.
 In that case we assume that annotations are only meant as temporary notes.

 If you implement custom saving logic, either set `annotationSaveMode` to `PSPDFAnnotationSaveModeExternalFile` and override the load/save methods in `PSPDFAnnotationManager`, or override `PSPDFAnnotationBarButtonItem` and return `YES` on `isAvailable`. (a good implementation would be 'return `self.pdfController.document.isValid`'.

 The annotation toolbar will be displayed on top of the `navigationController's` `navigationBar` - if it's visible.
 If not, `PSPDFAnnotationBarButtonItem` looks for the `UIToolbar` or `UINavigationBar` it is embedded in (you can override `targetToolbar`). The `annotationToolbar` will copy the style of the current UIToolbar (`barStyle`, `translucent`, `tintColor`).
 If everything else fails, the toolbar will be displayed above the `PSPDFViewController's` view anchored at the top.
 */
@interface PSPDFAnnotationBarButtonItem : PSPDFSelectableBarButtonItem

/// Internally used and displayed annotation toolbar.
@property (nonatomic, strong, readonly) PSPDFAnnotationToolbar *annotationToolbar;

/// Shows or hides the annotation toolbar (animated)
- (void)toggleAnnotationToolbar;

/// Show the annotation toolbar, if not currently visible.
/// @return Whether the toolbar was actually shown.
- (BOOL)showAnnotationToolbarAnimated:(BOOL)animated;

/// Hide the annotation toolbar, if currently shown.
/// @return Whether the toolbar was actually hidden.
- (BOOL)hideDisplayedToolbarAnimated:(BOOL)animated;

/// Non-async check for isAvailable.
- (BOOL)isAvailableBlocking;

/// The host view for the `PSPDFAnnotationToolbarContainer`.
/// If set to nil (the default), the `PSPDFViewController`'s navigationController view or the containing `UIToolbar`'s or `UINavigationBar`'s superview will be used.
@property (nonatomic, strong) UIView *hostView;

@end
