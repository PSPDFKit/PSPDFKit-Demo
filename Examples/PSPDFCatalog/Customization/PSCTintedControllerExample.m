//
//  PSCTintedControllerExample.m
//  PSPDFCatalog-static
//
//  Created by Peter Steinberger on 17/02/14.
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//

#import "PSCTintedControllerExample.h"
#import "PSCTintColorSelectionBarButtonItem.h"
#import "PSCAssetLoader.h"

@interface PSCTintablePDFViewController : PSPDFViewController
@end

@implementation PSCTintedControllerExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Tinted Toolbar and Popovers";
        self.contentDescription = @"Shows how tinted popovers look. Allows instant interface color change.";
        self.category = PSCExampleCategoryControllerCustomization;
        self.priority = 80;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    return [[PSCTintablePDFViewController alloc] initWithDocument:document];
}

@end

@implementation PSCTintablePDFViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

- (void)commonInitWithDocument:(PSPDFDocument *)document {
    [super commonInitWithDocument:document];
    self.statusBarStyleSetting = PSPDFStatusBarStyleDefault;
    self.tintColor = [UIColor colorWithRed:0.092f green:0.608f blue:0.f alpha:1.f];
    PSCTintColorSelectionBarButtonItem *tintColorButtonItem = [[PSCTintColorSelectionBarButtonItem alloc] initWithPDFViewController:self];

    self.leftBarButtonItems = @[self.closeButtonItem, tintColorButtonItem];
    self.rightBarButtonItems = @[self.annotationButtonItem, self.outlineButtonItem, self.viewModeButtonItem];

    self.shouldTintPopovers = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = UIColor.blackColor;
}

@end
