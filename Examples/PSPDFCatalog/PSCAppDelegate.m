//
//  PSCAppDelegate.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAppDelegate.h"
#import "PSCatalogViewController.h"

@interface PSCAppDelegate () <UINavigationControllerDelegate> @end

@implementation PSCAppDelegate

- (void)customizeImages {
    PSPDFSetBundleImageBlock(^UIImage *(NSString *imageName) {
        if ([imageName isEqualToString:@"knob"]) {
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(20.f, 20.f), NO, 0.0);
            UIBezierPath *round = [UIBezierPath bezierPathWithRect:CGRectMake(0.f, 0.f, 20.f, 20.f)];
            [round fill];
            UIImage *newKnob = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return newKnob;
        }
        return nil;
    });
}

- (void)customizeLocalization {
    // Either use the block-based system.
    PSPDFSetLocalizationBlock(^NSString *(NSString *stringToLocalize) {
        // This will look up strings in language/PSPDFKit.strings inside resources.
        // (In PSPDFCatalog, there are no such files, this is just to demonstrate best practice)
        return NSLocalizedStringFromTable(stringToLocalize, @"PSPDFKit", nil);
        //return [NSString stringWithFormat:@"_____%@_____", stringToLocalize];
    });

    // Or override via dictionary.
    // See PSPDFKit.bundle/en.lproj/PSPDFKit.strings for all available strings.
    PSPDFSetLocalizationDictionary(@{@"en" : @{@"%d of %d" : @"Page %d of %d",
                                               @"%d-%d of %d" : @"Pages %d-%d of %d"}});
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Set your license key here. PSPDFKit is commercial software.
    // Each PSPDFKit license is bound to a specific app bundle id.
    // Visit http://customers.pspdfkit.com to get your demo or commercial license key.
    [PSPDFKit setLicenseKey:@"YOUR_LICENSE_KEY_GOES_HERE"];

    // Example how to easily change certain images in PSPDFKit.
    //[self customizeImages];

    // Example how to localize strings in PSPDFKit.
    //[self customizeLocalization];

    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Change log level to be more verbose.
#ifdef DEBUG
    PSPDFLogLevel = PSPDFLogLevelMaskInfo|PSPDFLogLevelMaskWarning|PSPDFLogLevelMaskError;
#endif

    // Configure callback for Open In Chrome feature. Optional.
    PSPDFKit.sharedInstance[PSPDFXCallbackURLStringKey] = @"pspdfcatalog://";

    // Create catalog controller delayed because we also dynamically load the license key.
    PSCatalogViewController *catalogController = [[PSCatalogViewController alloc] initWithStyle:UITableViewStyleGrouped];

//    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
//    PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"pspdfkit_playground.pdf"]];
//    PSPDFViewController *catalogController = [[PSPDFViewController alloc] initWithDocument:document];

    // PSPDFNavigationController is a simple subclass that forwards iOS 6+ rotation methods.
    self.catalog = [[PSPDFNavigationController alloc] initWithRootViewController:catalogController];
    self.window  = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
	// Forward the window to catalogController early, so it can set the default tintColor
	catalogController.keyWindow = self.window;
    self.window.rootViewController = self.catalog;
    [self.window makeKeyAndVisible];

    // Enable global Undo/Redo
    application.applicationSupportsShakeToEdit = YES;

    // Opened with the Open In... feature?
    [self handleOpenURL:launchOptions[UIApplicationLaunchOptionsURLKey]];

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)URL sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"Open %@ from %@ (annotation: %@)", URL, sourceApplication, annotation);
    return [self handleOpenURL:URL];
}

- (BOOL)handleOpenURL:(NSURL *)launchURL {
    // Directly open the PDF.
    if (launchURL.isFileURL && [NSFileManager.defaultManager fileExistsAtPath:launchURL.path]) {
        PSPDFDocument *document = [PSPDFDocument documentWithURL:launchURL];
        PSPDFViewController *pdfController = [self viewControllerForDocument:document];
        [self.catalog popToRootViewControllerAnimated:NO];
        [self.catalog pushViewController:pdfController animated:NO];
        return YES;
    // Only show alert if there's content.
    } else if ([launchURL.scheme.lowercaseString isEqualToString:@"pspdfcatalog"] && launchURL.absoluteString.length > @"pspdfcatalog://".length) {
        [[[UIAlertView alloc] initWithTitle:@"Custom Protocol Handler" message:launchURL.absoluteString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    return NO;
}

- (PSPDFViewController *)viewControllerForDocument:(PSPDFDocument *)document {
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    pdfController.rightBarButtonItems = @[pdfController.searchButtonItem, pdfController.outlineButtonItem, pdfController.annotationButtonItem, pdfController.viewModeButtonItem];
    return pdfController;
}

@end
