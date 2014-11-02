//
//  PSCPredefinedEmailBodyExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"
#import "PSCAssetLoader.h"

@interface PSCPredefinedEmailBodyExample : PSCExample <PSPDFViewControllerDelegate> @end
@implementation PSCPredefinedEmailBodyExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Customize email sending (add body text)";
        self.category = PSCExampleCategoryViewCustomization;
        self.priority = 500;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader documentWithName:PSPDFQuickStartAsset];
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    pdfController.rightBarButtonItems = @[pdfController.emailButtonItem];
    pdfController.delegate = self;
    return pdfController;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

- (BOOL)pdfViewController:(PSPDFViewController *)pdfController shouldShowController:(id<PSPDFPresentableViewController>)controller embeddedInController:(id<PSPDFHostableViewController>)hostController options:(NSDictionary *)options animated:(BOOL)animated {
    if ([controller isKindOfClass:MFMailComposeViewController.class]) {
        MFMailComposeViewController *mailComposer = (MFMailComposeViewController *)controller;
        [mailComposer setMessageBody:@"<h1 style='color:blue'>Custom message body.</h1>" isHTML:YES];
    }
    return YES;
}

@end
