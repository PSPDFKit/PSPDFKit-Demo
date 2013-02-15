//
//  PSCHideHUDDelayedDocumentViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
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
