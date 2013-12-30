//
//  PSCHideHUDDelayedDocumentViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCHideHUDDelayedDocumentViewController.h"

@implementation PSCHideHUDDelayedDocumentViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Make sure the HUD is hidden until the document arrives
    [self setHUDVisible:NO animated:NO];
    self.viewMode = PSPDFViewModeThumbnails;
}

@end
