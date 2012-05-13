//
//  PSPDFAppDelegate.m
//  TabbedExample
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFAppDelegate.h"
#import "PSPDFTabbedExampleViewController.h"

@implementation PSPDFAppDelegate

@synthesize window = window_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *samplesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Samples"];
    PSPDFDocument *document1 = [PSPDFDocument PDFDocumentWithUrl:[NSURL fileURLWithPath:[samplesPath stringByAppendingPathComponent:@"PSPDFKit.pdf"]]];
    PSPDFDocument *document2 = [PSPDFDocument PDFDocumentWithUrl:[NSURL fileURLWithPath:[samplesPath stringByAppendingPathComponent:@"macbook_air_users_guide.pdf"]]];
    PSPDFDocument *document3 = [PSPDFDocument PDFDocumentWithUrl:[NSURL fileURLWithPath:[samplesPath stringByAppendingPathComponent:@"amazon-dynamo-sosp2007.pdf"]]];
    PSPDFDocument *document4 = [PSPDFDocument PDFDocumentWithUrl:[NSURL fileURLWithPath:[samplesPath stringByAppendingPathComponent:@"DevelopersGuide.pdf"]]];

    NSArray *documents = [NSArray arrayWithObjects:document1, document2, document3, document4, nil];
    PSPDFTabbedExampleViewController *tabbedController = [[PSPDFTabbedExampleViewController alloc] initWithDocuments:documents pdfViewController:nil];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:tabbedController];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
