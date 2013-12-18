//
//  PSCAppDelegate.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAppDelegate.h"
#import "PSCatalogViewController.h"

#ifdef HOCKEY_ENABLED
#import <HockeySDK/HockeySDK.h>
@interface PSCAppDelegate () <BITHockeyManagerDelegate, BITUpdateManagerDelegate, BITCrashManagerDelegate> @end
#endif

@implementation PSCAppDelegate

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Example how to localize strings in PSPDFKit.
    // See PSPDFKit.bundle/en.lproj/PSPDFKit.strings for all available strings.
    PSPDFSetLocalizationDictionary(@{@"en" : @{@"%d of %d" : @"Page %d of %d",
                                              @"%d-%d of %d" : @"Pages %d-%d of %d"}});

    // You can also customize localization with a block.
    // If you return nil, the default PSPDFKit language system will be used.
    /*
     PSPDFSetLocalizationBlock(^NSString *(NSString *stringToLocalize) {
     // This will look up strings in language/PSPDFKit.strings inside resources.
     // (In PSPDFCatalog, there are no such files, this is just to demonstrate best practice)
     return NSLocalizedStringFromTable(stringToLocalize, @"PSPDFKit", nil);
     //return [NSString stringWithFormat:@"_____%@_____", stringToLocalize];
     });
     */

    // Change log level to be more verbose.
#ifdef DEBUG
    PSPDFLogLevel = PSPDFLogLevelMaskInfo|PSPDFLogLevelMaskWarning|PSPDFLogLevelMaskError;
    //[PSPDFCache.sharedCache clearCache];
    //NSLog(@"Cache: %@", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]);
#endif

    // Enable if you're having memory issues.
    //PSPDFLowMemoryMode = YES;

    // Set your license key here. PSPDFKit is commercial software.
    // Each PSPDFKit license is bound to a specific app bundle id.
    // Visit http://customers.pspdfkit.com to get your license key.
    PSPDFSetLicenseKey("DEMO");

    // Create catalog controller
    PSCatalogViewController *catalogController = [[PSCatalogViewController alloc] initWithStyle:UITableViewStyleGrouped];
    // PSPDFNavigationController is a simple subclass that forwards iOS6 rotation methods.
    self.catalog = [[PSPDFNavigationController alloc] initWithRootViewController:catalogController];
    self.window  = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = self.catalog;
    [self.window makeKeyAndVisible];

    // Enable global Undo/Redo
    application.applicationSupportsShakeToEdit = YES;

    // Opened with the Open In... feature?
    [self handleOpenURL:launchOptions[UIApplicationLaunchOptionsURLKey]];

    // HockeyApp (http://hockeyapp.net) is a *great* service to manage crashes and distribute beta builds. It's well worth the money.
#if !defined(CONFIGURATION_Debug) && defined(PSPDF_USE_SOURCE) && defined(HOCKEY_ENABLED)
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"This example project uses HockeyApp for crash reports and Localytics for user statistics. Make sure to either remove that or change the identifiers before shipping your app, if you use PSPDFCatalog/PSPDFKiosk as the foundation of your application.");
        [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"fa73e1f8f3806bcb3466c5ab16d70768" delegate:nil];
        [[BITHockeyManager sharedHockeyManager] crashManager].crashManagerStatus = BITCrashManagerStatusAutoSend;
        [[BITHockeyManager sharedHockeyManager] startManager];
    });
#endif

    // Receive callbacks for viewing signature revisions.
    [PSPDFDigitalSignatureManager.sharedManager registerForReceivingRequestsToViewRevisions:self];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)URL sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"Open %@ from %@ (annotation: %@)", URL, sourceApplication, annotation);
    return [self handleOpenURL:URL];
}

- (BOOL)handleOpenURL:(NSURL *)launchURL {
    // Directly open the PDF.
    if (launchURL.isFileURL && [[NSFileManager defaultManager] fileExistsAtPath:[launchURL path]]) {
        PSPDFDocument *document = [PSPDFDocument documentWithURL:launchURL];
        PSPDFViewController *pdfController = [self viewControllerForDocument:document];
        [self.catalog popToRootViewControllerAnimated:NO];
        [self.catalog pushViewController:pdfController animated:NO];
        return YES;
    }else if ([launchURL.scheme.lowercaseString isEqualToString:@"pspdfcatalog"]) {
        [[[UIAlertView alloc] initWithTitle:@"Custom Protocol Handler" message:launchURL.absoluteString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
    return NO;
}

- (PSPDFViewController *)viewControllerForDocument:(PSPDFDocument *)document {
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    pdfController.rightBarButtonItems = @[pdfController.searchButtonItem, pdfController.outlineButtonItem, pdfController.annotationButtonItem, pdfController.viewModeButtonItem];
    pdfController.additionalBarButtonItems = @[pdfController.openInButtonItem, pdfController.bookmarkButtonItem, pdfController.brightnessButtonItem, pdfController.printButtonItem, pdfController.emailButtonItem];
    return pdfController;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFDigitalSignatureRevisionDelegate

- (void)pdfRevisionRequested:(PSPDFDocument *)pdf {
    PSPDFViewController *controller = [self viewControllerForDocument:pdf];
    [self.catalog pushViewController:controller animated:YES];
}

// If you need to block certain interface orientation, that's the place you want to add it.
/*
 - (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
 return UIInterfaceOrientationMaskPortrait;
 }
 */

#pragma mark - BITUpdateManagerDelegate
#ifdef HOCKEY_ENABLED
- (NSString *)customDeviceIdentifierForUpdateManager:(BITUpdateManager *)updateManager {
#ifndef CONFIGURATION_AppStore
    // This is only for Hockey app deployment for beta testing. Using uniqueIdentifier in AppStore apps is not allowed and will get your app rejected.
    if ([[UIDevice currentDevice] respondsToSelector:@selector(uniqueIdentifier)])
        return [[UIDevice currentDevice] performSelector:@selector(uniqueIdentifier)];
#endif
    return nil;
}
#endif

@end
