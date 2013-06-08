//
//  PSCDropboxSplitViewController.h
//  PSPDFCatalog
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>
#import "PSPDFDocumentSelectorController.h"
#import "PSCDropboxPDFViewController.h"

@interface PSCDropboxSplitViewController : UISplitViewController

/// Right pane document selector.
@property (nonatomic, strong, readonly) PSPDFDocumentSelectorController *documentSelector;

/// Content pane PDF controller.
@property (nonatomic, strong, readonly) PSCDropboxPDFViewController *pdfController;

/// Shows/hides the left (documents) pane.
@property (nonatomic, assign) BOOL showLeftPaneInLandscape;

@end
