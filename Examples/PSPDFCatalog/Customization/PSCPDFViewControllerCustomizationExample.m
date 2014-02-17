//
//  PSCPDFViewControllerCustomizationExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCPDFViewControllerCustomizationExample.h"
#import "PSCAssetLoader.h"
#import "PSCEmbeddedTestController.h"
#import "PSCChildViewController.h"
#import "PSCButtonPDFViewController.h"
#import "PSCImageOverlayPDFViewController.h"
#import "PSCCustomToolbarController.h"
#import <UIKit/UIViewController.h>

@implementation PSCPDFViewControllerCustomizationUsingaNIBExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Using a NIB";
        self.category = PSCExampleCategoryControllerCustomization;
        self.priority = 20;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    return [[PSCEmbeddedTestController alloc] initWithNibName:@"EmbeddedNib" bundle:nil];
}

@end

@implementation PSCPDFViewControllerCustomizationChildViewControllerContainmentExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

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

@implementation PSCPDFViewControllerCustomizationAddingaSimpleUIButtonExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

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

@implementation PSCPDFViewControllerCustomizationAddingMultipleUIButtonsExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

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

@implementation PSCPDFViewControllerCustomizationCompletelyCustomToolbarExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Customized Toolbar";
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
