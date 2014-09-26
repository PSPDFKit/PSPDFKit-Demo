//
//  PSPDFOpenInBarButtonItem.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFBarButtonItem.h"
#import "PSPDFDocumentSharingViewController.h"

// These notifications represent a small subset of `UIDocumentInteractionControllerDelegate` (but the most important ones)
// To get all callbacks, subclass PSPDFOpenInBarButtonItem and implement the callbacks (and also call super)
extern NSString *const PSPDFDocumentInteractionControllerWillBeginSendingToApplicationNotification;
extern NSString *const PSPDFDocumentInteractionControllerDidEndSendingToApplicationNotification;

@class PSPDFDocument;

/// Presents the `UIDocumentInteractionController` for the Open In... feature.
/// @note Depending on `openOptions`, the `PSPDFDocumentSharingViewController` will be presented first.
/// Before sending the file to another application, annotations will be saved.
@interface PSPDFOpenInBarButtonItem : PSPDFBarButtonItem <PSPDFDocumentSharingViewControllerDelegate, UIDocumentInteractionControllerDelegate>

/// Defines how the document is sent. If more than one option is set, user will get a dialog to choose (`PSPDFDocumentSharingViewController`).
/// Defaults to `PSPDFDocumentSharingOptionCurrentPageOnly|PSPDFDocumentSharingOptionAllPages|PSPDFDocumentSharingOptionEmbedAnnotations|PSPDFDocumentSharingOptionFlattenAnnotations|PSPDFDocumentSharingOptionForceMergeFiles`.
@property (nonatomic, assign) PSPDFDocumentSharingOptions openOptions;

/// Internally used document interaction controller.
@property (nonatomic, strong, readonly) UIDocumentInteractionController *documentInteractionController;

@end

@interface PSPDFOpenInBarButtonItem (SubclassingHooks)

// Used to create the document interaction controller during `presentAnimated:`.
- (UIDocumentInteractionController *)interactionControllerWithURL:(NSURL *)fileURL;

// Shows the open in controller. options at this point can only be exactly one item, not multiple.
- (void)showOpenInControllerWithOptions:(PSPDFDocumentSharingOptions)options fileURL:(NSURL *)fileURL animated:(BOOL)animated sender:(id)sender;

// Presenting OpenIn/Options Menu
- (BOOL)presentOpenInMenuFromBarButtonItem:(id)sender animated:(BOOL)animated;
- (BOOL)presentOpenInMenuFromRect:(CGRect)senderRect inView:(id)sender animated:(BOOL)animated;

@end
