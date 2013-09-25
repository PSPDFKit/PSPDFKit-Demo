//
//  PSPDFAnnotationBarButtonItem.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFBarButtonItem.h"
#import "PSPDFAnnotationToolbar.h"

@class PSPDFAnnotationToolbar;

/**
 Show/Hide the annotation toolbar.

 This button checks if the annotations can be saved (according to the annotationSaveMode setting in PSPDFDocument)
 For example, if the PDF is NOT writable but you're setting PSPDFAnnotationSaveModeEmbedded, the button will be disabled.

 The button will be hidden when you're setting PSPDFAnnotationSaveModeDisabled.
 If you implement custom saving logic, either set annotationSaveMode to PSPDFAnnotationSaveModeExternalFile and override the load/save methods in PSPDFAnnotationManager, or override PSPDFAnnotationBarButtonItem and return YES on isAvailable. (a good implementation would be 'return self.pdfController.document.isValid'.

 The annotation toolbar will be displayed on top of the navigationController's navigationBar - if it's visible.
 If not, PSPDFAnnotationBarButtonItem looks for the UIToolbar it is embedded in (you can override targetToolbarForBarButtonItem). The AnnotationToolbar will copy the style of the current UIToolbar. (barStyle, translucent, tintColor)
 If everything else fails, the toolbar will be displayed above the PSPDFViewController's view anchored at the top.
 */
@interface PSPDFAnnotationBarButtonItem : PSPDFBarButtonItem <PSPDFAnnotationToolbarDelegate>

/// Non-async check for isAvailable.
- (BOOL)isAvailableBlocking;

/// Override if you are using multiple UIToolbars and want to change on what toolbar the annotation bar should be displayed.
/// Returns UIToolbar or UINavigationBar.
- (UIView *)targetToolbarForBarButtonItem:(UIBarButtonItem *)barButtonItem;

/// Internally used and displayed annotation toolbar.
@property (nonatomic, strong, readonly) PSPDFAnnotationToolbar *annotationToolbar;

@end
