//
//  PSPDFSettingsBarButtonItem.m
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

#if !__has_feature(objc_arc)
#error "Compile this file with ARC"
#endif

@implementation PSCSettingsBarButtonItem

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFBarButtonItem

// on iPad, we use a string (as there's more space)
- (UIImage *)image {
    UIImage *image = [UIImage imageNamed:@"settings"];
    return self.itemStyle == UIBarButtonItemStyleBordered ? PSPDFApplyToolbarShadowToImage(image) : image;
}

- (UIImage *)landscapeImagePhone {
    UIImage *image = [UIImage imageNamed:@"settings_landscape"];
    return self.itemStyle == UIBarButtonItemStyleBordered ? PSPDFApplyToolbarShadowToImage(image) : image;
}

- (NSString *)actionName {
    return NSLocalizedString(@"Options", @"");
}

- (id)presentAnimated:(BOOL)animated sender:(id)sender {
    PSCSettingsController *settingsController = [PSCSettingsController new];
    PSPDFViewController *pdfController = self.pdfController;
    settingsController.owningViewController = pdfController;
    return [pdfController presentViewControllerModalOrPopover:settingsController embeddedInNavigationController:PSIsIpad() withCloseButton:YES animated:YES sender:sender options:@{PSPDFPresentOptionAlwaysPopover : @YES}];
}

@end
