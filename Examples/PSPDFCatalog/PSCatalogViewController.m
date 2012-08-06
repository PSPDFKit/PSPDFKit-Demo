//
//  PSCatalogViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012 PSPDFKit. All rights reserved.
//

#import "PSCatalogViewController.h"
#import "PSCSectionDescriptor.h"
#import "PSCGridController.h"
#import "PSCTabbedExampleViewController.h"
#import "PSCDocumentSelectorController.h"
#import "PSCEmbeddedTestController.h"
#import "PSCustomToolbarController.h"
#import "PSCAnnotationTestController.h"
#import "PSCSplitDocumentSelectorController.h"
#import "PSCSplitPDFViewController.h"

@interface PSCatalogViewController () <PSCDocumentSelectorControllerDelegate> {
    NSArray *_content;
}
@end

@implementation PSCatalogViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithStyle:(UITableViewStyle)style {
    if ((self = [super initWithStyle:style])) {
        self.title = @"PSPDFKit Catalog";
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Catalog" style:UIBarButtonItemStylePlain target:nil action:nil];

        // common paths
        NSURL *hackerMagURL = [NSURL fileURLWithPath:[[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Samples"] stringByAppendingPathComponent:kHackerMagazineExample]];

        NSMutableArray *content = [NSMutableArray array];

        // Full Apps
        PSCSectionDescriptor *appSection = [[PSCSectionDescriptor alloc] initWithTitle:@"Full Example Apps" footer:@"Can be used as a template for your own apps."];
        [appSection addContent:[[PSContent alloc] initWithTitle:@"PSPDFKit Kiosk" class:[PSCGridController class]]];

        [appSection addContent:[[PSContent alloc] initWithTitle:@"Tabbed Browser" block:^{
            if (PSIsIpad()) {
                return (UIViewController *)[PSCTabbedExampleViewController new];
            }else {
                // on iPhone, we do things a bit different, and push/pull the controller.
                return (UIViewController *)[[PSCDocumentSelectorController alloc] initWithDelegate:self];
            }
        }]];
        [content addObject:appSection];

        // PSPDFDocument data provider test
        PSCSectionDescriptor *documentTests = [[PSCSectionDescriptor alloc] initWithTitle:@"PSPDFDocument data providers" footer:@"PSPDFDocument is highly flexible."];

        /// PSPDFDocument works with a NSURL
        [documentTests addContent:[[PSContent alloc] initWithTitle:@"NSURL" block:^{
            PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
            return [[PSPDFViewController alloc] initWithDocument:document];
        }]];

        /// A NSData (both memory-mapped and full)
        [documentTests addContent:[[PSContent alloc] initWithTitle:@"NSData" block:^{
            NSData *data = [NSData dataWithContentsOfMappedFile:[hackerMagURL path]];
            PSPDFDocument *document = [PSPDFDocument PDFDocumentWithData:data];
            return [[PSPDFViewController alloc] initWithDocument:document];
        }]];

        /// And even a CGDocumentProvider (can be used for encryption)
        [documentTests addContent:[[PSContent alloc] initWithTitle:@"CGDocumentProvider" block:^{
            NSData *data = [NSData dataWithContentsOfURL:hackerMagURL options:NSDataReadingMappedIfSafe error:NULL];
            CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)(data));
            PSPDFDocument *document = [PSPDFDocument PDFDocumentWithDataProvider:dataProvider];
            CGDataProviderRelease(dataProvider);
            return [[PSPDFViewController alloc] initWithDocument:document];
        }]];
        [content addObject:documentTests];

        PSCSectionDescriptor *annotationSection = [[PSCSectionDescriptor alloc] initWithTitle:@"Annotation Tests" footer:@"PSPDFKit supports all common PDF annotations, including Highlighing, Underscore, Strikeout, Comment and Ink."];
        
        [annotationSection addContent:[[PSContent alloc] initWithTitle:@"Add a custom annotation" block:^{
            PSPDFDocument *hackerDocument = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
            return [[PSCAnnotationTestController alloc] initWithDocument:hackerDocument];
        }]];
        [content addObject:annotationSection];

        PSCSectionDescriptor *storyboardSection = [[PSCSectionDescriptor alloc] initWithTitle:@"Storyboards" footer:@""];
        [storyboardSection addContent:[[PSContent alloc] initWithTitle:@"Init with Storyboard" block:^UIViewController *{
            return (UIViewController *)[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateInitialViewController];
        }]];
        [content addObject:storyboardSection];

        // PSPDFViewController customization examples
        PSCSectionDescriptor *customizationSection = [[PSCSectionDescriptor alloc] initWithTitle:@"PSPDFViewController customization" footer:@""];

        [customizationSection addContent:[[PSContent alloc] initWithTitle:@"Using a NIB" block:^{
            return [[PSCEmbeddedTestController alloc] initWithNibName:@"EmbeddedNib" bundle:nil];
        }]];

        [customizationSection addContent:[[PSContent alloc] initWithTitle:@"Custom Toolbar" block:^{
            PSPDFDocument *document = [PSPDFDocument PDFDocumentWithURL:hackerMagURL];
            return [[PSCustomToolbarController alloc] initWithDocument:document];
        }]];
        [content addObject:customizationSection];

        // iPad only examples
        if (PSIsIpad()) {
            PSCSectionDescriptor *iPadTests = [[PSCSectionDescriptor alloc] initWithTitle:@"iPad only" footer:@""];
            [iPadTests addContent:[[PSContent alloc] initWithTitle:@"SplitView" block:^{
                UISplitViewController *splitVC = [[UISplitViewController alloc] init];
                splitVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Split" image:[UIImage imageNamed:@"shoebox"] tag:3];
                PSCSplitDocumentSelectorController *tableVC = [[PSCSplitDocumentSelectorController alloc] init];
                UINavigationController *tableNavVC = [[UINavigationController alloc] initWithRootViewController:tableVC];
                PSCSplitPDFViewController *hostVC = [[PSCSplitPDFViewController alloc] init];
                UINavigationController *hostNavVC = [[UINavigationController alloc] initWithRootViewController:hostVC];
                tableVC.masterVC = hostVC;
                splitVC.delegate = hostVC;
                splitVC.viewControllers = @[tableNavVC, hostNavVC];
                // Splitview controllers can't just be added to a UINavigationController
                self.view.window.rootViewController = splitVC;
                return (UIViewController *)nil;
            }]];
            [content addObject:iPadTests];
        }

        _content = content;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return PSIsIpad() ? YES : toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_content count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_content[section] contentDescriptors] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_content[section] title];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [_content[section] footer];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PSCatalogCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    PSContent *contentDescriptor = [_content[indexPath.section] contentDescriptors][indexPath.row];
    cell.textLabel.text = contentDescriptor.title;
    return cell;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PSContent *contentDescriptor = [_content[indexPath.section] contentDescriptors][indexPath.row];
    UIViewController *controller;
    if (contentDescriptor.classToInvoke) {
        controller = [contentDescriptor.classToInvoke new];
    }else {
        controller = contentDescriptor.block();
    }
    if (controller) {
        if ([controller isKindOfClass:[UINavigationController class]]) {
            controller = [((UINavigationController *)controller) topViewController];
        }
        [self.navigationController pushViewController:controller animated:YES];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFDocumentSelectorControllerDelegate

- (void)documentSelectorController:(PSCDocumentSelectorController *)controller didSelectDocument:(PSPDFDocument *)document {
    // create controller and merge new documents with last saved state.
    PSPDFTabbedViewController *tabbedViewController = [PSCTabbedExampleViewController new];
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

@implementation UINavigationController (PSPDFKeyboardDismiss)

// Fixes a behavior of UIModalPresentationFormSheet
// http://stackoverflow.com/questions/3372333/ipad-keyboard-will-not-dismiss-if-modal-view-controller-presentation-style-is-ui
- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}
@end
