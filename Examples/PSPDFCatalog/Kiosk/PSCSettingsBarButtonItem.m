//
//  PSCSettingsBarButtonItem.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSCSettingsBarButtonItem.h"
#import "PSCSettingsController.h"

@implementation PSCSettingsBarButtonItem

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFBarButtonItem

// on iPad, we use a string (as there's more space)
- (UIImage *)image {
    UIImage *image;
    PSC_IF_IOS7_OR_GREATER(image = [UIImage imageNamed:@"settings"];)
    PSC_IF_PRE_IOS7(image = [UIImage imageNamed:@"settings-legacy"];)
    return self.itemStyle == UIBarButtonItemStyleBordered ? PSPDFApplyToolbarShadowToImage(image) : image;
}

- (UIImage *)landscapeImagePhone {
    // We don't yet have landscape image resource files
    PSC_IF_IOS7_OR_GREATER(return [super landscapeImagePhone];)
    UIImage *image = [UIImage imageNamed:@"settings-landscape-legacy"];
                    return self.itemStyle == UIBarButtonItemStyleBordered ? PSPDFApplyToolbarShadowToImage(image) : image; // iOS6
}

- (NSString *)actionName {
    return NSLocalizedString(@"Options", @"");
}

- (id)presentAnimated:(BOOL)animated sender:(id)sender {
    PSCSettingsController *settingsController = [PSCSettingsController new];
    PSPDFViewController *pdfController = self.pdfController;
    settingsController.owningViewController = pdfController;
    return [pdfController presentModalOrInPopover:settingsController embeddedInNavigationController:PSIsIpad() withCloseButton:YES animated:YES sender:sender options:@{PSPDFPresentOptionAlwaysPopover : @YES}];
}

@end
