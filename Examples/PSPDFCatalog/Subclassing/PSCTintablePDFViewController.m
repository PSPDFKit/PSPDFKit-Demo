//
//  PSCTintablePDFViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCTintablePDFViewController.h"
#import "PSCTintColorSelectionBarButtonItem.h"

@implementation PSCTintablePDFViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

- (void)commonInitWithDocument:(PSPDFDocument *)document {
    [super commonInitWithDocument:document];
    self.statusBarStyleSetting = PSPDFStatusBarStyleDefault;
    self.tintColor = [UIColor colorWithRed:0.092f green:0.608f blue:0.f alpha:1.f];
    PSCTintColorSelectionBarButtonItem *tintColorButtonItem = [[PSCTintColorSelectionBarButtonItem alloc] initWithPDFViewController:self];

    self.useBorderedToolbarStyle = YES;
    self.leftBarButtonItems = @[self.closeButtonItem, tintColorButtonItem];
    self.rightBarButtonItems = @[self.annotationButtonItem, self.outlineButtonItem, self.viewModeButtonItem];
    self.linkAction = PSPDFLinkActionAlertView; // touch a link to test tint.

    self.shouldTintPopovers = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = UIColor.blackColor;
}

@end
