//
//  PSPDFSettingsBarButtonItem.m
//  PSPDFCatalog
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSCSettingsBarButtonItem.h"
#import "PSCSettingsController.h"

#if !__has_feature(objc_arc)
#error "Compile this file with ARC"
#endif

@implementation PSCSettingsBarButtonItem

- (UIBarButtonItemStyle)itemStyle {
    return UIBarButtonItemStylePlain;
}

// on iPad, we use a string (as there's more space)
- (UIImage *)image {
    return [UIImage imageNamed:@"settings"];
}

- (UIImage *)landscapeImagePhone {
    return [UIImage imageNamed:@"settings_landscape"];
}

- (NSString *)actionName {
    return NSLocalizedString(@"Options", @"");
}

- (id)presentAnimated:(BOOL)animated sender:(PSPDFBarButtonItem *)sender {
    PSCSettingsController *settingsController = [PSCSettingsController new];
    settingsController.owningViewController = self.pdfController;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsController];
    return [self presentModalOrInPopover:navController sender:sender];
}

@end
