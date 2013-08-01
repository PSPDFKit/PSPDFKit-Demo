//
//  PSCClearTabsButtonItem.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCClearTabsButtonItem.h"

@implementation PSCClearTabsButtonItem

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIBarButtonItem

- (BOOL)isAvailable {
    return self.tabbedController.documents.count > 0;
}

- (UIBarButtonSystemItem)systemItem {
    return UIBarButtonSystemItemTrash;
}

- (id)presentAnimated:(BOOL)animated sender:(id)sender {
    PSPDFViewController *pdfController = self.pdfController;
    PSPDFActionSheet *actionSheet = [[PSPDFActionSheet alloc] initWithTitle:nil];

    [actionSheet setDestructiveButtonWithTitle:PSPDFLocalize(@"Close all tabs") block:^{
        PSPDFTabbedViewController *tabbedController = self.tabbedController;
        [tabbedController removeDocuments:tabbedController.documents animated:animated];
    }];
    [actionSheet setCancelButtonWithTitle:PSPDFLocalize(@"Cancel") block:NULL];

    // Be a nice citizen and first ask the delegate system if we are allowed to present this popover/actionSheet.
    BOOL shouldShow = [pdfController delegateShouldShowController:actionSheet embeddedInController:nil options:nil animated:animated];
    if (shouldShow) {
        [actionSheet showWithSender:sender fallbackView:pdfController.masterViewController.view animated:animated];
        return actionSheet;
    }else {
        return nil;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private Helper

- (PSPDFTabbedViewController *)tabbedController {
    PSPDFViewController *pdfController = self.pdfController;
    return [pdfController.parentViewController isKindOfClass:PSPDFTabbedViewController.class] ? (PSPDFTabbedViewController *) pdfController.parentViewController : nil;
}

@end
