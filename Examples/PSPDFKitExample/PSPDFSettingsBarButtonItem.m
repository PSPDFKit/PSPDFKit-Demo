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
    return UIBarButtonItemStyleBordered;
}

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
    return [self presentModalOrInPopover:[[PSPDFSettingsController alloc] init] sender:sender];
}

- (void)dismissAnimated:(BOOL)animated {
    [self dismissModalOrPopoverAnimated:animated];
}

@end
