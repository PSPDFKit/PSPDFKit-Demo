//
//  PSCAppDelegate.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSCAppDelegate.h"
#import "PSCatalogViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import <objc/message.h>
#ifdef HOCKEY_ENABLED
#import <HockeySDK/HockeySDK.h>
#endif
#if !__has_feature(objc_arc)
#error "Compile this file with ARC"
#endif

@interface PSCAppDelegate ()
#ifdef HOCKEY_ENABLED
<BITHockeyManagerDelegate, BITUpdateManagerDelegate, BITCrashManagerDelegate>
#endif
@end
@implementation PSCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSLog(@"Starting Catalog Example %@ with %@", appVersion, PSPDFVersionString());

    // Example how to localize strings in PSPDFKit.
    // See PSPDFKit.bundle/en.lproj/PSPDFKit.strings for all available strings.
    // You can also replace the strings in the PSPDFKit.bundle, but then make sure you merge your changes anytime the bundle is updated.
    // If you have created custom translations, feel free to submit them to peter@pspdfkit.com for inclusion.
    PSPDFSetLocalizationDictionary(@{@"en" :
                                   @{@"%d of %d" : @"Page %d of %d",
                                     @"%d-%d of %d" : @"Pages %d-%d of %d",
                                   }});

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
    kPSPDFLogLevel = PSPDFLogLevelInfo;

    // Clear cache, better debugging
    //[PSPDFCache.sharedCache clearCache];
#endif

    // Enable if you're having memory issues.
    //kPSPDFLowMemoryMode = YES;

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

#if 0
    // Directly push a PSPDFViewController
    NSURL *samplesURL = [[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"Samples" isDirectory:NO];
    PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample isDirectory:YES]];
    PSPDFViewController *viewController = [[PSPDFViewController alloc] initWithDocument:document];
    self.catalog = [[UINavigationController alloc] initWithRootViewController:viewController];
#else
    // Create catalog controller
    PSCatalogViewController *catalogController = [[PSCatalogViewController alloc] initWithStyle:UITableViewStyleGrouped];
    // PSPDFNavigationController is a simple subclass that forwards iOS6 rotation methods.
    self.catalog = [[PSPDFNavigationController alloc] initWithRootViewController:catalogController];
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
        // HockeyApp (http://hockeyapp.net) is a *great* service to manage crashes and distribute beta builds. It's well worth the money.
#if !defined(CONFIGURATION_Debug) && defined(PSPDF_USE_SOURCE) && defined(HOCKEY_ENABLED)
        NSLog(@"This example project uses HockeyApp for crash reports and Localytics for user statistics. Make sure to either remove that or change the identifiers before shipping your app, if you use PSPDFCatalog/PSPDFKiosk as the foundation of your application.");
        [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"fa73e1f8f3806bcb3466c5ab16d70768" delegate:nil];
        [[BITHockeyManager sharedHockeyManager] crashManager].crashManagerStatus = BITCrashManagerStatusAutoSend;
        [[BITHockeyManager sharedHockeyManager] startManager];
#endif
#if defined(PSPDF_USE_SOURCE) && defined(DEBUG)
        // Only enabled during debugging.
        ((void(*)(id, SEL))objc_msgSend)(NSClassFromString(@"PSPDFHangDetector"), NSSelectorFromString(@"startHangDetector"));
#endif
    });
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)URL sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"Open %@ from %@ (annotation: %@)", URL, sourceApplication, annotation);
    return [self handleOpenURL:URL];
}

- (BOOL)handleOpenURL:(NSURL *)launchURL {
    // Add Dropbox hook
    if ([[DBSession sharedSession] handleOpenURL:launchURL]) {
        if ([[DBSession sharedSession] isLinked]) {
            PSCLog(@"App linked successfully!");
        }
        return YES;
    }

    // Directly open the PDF.
    if ([launchURL isFileURL] && [[NSFileManager defaultManager] fileExistsAtPath:[launchURL path]]) {
        PSPDFDocument *document = [PSPDFDocument documentWithURL:launchURL];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.rightBarButtonItems = @[pdfController.searchButtonItem, pdfController.outlineButtonItem, pdfController.annotationButtonItem, pdfController.viewModeButtonItem];
        pdfController.additionalBarButtonItems = @[pdfController.openInButtonItem, pdfController.bookmarkButtonItem, pdfController.brightnessButtonItem, pdfController.printButtonItem, pdfController.emailButtonItem];
        [self.catalog popToRootViewControllerAnimated:NO];
        [self.catalog pushViewController:pdfController animated:NO];
        return YES;
    }
    return NO;
}

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
