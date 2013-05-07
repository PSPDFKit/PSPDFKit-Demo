//
//  PSCAppDelegate.m
//  PSPDFKiosk
//
//  Created by Peter Steinberger on 12/14/12.
//  Copyright (c) 2012 PSPDFKit. All rights reserved.
//

#import "PSCAppDelegate.h"
#import "PSCGridViewController.h"

@implementation PSCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    PSCGridViewController *gridController = [[PSCGridViewController alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:gridController];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
