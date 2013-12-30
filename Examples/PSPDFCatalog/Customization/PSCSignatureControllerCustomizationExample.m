//
//  PSCSignatureControllerCustomizationExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCSignatureControllerCustomizationExample.h"
#import "PSCAssetLoader.h"

@interface PSCCustomSignatureSelectorViewController : PSPDFSignatureSelectorViewController
@end

@implementation PSCSignatureControllerCustomizationExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Customized Signature Controller";
        self.category = PSCExampleCategoryViewCustomization;
        self.priority = 12;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    // Set up the document.
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];

    // And also the controller.
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    [pdfController overrideClass:PSPDFSignatureSelectorViewController.class withClass:PSCCustomSignatureSelectorViewController.class];
    return pdfController;
}

@end


@implementation PSCCustomSignatureSelectorViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // Customize toolbar here. Example only. On iPad, we wouldn't want the hide button.
    if (!PSCIsIPad()) {
        UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:PSPDFLocalize(@"Hide") style:UIBarButtonItemStyleDone target:self action:@selector(doneAction:)];
        self.navigationItem.leftBarButtonItems = @[closeButton];
    }
    self.navigationItem.rightBarButtonItems = @[self.addSignatureButtonItem];
}

@end
