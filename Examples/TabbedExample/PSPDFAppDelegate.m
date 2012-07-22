//
//  PSPDFAppDelegate.m
//  TabbedExample
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFAppDelegate.h"
#import "PSPDFTabbedExampleViewController.h"
#import "PSPDFDocumentSelectorController.h"

@implementation PSPDFAppDelegate

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    if (PSIsIpad()) {
        PSPDFTabbedExampleViewController *tabbedController = [PSPDFTabbedExampleViewController new];

        // choose *some* documents randomly if state could not be restored.
        if (![tabbedController restoreState]) {
            NSArray *documents = [PSPDFDocumentSelectorController documentsFromDirectory:@"Samples"];
            tabbedController.documents = [documents filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                return arc4random_uniform(2) > 0; // returns 0 or 1 randomly.
            }]];
        }        
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:tabbedController];
    }else {
        // on iPhone, we do things a bit different, and push/pull the controller.
        PSPDFDocumentSelectorController *documentsController = [[PSPDFDocumentSelectorController alloc] init];
        documentsController.delegate = self;
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:documentsController];
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFDocumentSelectorControllerDelegate

- (void)PDFDocumentSelectorController:(PSPDFDocumentSelectorController *)controller didSelectDocument:(PSPDFDocument *)document {
    // create controller and merge new documents with last saved state.
    PSPDFTabbedViewController *tabbedViewController = [PSPDFTabbedExampleViewController new];
    [tabbedViewController restoreStateAndMergeWithDocuments:[NSArray arrayWithObject:document]];

    // add fade transition for navigationBar.
    CATransition *fadeTransition = [CATransition animation];
    fadeTransition.duration = 0.25f;
    fadeTransition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    fadeTransition.type = kCATransitionFade;
    fadeTransition.subtype = kCATransitionFromTop;
    [controller.navigationController.navigationBar.layer addAnimation:fadeTransition forKey:kCATransition];

    [controller.navigationController pushViewController:tabbedViewController animated:YES];
}

@end
