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
#import "PSCCustomToolbarController.h"
#import "PSCExample.h"

@interface PSCPDFViewControllerCustomizationChildViewControllerContainmentExample : PSCExample @end
@implementation PSCPDFViewControllerCustomizationChildViewControllerContainmentExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Child View Controller containment";
        self.category = PSCExampleCategoryControllerCustomization;
        self.priority = 30;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    return [[PSCChildViewController alloc] initWithDocument:document];
}

@end

@interface PSCPDFViewControllerCustomizationAddingaSimpleUIButtonExample : PSCExample @end
@implementation PSCPDFViewControllerCustomizationAddingaSimpleUIButtonExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Adding a simple UIButton";
        self.category = PSCExampleCategoryControllerCustomization;
        self.priority = 40;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    return [[PSCButtonPDFViewController alloc] initWithDocument:document];
}

@end

@interface PSCPDFViewControllerCustomizationAddingMultipleUIButtonsExample : PSCExample @end
@implementation PSCPDFViewControllerCustomizationAddingMultipleUIButtonsExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Adding multiple buttons";
        self.contentDescription = @"Will add a custom button above all PDF images.";
        self.category = PSCExampleCategoryControllerCustomization;
        self.priority = 50;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    return [[PSCImageOverlayPDFViewController alloc] initWithDocument:document];
}

@end

@interface PSCPDFViewControllerCustomizationCompletelyCustomToolbarExample : PSCExample @end
@implementation PSCPDFViewControllerCustomizationCompletelyCustomToolbarExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Customized Toolbar";
        self.contentDescription = @"Uses a textual switch button for thumbnails/content.";
        self.category = PSCExampleCategoryBarButtons;
        self.priority = 70;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    return [[PSCCustomToolbarController alloc] initWithDocument:document];
}

@end
