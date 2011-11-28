//
//  AppDelegate.m
//  EmbeddedExample
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "AppDelegate.h"
#import "PSPDFEmbeddedTestController.h"
#import "PSPDFCustomToolbarController.h"
#import "PSPDFAnnotationTestController.h"
#import "IntelligentSplitViewController.h"
#import "SplitTableViewController.h"
#import "SplitMasterViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.backgroundColor = [UIColor blackColor];
    self.window.rootViewController = self.tabBarController;
    
    // uncomment to enable PSPDFKitLogging. Defaults to PSPDFLogLevelError
    //kPSPDFKitDebugLogLevel = PSPDFLogLevelInfo;
    
    // uncomment to see extended memory debug info. only meant for debugging!
    //kPSPDFKitDebugMemory = YES;
    
    // add items to tabbar
    PSPDFEmbeddedTestController *firstVC = [[[PSPDFEmbeddedTestController alloc] initWithNibName:@"FirstView" bundle:nil] autorelease];
    UINavigationController *firstNavVC = [[[UINavigationController alloc] initWithRootViewController:firstVC] autorelease];
    
    NSString *path = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Samples"] stringByAppendingPathComponent:@"macbook_air_users_guide.pdf"];
    PSPDFDocument *document = [PSPDFDocument PDFDocumentWithUrl:[NSURL fileURLWithPath:path]];
    PSPDFCustomToolbarController *pdfController = [[[PSPDFCustomToolbarController alloc] initWithDocument:document] autorelease];
    UINavigationController *secondVC = [[[UINavigationController alloc] initWithRootViewController:pdfController] autorelease];

     NSString *videoPath = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Samples"] stringByAppendingPathComponent:@"PSPDFKit.pdf"];
    PSPDFDocument *videoDocument = [PSPDFDocument PDFDocumentWithUrl:[NSURL fileURLWithPath:videoPath]];
    PSPDFAnnotationTestController *videoVC = [[[PSPDFAnnotationTestController alloc] initWithDocument:videoDocument] autorelease];
    UINavigationController *videoNavC = [[[UINavigationController alloc] initWithRootViewController:videoVC] autorelease];
    
    if (PSIsIpad()) {
        // create and configure splitview
        IntelligentSplitViewController *splitVC = [[[IntelligentSplitViewController alloc] init] autorelease];
        splitVC.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Split" image:[UIImage imageNamed:@"44-shoebox"] tag:3] autorelease];
        SplitTableViewController *tableVC = [[[SplitTableViewController alloc] init] autorelease];
        UINavigationController *tableNavVC = [[[UINavigationController alloc] initWithRootViewController:tableVC] autorelease];
        SplitMasterViewController *hostVC = [[[SplitMasterViewController alloc] init] autorelease];
        UINavigationController *hostNavVC = [[[UINavigationController alloc] initWithRootViewController:hostVC] autorelease];
        tableVC.masterVC = hostVC;
        splitVC.delegate = hostVC;
        splitVC.viewControllers = [NSArray arrayWithObjects:tableNavVC, hostNavVC, nil];
        [self.tabBarController setViewControllers:[NSArray arrayWithObjects:firstNavVC, secondVC, splitVC, videoNavC, nil] animated:NO];
    }else { 
        [self.tabBarController setViewControllers:[NSArray arrayWithObjects:firstNavVC, secondVC, videoNavC, nil] animated:NO];
    }
    
    [self.window makeKeyAndVisible];
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

- (void)dealloc {
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

@end
