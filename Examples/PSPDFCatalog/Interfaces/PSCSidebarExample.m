//
//  PSCSidebarExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCSidebarExample.h"
#import "PSCAssetLoader.h"

@implementation PSCSidebarExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Sidebar Example";
        self.category = PSCExampleCategoryViewCustomization;
        self.priority = 1;
        self.targetDevice = PSCExampleTargetDeviceMaskPad; // Split view is iPad only.
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;

    // Set up the PDF controller
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    pdfController.rightBarButtonItems = @[pdfController.annotationButtonItem, pdfController.searchButtonItem, pdfController.activityButtonItem, pdfController.viewModeButtonItem];
    UINavigationController *navPDFController = [[UINavigationController alloc] initWithRootViewController:pdfController];

    // Set up the container for annotations/outline/bookmarks.
    PSPDFOutlineViewController *outlineController = [[PSPDFOutlineViewController alloc] initWithDocument:document delegate:pdfController];
    PSPDFBookmarkViewController *bookmarkController = [[PSPDFBookmarkViewController alloc] initWithDocument:document delegate:pdfController];
    PSPDFAnnotationTableViewController *annotationController = [[PSPDFAnnotationTableViewController alloc] initWithDocument:document delegate:pdfController];
    PSPDFSearchViewController *searchController = [[PSPDFSearchViewController alloc] initWithDocument:document delegate:pdfController];
    searchController.pinSearchBarToHeader = YES;
    PSPDFContainerViewController *containerController = [[PSPDFContainerViewController alloc] initWithControllers:@[outlineController, annotationController, bookmarkController, searchController] titles:nil delegate:nil];
    containerController.shouldShowCloseButton = NO;
    UINavigationController *navContainer = [[UINavigationController alloc] initWithRootViewController:containerController];

    // Create the split view controller
    UISplitViewController *splitController = [[UISplitViewController alloc] init];
    splitController.viewControllers = @[navContainer, navPDFController];

    // Use a dummy to present, as the split controller doesn't like to be presented modally.
    UIViewController *dummyController = [[UIViewController alloc] init];
    [dummyController addChildViewController:splitController];
    [dummyController.view addSubview:splitController.view];
    [splitController didMoveToParentViewController:dummyController];

    [delegate.currentViewController presentViewController:dummyController animated:YES completion:NULL];
    return nil;
}

@end
