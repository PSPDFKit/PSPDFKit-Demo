//
//  MinimalExampleAppDelegate.m
//  MinimalExample
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "MinimalExampleAppDelegate.h"

@implementation MinimalExampleAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // create the PSPDFViewController
    NSString *path = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Samples"] stringByAppendingPathComponent:@"PSPDFKit.pdf"];
    PSPDFDocument *document = [PSPDFDocument PDFDocumentWithUrl:[NSURL fileURLWithPath:path]];
    PSPDFViewController *pdfController = [[PSMinimalExamplePDFViewController alloc] initWithDocument:document];
    pdfController.pageCurlEnabled = YES;
    
    // create window and set as rootViewController
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:pdfController];
    [self.window makeKeyAndVisible];
    return YES;
}

@end

// this is one way of overriding PSPDFViewController. However, subclassing is advised
@implementation PSMinimalExamplePDFViewController

- (UIBarButtonItem *)toolbarBackButton { return nil; }

@end
