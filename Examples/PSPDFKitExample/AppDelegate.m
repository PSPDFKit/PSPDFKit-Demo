//
//  AppDelegate.m
//  PSPDFKitExample
//
//  Created by Peter Steinberger on 7/22/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
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

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    PSPDFLog(@"Kiosk Example is starting up...");
    
    // setup disk saving url cache
    SDURLCache *URLCache = [[SDURLCache alloc] initWithMemoryCapacity:1024*1024   // 1MB mem cache
                                                         diskCapacity:1024*1024*5 // 5MB disk cache
                                                             diskPath:[SDURLCache defaultCachePath]];
    [NSURLCache setSharedURLCache:URLCache];
    
    // uncomment to enable PSPDFKitLogging. Defaults to PSPDFLogLevelError
    kPSPDFKitDebugLogLevel = PSPDFLogLevelInfo;
    
    // enable to see the scrollviews semi-transparent
    //kPSPDFKitDebugScrollViews = YES;
    
    // enable to see memory usage
    //kPSPDFKitDebugMemory = YES;
    
    // enable to change anomations (e.g. enable on iPad1)
    //kPSPDFAnimateOption = PSPDFAnimateEverywhere;
    
    // setup device specific defaults
    [PSPDFSettingsController setupDefaults];
    
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

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
