//
//  AppDelegate.m
//  PSPDFKitExample
//
//  Created by Peter Steinberger on 7/22/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "AppDelegate.h"
#import "PSPDFGridController.h"
#import "PSPDFMagazine.h"
#import "PSPDFMagazineFolder.h"
#import "PSPDFNavigationController.h"

#if TARGET_IPHONE_SIMULATOR
#import "DCIntrospect.h"
#endif

@interface AppDelegate()
@property (nonatomic, retain) NSArray *magazineFolders;
@end

@implementation AppDelegate

@synthesize magazineFolders = magazineFolders_;
@synthesize window = window_;
@synthesize navigationController = navigationController_;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (NSArray *)searchFolder:(NSString *)sampleFolder {
    NSError *error = nil;
    NSArray *documentContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sampleFolder error:&error];
    NSMutableArray *folders = [NSMutableArray array];
    PSPDFMagazineFolder *rootFolder = [PSPDFMagazineFolder folderWithTitle:[[NSURL fileURLWithPath:sampleFolder] lastPathComponent]];
    
    for (NSString *folder in documentContents) {
        // check if target path is a directory (all magazines are in directories)
        NSString *fullPath = [sampleFolder stringByAppendingPathComponent:folder];
        BOOL isDir;
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir]) {
            if (isDir) {
                PSPDFMagazineFolder *contentFolder = [PSPDFMagazineFolder folderWithTitle:[fullPath lastPathComponent]];
                NSArray *subDocumentContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folder error:&error];
                for (NSString *folder in subDocumentContents) {
                    PSPDFMagazine *magazine = [PSPDFMagazine magazineWithPath:fullPath];
                    [contentFolder addMagazine:magazine];
                }
                if ([contentFolder.magazines count]) {
                    [folders addObject:contentFolder];
                }
            }else {
                PSPDFMagazine *magazine = [PSPDFMagazine magazineWithPath:fullPath];
                [rootFolder addMagazine:magazine];
            }
        }
    }
    if ([rootFolder.magazines count]) {
        [folders addObject:rootFolder];
    }

    return folders;
}

// doesn't support deep hierarchies. Just root or a folder
- (NSArray *)searchForMagazineFolders {
    NSMutableArray *folders = [NSMutableArray array];
    
    NSString *sampleFolder = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Samples"];
    [folders addObjectsFromArray:[self searchFolder:sampleFolder]];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);    
    NSString *dirPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"downloads"];
    [folders addObjectsFromArray:[self searchFolder:dirPath]];

    // disable search on last magazine (as an example)
    [[[[folders lastObject] magazines] lastObject] setSearchEnabled:NO];
    
    return folders;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (void)dealloc {
    [gridController_ release];
    [magazineFolders_ release];
    [window_ release];
    [navigationController_ release];
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIApplicationDelegate

- (void)updateFolders; {    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        if (gridController_) {
            [gridController_.gridView reloadData];
        }
    });
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        
    // uncomment to enable PSPDFKitLogging. Defaults to PSPDFLogLevelError
    //kPSPDFKitDebugLogLevel = PSPDFLogLevelInfo;
    
    // enable to see the scrollviews semi-transparent
    //kPSPDFKitDebugScrollViews = YES;
    
    // create main grid and show!
    gridController_ = [[PSPDFGridController alloc] init];
    navigationController_ = [[PSPDFNavigationController alloc] initWithRootViewController:gridController_];
    window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window_.rootViewController = navigationController_;
    [window_ makeKeyAndVisible];
    
    // always call after makeKeyAndDisplay.
#if TARGET_IPHONE_SIMULATOR
    [[DCIntrospect sharedIntrospector] start];
#endif
    
    // in a production app, you'd better of to make this async.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        self.magazineFolders = [self searchForMagazineFolders];
        [self updateFolders];
    });
    
    NSString *cacheFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    PSELog(@"CacheDir: %@", cacheFolder);

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
