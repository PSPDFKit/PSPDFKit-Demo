//
//  PSCAppDelegate.m
//  PSPDFCatalog
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSCAppDelegate.h"
#import "PSCatalogViewController.h"
#import "BITHockeyManager.h"
#import "BITCrashManager.h"
#import "LocalyticsSession.h"

#if !__has_feature(objc_arc)
#error "Compile this file with ARC"
#endif

@implementation PSCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // print version of the catalog example and PSPDFKit.
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSLog(@"Starting Catalog Example %@ with %@", appVersion, PSPDFVersionString());


    // Example how to localize strings in PSPDFKit (default localization system won't work)
    // add custom localization changes (just a simple example)
    // See PSPDFKit.bundle for all available strings.
    PSPDFSetLocalizationDictionary(@{@"en" :
                                   @{@"Go to %@" : @"%@",
                                     @"%d of %d" : @"Page %d of %d",
                                     @"%d-%d of %d" : @"Pages %d-%d of %d",
                                   }});

    // change log level to be more verbose.
    kPSPDFLogLevel = PSPDFLogLevelInfo;

    // Enable if you're having memory issues.
    //kPSPDFLowMemoryMode = YES;

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
#if 0
    // Directly push a PSPDFViewController
    NSURL *samplesURL = [[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"Samples"];
    PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
    PSPDFViewController *viewController = [[PSPDFViewController alloc] initWithDocument:document];
    self.catalog = [[UINavigationController alloc] initWithRootViewController:viewController];
#else
    // Create catalog controller
    PSCatalogViewController *catalogController = [[PSCatalogViewController alloc] initWithStyle:UITableViewStyleGrouped];
    self.catalog = [[UINavigationController alloc] initWithRootViewController:catalogController];
#endif
    self.window.rootViewController = self.catalog;
    [self.window makeKeyAndVisible];

    // Opened with the Open In... feature?
    [self handleOpenURL:launchOptions[UIApplicationLaunchOptionsURLKey]];

    // print current cache dir
    NSString *cacheFolder = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSLog(@"Cache Folder: %@", cacheFolder);

    // Perform non-important actions on the next runloop, for faster app-starting.
    dispatch_async(dispatch_get_main_queue(), ^{
        // Localytics helps me to track PSPDFCatalog launches
        // Remove this or replace with your own Localytics ID if you are using PSPDFCatalog as a template for your own app.
#ifndef PSPDF_USE_SOURCE
        [[LocalyticsSession sharedLocalyticsSession] startSession:@"3b7cb4552ea954d48d68f0e-3451f502-de39-11e1-4ab8-00ef75f32667"];

        // HockeyApp (http://hockeyapp.net) is a *great* service to manage crashes. It's well worth the money.
        // If you use it, download your own current version of the HockeySDK!
        // This version has been modified to work w/o a dSYM (but will not show line numbers)
        [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"fa73e1f8f3806bcb3466c5ab16d70768" delegate:nil];
        [[BITHockeyManager sharedHockeyManager] crashManager].crashManagerStatus = BITCrashManagerStatusAutoSend;
        [[BITHockeyManager sharedHockeyManager] startManager];
#else
        // useful for debugging
        [PSPDFHangDetector startHangDetector];
#endif
    });
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)URL sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"Open %@ from %@ (annotation: %@)", URL, sourceApplication, annotation);
    return [self handleOpenURL:URL];
}

- (BOOL)handleOpenURL:(NSURL *)launchPDFURL {
    if ([launchPDFURL isFileURL] && [[NSFileManager defaultManager] fileExistsAtPath:[launchPDFURL path]]) {
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:launchPDFURL];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        [self.catalog popToRootViewControllerAnimated:NO];
        [self.catalog pushViewController:pdfController animated:NO];
        return YES;
    }
    return NO;
}

@end
