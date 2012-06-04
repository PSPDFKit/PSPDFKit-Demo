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

@synthesize window = window_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    if (PSIsIpad()) {

        // choose *some* documents randomly.
        NSArray *documents = [PSPDFDocumentSelectorController documentsFromDirectory:@"Samples"];
        documents = [documents filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return arc4random_uniform(2) > 0;
        }]];

        PSPDFTabbedExampleViewController *tabbedController = [[PSPDFTabbedExampleViewController alloc] initWithDocuments:documents pdfViewController:nil];
        
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

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFDocumentSelectorControllerDelegate

- (void)PDFDocumentSelectorController:(PSPDFDocumentSelectorController *)controller didSelectDocument:(PSPDFDocument *)document {
    PSPDFTabbedViewController *tabbedViewController = [[PSPDFTabbedExampleViewController alloc] initWithDocuments:[NSArray arrayWithObject:document] pdfViewController:nil];
    tabbedViewController.visibleDocument = document;

    [controller.navigationController pushViewController:tabbedViewController animated:YES];
}

@end
