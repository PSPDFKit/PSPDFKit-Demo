//
//  PSPDFOpenInBarButtonItem.h
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
#import "PSPDFDocumentSharingViewController.h"

@class PSPDFDocument;

/// Checking if any apps support PDF can be done, but this is slow (~300 ms on an iPad 3). Thus it's disabled by default.
/// In case there is no app and this check is disabled, a alert will be showed to the user.
/// Defaults to NO.
extern BOOL PSPDFCheckIfCompatibleAppsAreInstalled;

/// Open in is only possible if the PSPDFDocument is backed by exactly one file-based PDF.
/// Before sending the file to another application, annotations will be saved.
@interface PSPDFOpenInBarButtonItem : PSPDFBarButtonItem <PSPDFDocumentSharingViewControllerDelegate, UIDocumentInteractionControllerDelegate>

/// Shows the print action along with the application list. Defaults to NO.
/// @warning If this is enabled, UIDocumentInteractionController will also show a "Mail" option.
/// This will call presentOptionsMenuFromRect (or variations) if enabled, else presentOpenInMenuFromRect:.
@property (nonatomic, assign) BOOL showPrintAction;

/// Defines what we are sending. If more than one option is set, user will get a dialog to choose.
/// Defaults to PSPDFDocumentSharingOptionCurrentPageOnly|PSPDFDocumentSharingOptionAllPages|PSPDFDocumentSharingOptionEmbedAnnotations|PSPDFDocumentSharingOptionFlattenAnnotations|PSPDFDocumentSharingOptionForceMergeFiles.
@property (nonatomic, assign) PSPDFDocumentSharingOptions openOptions;

/// Document interaction controller that is used internally.
@property (nonatomic, strong, readonly) UIDocumentInteractionController *documentInteractionController;

@end

@interface PSPDFOpenInBarButtonItem (SubclassingHooks)

/// Will figure out a file-based URL that we can attach to the interaction controller.
/// Default implementation will use PSPDFProcessor to merge multiple document files if needed in a temporary directory.
- (NSURL *)fileURLForDocument:(PSPDFDocument *)document;

// Used to create the document interaction controller during presentAnimated:
- (UIDocumentInteractionController *)interactionControllerWithURL:(NSURL *)fileURL;

// Shows the open in controller. options at this point can only be exactly one item, not multiple.
- (void)showOpenInControllerWithOptions:(PSPDFDocumentSharingOptions)options fileURL:(NSURL *)fileURL animated:(BOOL)animated sender:(id)sender;

// Presenting OpenIn/Options Menu
- (BOOL)presentOpenInMenuFromBarButtonItem:(id)sender animated:(BOOL)animated;
- (BOOL)presentOpenInMenuFromRect:(CGRect)senderRect inView:(id)sender animated:(BOOL)animated;

@end
