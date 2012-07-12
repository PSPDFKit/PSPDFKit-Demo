//
//  PSPDFSettingsBarButtonItem.m
//  PSPDFKitExample
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFSettingsBarButtonItem.h"
#import "PSPDFSettingsController.h"

@implementation PSPDFSettingsBarButtonItem

- (UIBarButtonItemStyle)itemStyle {
    return PSIsIpad() ? UIBarButtonItemStyleBordered : UIBarButtonItemStylePlain;
}

// on iPad, we use a string (as there's more space)
- (UIImage *)image {
    return PSIsIpad() ? nil : [UIImage imageNamed:@"settings"];
}

- (UIImage *)landscapeImagePhone {
    return PSIsIpad() ? nil : [UIImage imageNamed:@"settings_landscape"];
}

- (NSString *)actionName {
    return NSLocalizedString(@"Options", @"");
}

- (id)presentAnimated:(BOOL)animated sender:(PSPDFBarButtonItem *)sender {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[PSPDFSettingsController new]];
    return [self presentModalOrInPopover:navController sender:sender];
}

- (void)dismissAnimated:(BOOL)animated {
    [self dismissModalOrPopoverAnimated:animated];
}

@end
