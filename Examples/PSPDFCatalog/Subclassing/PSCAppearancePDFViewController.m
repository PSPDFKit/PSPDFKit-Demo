//
//  PSCAppearancePDFViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAppearancePDFViewController.h"

@implementation PSCAppearanceNavigationController @end

@implementation PSCAppearancePDFViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

- (void)commonInitWithDocument:(PSPDFDocument *)document {
    [super commonInitWithDocument:document];
    self.statusBarStyleSetting = PSPDFStatusBarStyleDefault;

    // All toolbars within this controller should be orange
    [[UIToolbar appearanceWhenContainedIn:PSCAppearancePDFViewController.class, nil] setTintColor:UIColor.orangeColor];

    // All buttons as well.
    UIColor *skyBlue = [UIColor colorWithRed:0.250f green:0.339f blue:0.486f alpha:1.000f];
    [[UIBarButtonItem appearanceWhenContainedIn:PSCAppearanceNavigationController.class, nil] setTintColor:skyBlue];
    [[UISegmentedControl appearanceWhenContainedIn:PSCAppearanceNavigationController.class, nil] setTintColor:skyBlue];

    // Add example background image and tint color.
    [[UINavigationBar appearanceWhenContainedIn:PSCAppearanceNavigationController.class, nil] setTintColor:UIColor.redColor];
//    UIImage *gradientPortrait = [UIImage imageNamed:@"exampleimage.jpg"];
//    [[UINavigationBar appearanceWhenContainedIn:PSCAppearanceNavigationController.class, nil] setBackgroundImage:gradientPortrait forBarMetrics:UIBarMetricsDefault];
}

@end
