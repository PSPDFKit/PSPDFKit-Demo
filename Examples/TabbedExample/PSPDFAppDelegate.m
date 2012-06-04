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
        NSString *samplesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Samples"];
        PSPDFDocument *document1 = [PSPDFDocument PDFDocumentWithUrl:[NSURL fileURLWithPath:[samplesPath stringByAppendingPathComponent:@"PSPDFKit.pdf"]]];
        PSPDFDocument *document2 = [PSPDFDocument PDFDocumentWithUrl:[NSURL fileURLWithPath:[samplesPath stringByAppendingPathComponent:@"macbook_air_users_guide.pdf"]]];
        PSPDFDocument *document3 = [PSPDFDocument PDFDocumentWithUrl:[NSURL fileURLWithPath:[samplesPath stringByAppendingPathComponent:@"amazon-dynamo-sosp2007.pdf"]]];
        PSPDFDocument *document4 = [PSPDFDocument PDFDocumentWithUrl:[NSURL fileURLWithPath:[samplesPath stringByAppendingPathComponent:@"DevelopersGuide.pdf"]]];
        
        NSArray *documents = [NSArray arrayWithObjects:document1, document2, document3, document4, nil];
        PSPDFTabbedExampleViewController *tabbedController = [[PSPDFTabbedExampleViewController alloc] initWithDocuments:documents pdfViewController:nil];
        
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:tabbedController];
    }else {
        // on iPhone, we do things a bit different
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

    [controller.navigationController pushViewController:tabbedViewController animated:YES];
}

@end
