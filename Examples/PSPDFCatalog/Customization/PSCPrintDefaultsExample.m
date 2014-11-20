//
//  PSCPrintDefaultsExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"
#import "PSCAssetLoader.h"

@interface PSCPrintDefaultsExample : PSCExample <PSPDFViewControllerDelegate>
@end

@implementation PSCPrintDefaultsExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Custom printer defaults";
        self.category = PSCExampleCategoryViewCustomization;
        self.priority = 600;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader documentWithName:PSPDFQuickStartAsset];
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    pdfController.delegate = self;
    return pdfController;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

- (BOOL)pdfViewController:(PSPDFViewController *)pdfController shouldShowController:(id<PSPDFPresentableViewController>)controller embeddedInController:(id<PSPDFHostableViewController>)hostController options:(NSDictionary *)options animated:(BOOL)animated {

    // Intercept and customize the document sharing view controller.
    if ([controller isKindOfClass:UINavigationController.class] &&
        [[(UINavigationController *)controller topViewController] isKindOfClass:PSPDFDocumentSharingViewController.class]) {
        PSPDFDocumentSharingViewController *sharingController = (PSPDFDocumentSharingViewController *)[(UINavigationController *)controller topViewController];

        // Only modify if we're printing. This controller is used for mail or open in as well.
        if (sharingController.delegate == pdfController.printButtonItem) {
            sharingController.selectedOptions = PSPDFDocumentSharingOptionAnnotationsSummary|PSPDFDocumentSharingOptionCurrentPageOnly;
        }
    }

    return YES;
}

@end
