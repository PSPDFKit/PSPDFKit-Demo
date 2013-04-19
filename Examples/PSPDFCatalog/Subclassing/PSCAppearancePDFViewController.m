//
//  PSCAppearancePDFViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import "PSCAppearancePDFViewController.h"

@implementation PSCAppearanceNavigationController @end

@implementation PSCAppearancePDFViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

- (void)commonInitWithDocument:(PSPDFDocument *)document {
    [super commonInitWithDocument:document];
    self.statusBarStyleSetting = PSPDFStatusBarDefault;
    UIBarButtonItem *alertButtonTest = [[UIBarButtonItem alloc] initWithTitle:@"Alert" style:UIBarButtonItemStyleBordered target:self action:@selector(testAlert)];
    self.leftBarButtonItems = @[self.closeButtonItem, alertButtonTest];

    // All toolbars within this controller should be orange
    [[UIToolbar appearanceWhenContainedIn:PSCAppearancePDFViewController.class, nil] setTintColor:UIColor.orangeColor];

    // All buttons as well.
    UIColor *skyBlue = [UIColor colorWithRed:0.250 green:0.339 blue:0.486 alpha:1.000];
    [[UIBarButtonItem appearanceWhenContainedIn:PSCAppearanceNavigationController.class, nil] setTintColor:skyBlue];
    [[UISegmentedControl appearanceWhenContainedIn:PSCAppearanceNavigationController.class, nil] setTintColor:skyBlue];

    // Add example background image and tint color.
    [[UINavigationBar appearanceWhenContainedIn:PSCAppearanceNavigationController.class, nil] setTintColor:UIColor.redColor];
    UIImage *gradientPortrait = [[UIImage imageNamed:@"exampleimage.jpg"] pspdf_cropImageWithCropRect:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 44.f) aspectFitBounds:CGSizeMake(UIScreen.mainScreen.bounds.size.width, 44.f) fillColor:nil];
    [[UINavigationBar appearanceWhenContainedIn:PSCAppearanceNavigationController.class, nil] setBackgroundImage:gradientPortrait forBarMetrics:UIBarMetricsDefault];

    /// Because the alert view is displayed in it's own window, the appearance can only be set globally.
    [[PSPDFAlertView appearance] setTintColor:UIColor.yellowColor];
}

- (void)dealloc {
    // Restore appearance setting
    [[PSPDFAlertView appearance] setTintColor:nil];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)testAlert {
    [self.popoverController dismissPopoverAnimated:NO];
    [[[PSPDFAlertView alloc] initWithTitle:@"AlertView Test" message:@"This alert is a test. Notice the custom tintColor with PSPDFAlertView." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end
