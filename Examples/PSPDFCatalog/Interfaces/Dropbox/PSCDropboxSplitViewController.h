//
//  PSCDropboxSplitViewController.h
//  PSPDFCatalog
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>
#import "PSCDropboxPDFViewController.h"

@interface PSCDropboxSplitViewController : UISplitViewController

/// Right pane document selector.
@property (nonatomic, strong, readonly) PSPDFDocumentPickerController *documentPicker;

/// Content pane PDF controller.
@property (nonatomic, strong, readonly) PSCDropboxPDFViewController *pdfController;

/// Shows/hides the left (documents) pane.
@property (nonatomic, assign) BOOL showLeftPaneInLandscape;

@end
