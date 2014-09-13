//
//  PSCBottomToolbarExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAssetLoader.h"
#import "PSCExample.h"

@interface PSCBottomToolbarExample : PSCExample @end
@interface PSCBottomToolbarViewController : PSPDFViewController @end

@implementation PSCBottomToolbarExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Bottom Toolbar";
        self.contentDescription = @"Simple example that shows how to set up a toolbar at the bottom.";
        self.category = PSCExampleCategoryBarButtons;
        self.priority = 100;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];

    // Simple subclass that shows/hides the navigationController bottom toolbar
    PSCBottomToolbarViewController *pdfController = [[PSCBottomToolbarViewController alloc] initWithDocument:document configuration:[PSPDFConfiguration configurationWithBuilder:^(PSPDFConfigurationBuilder *builder) {
        builder.thumbnailBarMode = PSPDFThumbnailBarModeNone;
    }]];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    pdfController.bookmarkButtonItem.tapChangesBookmarkStatus = NO;
    pdfController.leftBarButtonItems = nil;
    pdfController.rightBarButtonItems = nil; // Important! BarButtonItems can only be displayed at one location.
    pdfController.toolbarItems = @[space, pdfController.bookmarkButtonItem, space, pdfController.annotationButtonItem, space, pdfController.searchButtonItem, space, pdfController.outlineButtonItem, space, pdfController.emailButtonItem, space, pdfController.printButtonItem, space, pdfController.openInButtonItem, space];
    return pdfController;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCBottomToolbarViewController

@implementation PSCBottomToolbarViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:animated];
}

@end
