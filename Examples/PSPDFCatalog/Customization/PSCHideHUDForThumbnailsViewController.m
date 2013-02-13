//
//  PSCHideHUDForThumbnailsViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import "PSCHideHUDForThumbnailsViewController.h"

@implementation PSCHideHUDForThumbnailsViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

- (void)commonInitWithDocument:(PSPDFDocument *)document {
    [super commonInitWithDocument:document];
    self.delegate = self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

- (void)pdfViewController:(PSPDFViewController *)pdfController didChangeViewMode:(PSPDFViewMode)viewMode {
    // Hide when we enter thumbnail view, show again when we are in document mode.
    [self setHUDVisible:viewMode == PSPDFViewModeDocument animated:YES];
}

@end
