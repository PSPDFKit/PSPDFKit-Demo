//
//  PSCAppDelegate.m
//  PSPDFKiosk
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAppDelegate.h"
#import "PSCGridViewController.h"

@interface UIColor (PSPDFCatalogAdditions)
+ (UIColor *)psc_mainColor;
@end

@implementation PSCAppDelegate

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];

    PSCGridViewController *gridController = [PSCGridViewController new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:gridController];
	navigationController.navigationBar.barTintColor = UIColor.psc_mainColor;
	navigationController.navigationBar.barStyle = UIBarStyleBlack;
	navigationController.toolbar.tintColor = UIColor.blackColor;
	navigationController.view.tintColor = UIColor.whiteColor;

	// By default the system would show a white cursor.
	[[UITextField appearance] setTintColor:UIColor.psc_mainColor];
	[[UITextView  appearance] setTintColor:UIColor.psc_mainColor];
	[[UISearchBar appearance] setTintColor:UIColor.psc_mainColor];
	navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : UIColor.whiteColor};

    self.navigationController = navigationController;
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];

    // Opened with the Open In... feature?
    [self handleOpenURL:launchOptions[UIApplicationLaunchOptionsURLKey]];

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)URL sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"Open %@ from %@ (annotation: %@)", URL, sourceApplication, annotation);
    [PSCStoreManager.sharedStoreManager loadMagazinesFromDisk]; // triffer refresh
    return [self handleOpenURL:URL];
}

- (BOOL)handleOpenURL:(NSURL *)launchURL {
    // Directly open the PDF.
    if (launchURL.isFileURL && [NSFileManager.defaultManager fileExistsAtPath:launchURL.path]) {
        PSPDFDocument *document = [PSPDFDocument documentWithURL:launchURL];
        PSPDFViewController *pdfController = [self viewControllerForDocument:document];
        [self.navigationController popToRootViewControllerAnimated:NO];
        [self.navigationController pushViewController:pdfController animated:NO];
        return YES;
    }
    return NO;
}

- (PSPDFViewController *)viewControllerForDocument:(PSPDFDocument *)document {
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    pdfController.rightBarButtonItems = @[pdfController.searchButtonItem, pdfController.outlineButtonItem, pdfController.annotationButtonItem, pdfController.viewModeButtonItem];
    pdfController.additionalBarButtonItems = @[pdfController.openInButtonItem, pdfController.bookmarkButtonItem, pdfController.brightnessButtonItem, pdfController.printButtonItem, pdfController.emailButtonItem];
    return pdfController;
}

@end

@implementation UIColor (PSPDFCatalogAdditions)

+ (UIColor *)psc_mainColor {
    return [UIColor colorWithRed:0.f green:166.f/255.f blue:240.f/255.f alpha:1.f];
}

@end
