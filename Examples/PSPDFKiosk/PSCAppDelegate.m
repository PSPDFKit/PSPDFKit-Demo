//
//  PSCAppDelegate.m
//  PSPDFKiosk
//
//  Created by Peter Steinberger on 12/14/12.
//  Copyright (c) 2012 PSPDFKit. All rights reserved.
//

#import "PSCAppDelegate.h"
#import "PSCGridViewController.h"

@interface UIColor (PSPDFCatalogAdditions)
+ (UIColor *)pspdfColor;
@end


@implementation PSCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];

    [UIApplication.sharedApplication setStatusBarStyle:UIStatusBarStyleDefault];
    PSCGridViewController *gridController = [PSCGridViewController new];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:gridController];

    if (PSCIsUIKitFlatMode()) {
        PSC_IF_IOS7_OR_GREATER([UIApplication.sharedApplication setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
                               navController.navigationBar.barTintColor = UIColor.pspdfColor;
                               navController.toolbar.tintColor = UIColor.blackColor;
                               navController.view.tintColor = UIColor.whiteColor;
                               // By default the system would show a white cursor.
                               [[UITextField appearance] setTintColor:UIColor.pspdfColor];
                               [[UITextView  appearance] setTintColor:UIColor.pspdfColor];
                               [[UISearchBar appearance] setTintColor:UIColor.pspdfColor];)
        navController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor : UIColor.whiteColor};
    }else {
        [UIApplication.sharedApplication setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    }

    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end

@implementation UIColor (PSPDFCatalogAdditions)

+ (UIColor *)pspdfColor {
    return [UIColor colorWithRed:0.f green:166.f/255.f blue:240.f/255.f alpha:1.f];
}

@end
