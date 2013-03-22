//
//  PSCAppDelegate.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSCAppDelegate.h"
#import "PSCatalogViewController.h"
#import <HockeySDK/HockeySDK.h>
#import "LocalyticsSession.h"
#import <DropboxSDK/DropboxSDK.h>
#import <objc/message.h>

#if !__has_feature(objc_arc)
#error "Compile this file with ARC"
#endif

@interface PSCAppDelegate () <BITHockeyManagerDelegate, BITUpdateManagerDelegate, BITCrashManagerDelegate> @end
@implementation PSCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSLog(@"Starting Catalog Example %@ with %@", appVersion, PSPDFVersionString());

    // Example how to localize strings in PSPDFKit.
    // See PSPDFKit.bundle/en.lproj/PSPDFKit.strings for all available strings.
    // You can also replace the strings in the PSPDFKit.bundle, but then make sure you merge your changes anytime the bundle is updated.
    // If you have created custom translations, feel free to submit them to peter@pspdfkit.com for inclusion.
    PSPDFSetLocalizationDictionary(@{@"en" :
                                   @{@"Go to %@" : @"%@",
                                     @"%d of %d" : @"Page %d of %d",
                                     @"%d-%d of %d" : @"Pages %d-%d of %d",
                                   }});

    // You can also customize localization with a block.
    // If you return nil, the default PSPDFKit language system will be used.
    PSPDFSetLocalizationBlock(^NSString *(NSString *stringToLocalize) {
        // This will look up strings in language/PSPDFKit.strings inside resources.
        // (In PSPDFCatalog, there are no such files, this is just to demonstrate best practice)
        return NSLocalizedStringFromTable(stringToLocalize, @"PSPDFKit", nil);
        //return [NSString stringWithFormat:@"_____%@_____", stringToLocalize];
    });

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
    NSURL *samplesURL = [[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"Samples"];
    PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
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

        // HockeyApp (http://hockeyapp.net) is a *great* service to manage crashes. It's well worth the money.
#if !defined(CONFIGURATION_Debug) && defined(PSPDF_USE_SOURCE)
        NSLog(@"This example project uses HockeyApp for crash reports and Localytics for user statistics. Make sure to either remove that or change the identifiers before shipping your app, if you use PSPDFCatalog/PSPDFKiosk as the foundation of your application.");
        [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"fa73e1f8f3806bcb3466c5ab16d70768" delegate:nil];
        [[BITHockeyManager sharedHockeyManager] crashManager].crashManagerStatus = BITCrashManagerStatusAutoSend;
        [[BITHockeyManager sharedHockeyManager] startManager];
#endif
        // Localytics helps me to track PSPDFCatalog launches
        // Remove this or replace with your own Localytics ID if you are using PSPDFCatalog as a template for your own app.
#ifndef PSPDF_USE_SOURCE
        [[LocalyticsSession sharedLocalyticsSession] startSession:@"3b7cb4552ea954d48d68f0e-3451f502-de39-11e1-4ab8-00ef75f32667"];
#else
#ifdef DEBUG
        // Only enabled during debugging.
        ((void(*)(id, SEL))objc_msgSend)(NSClassFromString(@"PSPDFHangDetector"), NSSelectorFromString(@"startHangDetector"));
#endif
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
        PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:launchURL];
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
- (NSString *)customDeviceIdentifierForUpdateManager:(BITUpdateManager *)updateManager {
#ifndef CONFIGURATION_AppStore
    if ([[UIDevice currentDevice] respondsToSelector:@selector(uniqueIdentifier)])
        return [[UIDevice currentDevice] performSelector:@selector(uniqueIdentifier)];
#endif
    return nil;
}

@end
