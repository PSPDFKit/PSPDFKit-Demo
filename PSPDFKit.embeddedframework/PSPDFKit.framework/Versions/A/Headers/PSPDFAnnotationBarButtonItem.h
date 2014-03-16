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
#import "PSPDFAnnotationToolbar.h"
#import "PSPDFFlexibleAnnotationToolbar.h"

@class PSPDFAnnotationToolbar;

typedef NS_ENUM(NSUInteger, PSPDFAnnotationToolbarType) {
    PSPDFAnnotationToolbarTypeSystem,  /// A `UIToolbar` based annotation toolbar type (old)
    PSPDFAnnotationToolbarTypeFlexible /// Draggable annotation toolbar type (modern, iOS 7 only)
};

/**
 Show/Hide the annotation toolbar.

 This button checks if the annotations can be saved (according to the `annotationSaveMode` setting in `PSPDFDocument`)
 For example, if the PDF is NOT writable but you're setting `PSPDFAnnotationSaveModeEmbedded`, the button will be disabled.
 However, this button will always be visible if the save mode is set to `PSPDFAnnotationSaveModeDisabled`.
 In that case we assume that annotations are only meant as temporary notes.

 If you implement custom saving logic, either set `annotationSaveMode` to `PSPDFAnnotationSaveModeExternalFile` and override the load/save methods in `PSPDFAnnotationManager`, or override `PSPDFAnnotationBarButtonItem` and return `YES` on `isAvailable`. (a good implementation would be 'return `self.pdfController.document.isValid`'.

 The annotation toolbar will be displayed on top of the `navigationController's` `navigationBar` - if it's visible.
 If not, `PSPDFAnnotationBarButtonItem` looks for the `UIToolbar` it is embedded in (you can override `targetToolbarForBarButtonItem`). The `annotationToolbar` will copy the style of the current UIToolbar. (`barStyle`, `translucent`, `tintColor`)
 If everything else fails, the toolbar will be displayed above the `PSPDFViewController's` view anchored at the top.
 */
@interface PSPDFAnnotationBarButtonItem : PSPDFSelectableBarButtonItem <PSPDFAnnotationToolbarDelegate>

/// Non-async check for isAvailable.
- (BOOL)isAvailableBlocking;

/// The selected toolbar type will be used the next time the bar button action is invoked.
/// Defaults to `PSPDFAnnotationToolbarTypeFlexible` on iOS 7.
@property (nonatomic, assign) PSPDFAnnotationToolbarType annotationToolbarType;

/// Internally used and displayed annotation toolbar.
@property (nonatomic, strong, readonly) PSPDFAnnotationToolbar *annotationToolbar;

/// Internally used and displayed flexible annotation toolbar.
@property (nonatomic, strong, readonly) PSPDFFlexibleAnnotationToolbar *flexibleAnnotationToolbar;

@end

@interface PSPDFAnnotationBarButtonItem (SubclassingHooks)

/// Override if you are using multiple `UIToolbars` and want to change on what toolbar the annotation bar should be displayed.
/// Returns `UIToolbar` or `UINavigationBar`.
- (UIView *)targetToolbarForBarButtonItem:(UIBarButtonItem *)barButtonItem;

@end
