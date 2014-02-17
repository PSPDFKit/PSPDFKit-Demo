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

    UISplitViewController *splitController = [UISplitViewController new];
    splitController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Split" image:[UIImage imageNamed:@"shoebox"] tag:3];
    PSCSplitDocumentSelectorController *tableController = [[PSCSplitDocumentSelectorController alloc] init];
    UINavigationController *tableNavController = [[UINavigationController alloc] initWithRootViewController:tableController];
    PSCSplitPDFViewController *hostController = [[PSCSplitPDFViewController alloc] init];
    UINavigationController *hostNavController = [[UINavigationController alloc] initWithRootViewController:hostController];
    tableController.masterController = hostController;
    splitController.delegate = hostController;
    splitController.viewControllers = @[tableNavController, hostNavController];

    PSCHostingController *hostingController = [PSCHostingController new];
    hostingController.wantsFullScreenLayout = YES;
    [hostingController addChildViewController:splitController];
    [hostingController.view addSubview:splitController.view];
    [delegate.currentViewController presentViewController:hostingController animated:YES completion:NULL];
    return nil;
}

@end

@implementation PSCHostingController
@end
