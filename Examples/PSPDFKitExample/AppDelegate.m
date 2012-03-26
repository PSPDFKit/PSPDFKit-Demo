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

// can also be read from Info.plist, etc...
#define kAppVersionKey @"AppVersion"
#define kAppVersion 17

@implementation AppDelegate

@synthesize window = window_;
@synthesize navigationController = navigationController_;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

// it's advised to clear the cache before updating PSPDFKit.
- (void)clearCacheOnUpgrade {
    if ([[NSUserDefaults standardUserDefaults] integerForKey:kAppVersionKey] < kAppVersion) {
        NSLog(@"clearing cache because of new install/upgrade.");
        [[PSPDFCache sharedPSPDFCache] clearCache]; // thread-safe.
        
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
    [localizationDict setObject:enLocalizationDict forKey:@"en"];
    
    // add localization content
    [enLocalizationDict setObject:@"Magazines" forKey:@"Documents"];
    PSPDFSetLocalizationDictionary(localizationDict);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // setup disk saving url cache
    SDURLCache *URLCache = [[SDURLCache alloc] initWithMemoryCapacity:1024*1024   // 1MB mem cache
                                                         diskCapacity:1024*1024*5 // 5MB disk cache
                                                             diskPath:[SDURLCache defaultCachePath]];
    [NSURLCache setSharedURLCache:URLCache];
    
    // uncomment to enable PSPDFKitLogging. Defaults to PSPDFLogLevelError
    kPSPDFLogLevel = PSPDFLogLevelInfo;
    //kPSPDFLogLevel = PSPDFLogLevelVerbose;
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    PSPDFLog(@"Kiosk Example %@ is starting up... [PSPDFKit Version %@]", appVersion, PSPDFVersionString());
    
    // enable to see the scrollviews semi-transparent
    //kPSPDFKitDebugScrollViews = YES;
    
    // enable to see memory usage
    //kPSPDFKitDebugMemory = YES;
    
    // enable to change anomations (e.g. enable on iPad1)
    kPSPDFAnimateOption = PSPDFAnimateEverywhere;
    
    // setup device specific defaults
    [PSPDFSettingsController setupDefaults];
    
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
    navigationController_ = [[UINavigationController alloc] initWithRootViewController:gridController_];
    window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window_.rootViewController = navigationController_;
    [window_ makeKeyAndVisible];
    
    NSString *cacheFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    PSELog(@"CacheDir: %@", cacheFolder);
    
    // set white status bar style when not on ipad
    if (!PSIsIpad()) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    }
    
    // after a version upgrade, reset the cache
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self clearCacheOnUpgrade];
    });
    
    return YES;
}

@end
