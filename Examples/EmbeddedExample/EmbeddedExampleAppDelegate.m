//
//  EmbeddedExampleAppDelegate.m
//  EmbeddedExample
//
//  Created by Peter Steinberger on 8/4/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "EmbeddedExampleAppDelegate.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "IntelligentSplitViewController.h"
#import "SplitTableViewController.h"
#import "SplitMasterViewController.h"
#import <PSPDFKit/PSPDFKit.h>

@implementation EmbeddedExampleAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.backgroundColor = [UIColor blackColor];
    self.window.rootViewController = self.tabBarController;
    
    // uncomment to enable PSPDFKitLogging. Defaults to PSPDFLogLevelError
    kPSPDFKitDebugLogLevel = PSPDFLogLevelInfo;
    
    // add items to tabbar
    FirstViewController *firstVC = [[[FirstViewController alloc] initWithNibName:@"FirstView" bundle:nil] autorelease];
    UINavigationController *firstNavVC = [[[UINavigationController alloc] initWithRootViewController:firstVC] autorelease];
    
    
    NSString *path = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Samples"] stringByAppendingPathComponent:@"macbook_air_users_guide.pdf"];
    PSPDFDocument *document = [PSPDFDocument PDFDocumentWithUrl:[NSURL fileURLWithPath:path]];
    SecondViewController *pdfController = [[[SecondViewController alloc] initWithDocument:document] autorelease];
    UINavigationController *secondVC = [[[UINavigationController alloc] initWithRootViewController:pdfController] autorelease];
    
    if (PSIsIpad()) {
        
        // create and configure splitview
        IntelligentSplitViewController *splitVC = [[[IntelligentSplitViewController alloc] init] autorelease];

        splitVC.tabBarItem = [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:3] autorelease];
        
        SplitTableViewController *tableVC = [[[SplitTableViewController alloc] init] autorelease];
        UINavigationController *tableNavVC = [[[UINavigationController alloc] initWithRootViewController:tableVC] autorelease];
        SplitMasterViewController *hostVC = [[[SplitMasterViewController alloc] init] autorelease];
        UINavigationController *hostNavVC = [[[UINavigationController alloc] initWithRootViewController:hostVC] autorelease];
        tableVC.masterVC = hostVC;
        splitVC.delegate = hostVC;
        
        splitVC.viewControllers = [NSArray arrayWithObjects:tableNavVC, hostNavVC, nil];

        [self.tabBarController setViewControllers:[NSArray arrayWithObjects:firstNavVC, secondVC, splitVC, nil] animated:NO];
    }else { 
        [self.tabBarController setViewControllers:[NSArray arrayWithObjects:firstNavVC, secondVC, nil] animated:NO];
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc {
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

/*
 // Optional UITabBarControllerDelegate method.
 - (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
 }
 */

/*
 // Optional UITabBarControllerDelegate method.
 - (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
 }
 */

@end
