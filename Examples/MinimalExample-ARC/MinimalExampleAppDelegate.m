//
//  MinimalExampleAppDelegate.m
//  MinimalExample
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "MinimalExampleAppDelegate.h"

// if you use PSPDFKit.framework
#import <PSPDFKit/PSPDFKit.h>

// if you use PSPDFKit-lib.xcodeproj
//#import "PSPDFKit.h"

@implementation MinimalExampleAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSString *path = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Samples"] stringByAppendingPathComponent:@"PSPDFKit.pdf"];
    PSPDFDocument *document = [PSPDFDocument PDFDocumentWithUrl:[NSURL fileURLWithPath:path]];
    
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
     pdfController.pageCurlEnabled = YES;
    [pdfController scrollToPage:[pdfController landscapePage:5] animated:NO];
    //	pdfController.pageMode = PSPDFPageModeDouble;

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:pdfController];
    self.window.rootViewController = navController;
    
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end

// this is one way of overriding PSPDFViewController. However, subclassing is advised
@implementation PSPDFViewController (PSPDFMinimalExampleCategoryOverride)

// fixes warning on Xcode 4.3
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (UIBarButtonItem *)toolbarBackButton { return nil; }
#pragma clang diagnostic pop

@end
