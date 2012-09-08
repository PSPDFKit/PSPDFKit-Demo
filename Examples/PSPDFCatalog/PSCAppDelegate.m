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

@implementation PSCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // print version of the catalog example and PSPDFKit.
    NSString *appVersion = [[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSLog(@"Starting Catalog Example %@ with %@", appVersion, PSPDFVersionString());


    // Example how to localize strings in PSPDFKit (default localization system won't work)
    // add custom localization changes (just a simple example)
    // See PSPDFKit.bundle for all available strings.
    PSPDFSetLocalizationDictionary(@{@"en" :
                                   @{@"Go to %@" : @"Browse %@",
                                     @"%d of %d" : @"Page %d of %d",
                                     @"Outline"  : @"Table of Contents"
                                   }});
    
    // enable to change animations (e.g. enable on iPad1)
    kPSPDFAnimateOption = PSPDFAnimateEverywhere;

    // change log level to be more verbose.
    kPSPDFLogLevel = PSPDFLogLevelInfo;

    // Create catalog controller
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    PSCatalogViewController *catalogController = [[PSCatalogViewController alloc] initWithStyle:UITableViewStyleGrouped];
    self.catalog = [[UINavigationController alloc] initWithRootViewController:catalogController];
    self.window.rootViewController = self.catalog;
    [self.window makeKeyAndVisible];

    // print current cache dir
    NSString *cacheFolder = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSLog(@"Cache Folder: %@", cacheFolder);

    // Perform non-important actions on the next runloop, for faster app-starting.
    dispatch_async(dispatch_get_main_queue(), ^{

        // HockeyApp is a *great* service to manage crashes. It's well worth the money.
        // If you use it, download your own, current version of the HockeySDK.
        // This version has been modified to work w/o a dSYM (but will not show line numbers)
        // http://hockeyapp.net
        [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"fa73e1f8f3806bcb3466c5ab16d70768" delegate:nil];
        [BITHockeyManager sharedHockeyManager].crashManager.crashManagerStatus = BITCrashManagerStatusAutoSend;
        [[BITHockeyManager sharedHockeyManager] startManager];

        // Localytics helps me to track PSPDFKit-DEMO downloads.
        // Remove this or replace with your own Localytics ID if you are using PSPDFKitExample as a template for your own app.
        [[LocalyticsSession sharedLocalyticsSession] startSession:@"3b7cb4552ea954d48d68f0e-3451f502-de39-11e1-4ab8-00ef75f32667"];

        // useful for debugging
        #ifdef DEBUG
        [PSPDFHangDetector startHangDetector];
        #endif
    });
    return YES;
}

@end
