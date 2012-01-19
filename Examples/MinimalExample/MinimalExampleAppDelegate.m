//
//  MinimalExampleAppDelegate.m
//  MinimalExample
//
//  Created by Peter Steinberger on 7/26/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "MinimalExampleAppDelegate.h"

// this is one way of overriding PSPDFViewController. However, subclassing is advised
@implementation PSPDFViewController (PSPDFMinimalExampleCategoryOverride)

// fixes warning on Xcode 4.3
#pragma clang diagnostic push
#if __clang_minor__ > 0
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
#endif
- (UIBarButtonItem *)toolbarBackButton {
    return nil;
}
#pragma clang diagnostic pop

@end

@implementation MinimalExampleAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
        
    NSString *path = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Samples"] stringByAppendingPathComponent:@"PSPDFKit.pdf"];
    PSPDFDocument *document = [PSPDFDocument PDFDocumentWithUrl:[NSURL fileURLWithPath:path]];
    PSPDFViewController *pdfController = [[[PSPDFViewController alloc] initWithDocument:document] autorelease];
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:pdfController] autorelease];
    self.window.rootViewController = navController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
