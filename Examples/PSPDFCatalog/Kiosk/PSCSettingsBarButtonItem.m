//
//  PSCSettingsBarButtonItem.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCSettingsBarButtonItem.h"
#import "PSCSettingsController.h"

static UIImage *PSCImageNamed(NSString *imageName) {
    if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0) {
        return [UIImage imageNamed:imageName];
    }else {
        return [UIImage imageNamed:[imageName stringByAppendingString:@"-legacy"]];
    }
}

@implementation PSCSettingsBarButtonItem

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFBarButtonItem

// on iPad, we use a string (as there's more space)
- (UIImage *)image {
    return PSCImageNamed(@"settings");
}

- (UIImage *)landscapeImagePhone {
    return PSCImageNamed(@"settings-landscape");
}

- (NSString *)actionName {
    return NSLocalizedString(@"Options", @"");
}

- (id)presentAnimated:(BOOL)animated sender:(id)sender {
    PSCSettingsController *settingsController = [PSCSettingsController new];
    PSPDFViewController *pdfController = self.pdfController;
    settingsController.owningViewController = pdfController;
    return [pdfController presentModalOrInPopover:settingsController embeddedInNavigationController:PSCIsIPad() withCloseButton:YES animated:YES sender:sender options:@{PSPDFPresentOptionAlwaysPopover : @YES}];
}

@end
