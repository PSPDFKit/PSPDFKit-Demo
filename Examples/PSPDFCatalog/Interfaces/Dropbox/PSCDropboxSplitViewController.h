//
//  PSCDropboxSplitViewController.h
//  PSPDFCatalog
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSCDocumentSelectorController.h"
#import "PSCDropboxPDFViewController.h"

@interface PSCDropboxSplitViewController : UISplitViewController

/// Right pane document selector.
@property (nonatomic, strong, readonly) PSCDocumentSelectorController *documentSelector;

/// Content pane PDF controller.
@property (nonatomic, strong, readonly) PSCDropboxPDFViewController *pdfController;

/// Shows/hides the left (documents) pane.
@property (nonatomic, assign) BOOL showLeftPaneInLandscape;

@end
