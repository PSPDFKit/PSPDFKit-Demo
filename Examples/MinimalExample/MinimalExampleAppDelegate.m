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
    NSString *path = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Samples"] stringByAppendingPathComponent:@"hackermonthly12.pdf"];
    PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:[NSURL fileURLWithPath:path]];
    PSPDFViewController *pdfController = [[[PSPDFViewController alloc] initWithDocument:document] autorelease];
    pdfController.leftBarButtonItems = nil;
    
    // create window and set as rootViewController
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.rootViewController = [[[UINavigationController alloc] initWithRootViewController:pdfController] autorelease];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc {
    [_window release];
    [super dealloc];
}

@end
