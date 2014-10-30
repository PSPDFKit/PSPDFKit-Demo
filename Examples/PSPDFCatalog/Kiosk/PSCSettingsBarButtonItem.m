//
//  PSCSettingsBarButtonItem.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCSettingsBarButtonItem.h"
#import "PSCSettingsController.h"

@implementation PSCSettingsBarButtonItem

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFBarButtonItem

// on iPad, we use a string (as there's more space)
- (UIImage *)image {
    return [UIImage imageNamed:@"settings"];
}

- (UIImage *)landscapeImagePhone {
    return [UIImage imageNamed:@"settings-landscape"];
}

- (NSString *)actionName {
    return NSLocalizedString(@"Options", @"");
}

- (id)presentAnimated:(BOOL)animated sender:(id)sender {
    PSCSettingsController *settingsController = [PSCSettingsController new];
    PSPDFViewController *pdfController = self.pdfController;
    settingsController.owningViewController = pdfController;
    return [pdfController presentViewController:settingsController options:@{PSPDFPresentationModalStyleKey: @(UIModalPresentationPopover),
                                                                             PSPDFPresentationCloseButtonKey: @(!PSPDFSupportsPopover()),
                                                                             PSPDFPresentationInNavigationControllerKey: @(!PSPDFSupportsPopover())}
                                       animated:YES sender:sender completion:NULL];
}

@end
