//
//  PSCDocumentSidebarExample.m
//  PSPDFCatalog-static
//
//  Created by Peter Steinberger on 17/02/14.
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//

#import "PSCDocumentSidebarExample.h"
#import "PSCSplitPDFViewController.h"
#import "PSCSplitDocumentSelectorController.h"
#import "PSCAssetLoader.h"

@interface PSCHostingController : UIViewController
@end

@implementation PSCDocumentSidebarExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Document Picker Sidebar";
        self.contentDescription = @"Uses a document picker as the split view controller sidebar.";
        self.category = PSCExampleCategoryViewCustomization;
        self.priority = 1;
        self.targetDevice = PSCExampleTargetDeviceMaskPad; // Split view is iPad only.
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;

    UISplitViewController *splitVC = [UISplitViewController new];
    splitVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Split" image:[UIImage imageNamed:@"shoebox"] tag:3];
    PSCSplitDocumentSelectorController *tableVC = [[PSCSplitDocumentSelectorController alloc] init];
    UINavigationController *tableNavVC = [[UINavigationController alloc] initWithRootViewController:tableVC];
    PSCSplitPDFViewController *hostVC = [[PSCSplitPDFViewController alloc] init];
    UINavigationController *hostNavVC = [[UINavigationController alloc] initWithRootViewController:hostVC];
    tableVC.masterVC = hostVC;
    splitVC.delegate = hostVC;
    splitVC.viewControllers = @[tableNavVC, hostNavVC];

    PSCHostingController *hostingController = [PSCHostingController new];
    hostingController.wantsFullScreenLayout = YES;
    [hostingController addChildViewController:splitVC];
    [hostingController.view addSubview:splitVC.view];
    [delegate.currentViewController presentViewController:hostingController animated:YES completion:NULL];
    return nil;
}

@end

@implementation PSCHostingController
@end
