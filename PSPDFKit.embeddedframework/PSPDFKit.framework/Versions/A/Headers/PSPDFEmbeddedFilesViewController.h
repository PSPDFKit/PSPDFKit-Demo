//
//  PSPDFEmbeddedFilesViewController.h
//  PSPDFKit
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFStatefulTableViewController.h"

@class PSPDFDocument, PSPDFEmbeddedFilesViewController, PSPDFEmbeddedFile;

/// Deletage for the `PSPDFEmbeddedFilesViewController`.
@protocol PSPDFEmbeddedFilesViewControllerDelegate <NSObject>

/// Will be called when the user touches an annotation cell.
- (void)embeddedFilesController:(PSPDFEmbeddedFilesViewController *)embeddedFilesController didSelectFile:(PSPDFEmbeddedFile *)embeddedFile sender:(id)sender;

@end

/// Shows a list of all embedded files.
@interface PSPDFEmbeddedFilesViewController : PSPDFStatefulTableViewController

/// Designated initializer.
- (id)initWithDocument:(PSPDFDocument *)document delegate:(id<PSPDFEmbeddedFilesViewControllerDelegate>)delegate;

/// Attached PDF controller.
@property (nonatomic, weak) PSPDFDocument *document;

/// The delegate.
@property (nonatomic, weak) id<PSPDFEmbeddedFilesViewControllerDelegate> delegate;

@end
