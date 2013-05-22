//
//  PSCTintablePDFViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSCTintablePDFViewController.h"
#import "PSCTintColorSelectionBarButtonItem.h"

@implementation PSCTintablePDFViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

- (void)commonInitWithDocument:(PSPDFDocument *)document {
    [super commonInitWithDocument:document];
    self.statusBarStyleSetting = PSPDFStatusBarDefault;
    self.tintColor = [UIColor colorWithRed:0.092 green:0.608 blue:0.000 alpha:1.000];
    PSCTintColorSelectionBarButtonItem *tintColorButtonItem = [[PSCTintColorSelectionBarButtonItem alloc] initWithPDFViewController:self];
    UIBarButtonItem *alertButtonTest = [[UIBarButtonItem alloc] initWithTitle:@"Alert" style:UIBarButtonItemStyleBordered target:self action:@selector(testAlert)];

    self.useBorderedToolbarStyle = YES;
    self.leftBarButtonItems = @[self.closeButtonItem, tintColorButtonItem, alertButtonTest];
    self.rightBarButtonItems = @[self.brightnessButtonItem, self.annotationButtonItem, self.outlineButtonItem, self.viewModeButtonItem];
    self.linkAction = PSPDFLinkActionAlertView; // touch a link to test tint.

    // both default, but set explicitly here for demonstration purposes
    self.shouldTintPopovers = YES;
    self.shouldTintAlertView = YES;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)testAlert {
    [self.popoverController dismissPopoverAnimated:NO];
    [[[PSPDFAlertView alloc] initWithTitle:@"AlertView Test" message:@"This alert is a test. Notice the custom tintColor with PSPDFAlertView." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] showWithTintColor:self.tintColor];
}

@end
