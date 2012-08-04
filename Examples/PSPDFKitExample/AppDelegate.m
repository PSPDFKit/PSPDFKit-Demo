//
//  AppDelegate.m
//  PSPDFKitExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "AppDelegate.h"
#import "PSPDFGridController.h"
#import "PSPDFSettingsController.h"
#import "SDURLCache.h"
#import "BITHockeyManager.h"
#import "LocalyticsSession.h"

// can also be read from Info.plist, etc...
#define kAppVersionKey @"AppVersion"
#define kAppVersion 17

@implementation AppDelegate

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

// it's advised to clear the cache before updating PSPDFKit.
- (void)clearCacheOnUpgrade {
    if ([[NSUserDefaults standardUserDefaults] integerForKey:kAppVersionKey] < kAppVersion) {
        NSLog(@"clearing cache because of new install/upgrade.");
        [[PSPDFCache sharedCache] clearCache]; // thread-safe.
        
        // save new version number
        [[NSUserDefaults standardUserDefaults] setInteger:kAppVersion forKey:kAppVersionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

// this is an example how to override the few keywords in PSPDFKit.
// you can also change the contents of the PSPDFKit.bundle, but you need to re-do this after every update
- (void)addCustomLocalization {
    // prepare the dictionary structure (here, we only add en, which is the fallback)
    NSMutableDictionary *localizationDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSMutableDictionary *enLocalizationDict = [NSMutableDictionary dictionaryWithCapacity:1];
    localizationDict[@"en"] = enLocalizationDict;
    
    // add localization content
    enLocalizationDict[@"Documents"] = @"Magazines";
    PSPDFSetLocalizationDictionary(localizationDict);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // setup disk saving url cache
    SDURLCache *URLCache = [[SDURLCache alloc] initWithMemoryCapacity:1024*1024   // 1MB mem cache
                                                         diskCapacity:1024*1024*5 // 5MB disk cache
                                                             diskPath:[SDURLCache defaultCachePath]];
    URLCache.ignoreMemoryOnlyStoragePolicy = YES;
    [NSURLCache setSharedURLCache:URLCache];
    
    // uncomment to enable PSPDFKitLogging. Defaults to PSPDFLogLevelError
    kPSPDFLogLevel = PSPDFLogLevelInfo;
    //kPSPDFLogLevel = PSPDFLogLevelVerbose;
    NSString *appVersion = [[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSLog(@"Kiosk Example %@ starting up... [%@]", appVersion, PSPDFVersionString());
    
    // enable to see the scrollviews semi-transparent
    //kPSPDFKitDebugScrollViews = YES;
    
    // enable to see memory usage
    //kPSPDFKitDebugMemory = YES;
    
    // enable to change anomations (e.g. enable on iPad1)
    kPSPDFAnimateOption = PSPDFAnimateEverywhere;
        
    // add custom localization changes
    [self addCustomLocalization];

    // check if system was updated to iOS 5.0.1 or higher to migrate data (iCloud Backup issue)
    // WARNING. This should be done async instead - be careful if you hava a large dataset.
    // See https://developer.apple.com/library/ios/#qa/qa1719/_index.html
    BOOL migrated = [PSPDFStoreManager checkAndIfNeededMigrateStoragePathBlocking:YES completionBlock:nil];
    if (migrated) {
        PSPDFLog(@"Just migrated storage data.");
    }
    
    // create main grid and show!
    gridController_ = [[PSPDFGridController alloc] init];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:gridController_];
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.rootViewController = _navigationController;
    [_window makeKeyAndVisible];
    
    NSString *cacheFolder = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSLog(@"CacheDir: %@", cacheFolder);
    
    // set white status bar style when not on ipad
    if (!PSIsIpad()) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    }
    
    // after a version upgrade, reset the cache
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self clearCacheOnUpgrade];

        // HockeyApp is a *great* service to manage crashes. It's well worth the money.
        // If you use it, download your own, current version of the HockeySDK.
        // This version has been modified to work w/o a dSYM (but will not show line numbers)
        // http://hockeyapp.net
        [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"fa73e1f8f3806bcb3466c5ab16d70768" delegate:nil];
        [[BITHockeyManager sharedHockeyManager] startManager];

        // Localytics helps me to track PSPDFKit-DEMO downloads.
        // Remove this or replace with your own Localytics ID if you are using PSPDFKitExample as a template for your own app.
        [[LocalyticsSession sharedLocalyticsSession] startSession:@"3b7cb4552ea954d48d68f0e-3451f502-de39-11e1-4ab8-00ef75f32667"];
    });

    // useful for debugging
#ifdef DEBUG
    [PSPDFHangDetector startHangDetector];
#endif
    
    return YES;
}

@end
