//
//  PSPDFSettingsBarButtonItem.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
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
    settingsController.owningViewController = self.pdfController;
    return [self.pdfController presentViewControllerModalOrPopover:settingsController embeddedInNavigationController:PSIsIpad() withCloseButton:YES animated:YES sender:sender options:@{PSPDFPresentOptionAlwaysPopover : @YES}];
}

@end
