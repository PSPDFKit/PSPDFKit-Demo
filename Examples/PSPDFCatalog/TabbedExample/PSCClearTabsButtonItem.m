//
//  PSCClearTabsButtonItem.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCClearTabsButtonItem.h"
#import "PSTAlertController.h"

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

    PSTAlertController *sheetController = [PSTAlertController actionSheetWithTitle:nil];
    [sheetController addCancelActionWithHandler:nil];
    [sheetController addAction:[PSTAlertAction actionWithTitle:@"Close all tabs" style:PSTAlertActionStyleDestructive handler:^(PSTAlertAction *action) {
        PSPDFTabbedViewController *tabbedController = self.tabbedController;
        [tabbedController removeDocuments:tabbedController.documents animated:animated];
    }]];
    [sheetController showWithSender:sender controller:pdfController animated:animated completion:nil];
    return sheetController;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private Helper

- (PSPDFTabbedViewController *)tabbedController {
    PSPDFViewController *pdfController = self.pdfController;
    return [pdfController.parentViewController isKindOfClass:PSPDFTabbedViewController.class] ? (PSPDFTabbedViewController *) pdfController.parentViewController : nil;
}

@end
