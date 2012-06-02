//
//  MinimalExampleAppDelegate.m
//  MinimalExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "MinimalExampleAppDelegate.h"

@implementation MinimalExampleAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // create the PSPDFViewController
    NSString *path = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Samples"] stringByAppendingPathComponent:@"PSPDFKit.pdf"];
    PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[NSURL fileURLWithPath:path]];
    NSLog(@"isEncryped:%d", document.isEncrypted);
    //[document appendFile:@"DevelopersGuide.pdf"];

    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    pdfController.pageCurlEnabled = YES;
    pdfController.linkAction = PSPDFLinkActionInlineBrowser;
    pdfController.leftBarButtonItems = nil; // hide close button

    // create window and set as rootViewController
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:pdfController];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
