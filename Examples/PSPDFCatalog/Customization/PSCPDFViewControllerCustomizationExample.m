//
//  PSCPDFViewControllerCustomizationExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAssetLoader.h"
#import "PSCChildViewController.h"
#import "PSCButtonPDFViewController.h"
#import "PSCImageOverlayPDFViewController.h"
#import "PSCToolbarController.h"
#import "PSCExample.h"
#import "PSCSearchContainerChildPDFViewController.h"

@interface PSCChildViewControllerContainmentExample : PSCExample @end
@implementation PSCChildViewControllerContainmentExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Child View Controller containment, windowed";
        self.category = PSCExampleCategoryControllerCustomization;
        self.priority = 30;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader documentWithName:PSPDFHackerMagazineAsset];
    return [[PSCChildViewController alloc] initWithDocument:document];
}

@end

@interface PSCFullScreenChildViewControllerContainmentExample : PSCExample @end
@implementation PSCFullScreenChildViewControllerContainmentExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Child View Controller containment, fullscreen";
        self.category = PSCExampleCategoryControllerCustomization;
        self.priority = 31;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader documentWithName:PSPDFHackerMagazineAsset];
    PSPDFViewController *pdfController = [[PSCSearchContainerChildPDFViewController alloc] initWithDocument:document];
    // Manually configure the top label insets.
    pdfController.HUDView.documentLabelInsets = UIEdgeInsetsMake(80.f, 0.f, 0.f, 0.f);

    // Create simple view controller container.
    UIViewController *viewController = [[UIViewController alloc] init];
    [viewController addChildViewController:pdfController];
    [viewController.view addSubview:pdfController.view];
    pdfController.view.frame = viewController.view.bounds;
    [pdfController didMoveToParentViewController:viewController];

    return viewController;
}

@end

@interface PSCNoToolbarChildViewControllerContainmentExample : PSCExample @end
@implementation PSCNoToolbarChildViewControllerContainmentExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Child View Controller containment, no toolbar";
        self.category = PSCExampleCategoryControllerCustomization;
        self.priority = 32;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader documentWithName:PSPDFHackerMagazineAsset];
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    // Manually configure the top lable distance.
    //pdfController.HUDView.documentLabelDistance = 80.f;

    // Create simple view controller container.
    UIViewController *viewController = [[UIViewController alloc] init];
    [viewController addChildViewController:pdfController];
    [viewController.view addSubview:pdfController.view];
    pdfController.view.frame = viewController.view.bounds;
    [pdfController didMoveToParentViewController:viewController];
    [delegate.currentViewController.navigationController presentViewController:viewController animated:YES completion:NULL];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [viewController dismissViewControllerAnimated:YES completion:NULL];
    });
    return nil;
}

@end

@interface PSAddingButtonExample : PSCExample @end
@implementation PSAddingButtonExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Adding a simple UIButton";
        self.category = PSCExampleCategoryControllerCustomization;
        self.priority = 40;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader documentWithName:PSPDFHackerMagazineAsset];
    return [[PSCButtonPDFViewController alloc] initWithDocument:document];
}

@end

@interface PSCAddingMultipleUIButtonsExample : PSCExample @end
@implementation PSCAddingMultipleUIButtonsExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Adding multiple buttons";
        self.contentDescription = @"Will add a custom button above all PDF images.";
        self.category = PSCExampleCategoryControllerCustomization;
        self.priority = 50;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader documentWithName:PSPDFHackerMagazineAsset];
    return [[PSCImageOverlayPDFViewController alloc] initWithDocument:document];
}

@end

@interface PSCCompletelyCustomToolbarExample : PSCExample @end
@implementation PSCCompletelyCustomToolbarExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Customized Toolbar";
        self.contentDescription = @"Uses a textual switch button for thumbnails/content.";
        self.category = PSCExampleCategoryBarButtons;
        self.priority = 70;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader documentWithName:PSPDFHackerMagazineAsset];
    return [[PSCToolbarController alloc] initWithDocument:document];
}

@end
