//
//  PSCAddDocumentsBarButtonItem.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSCAddDocumentsBarButtonItem.h"

@implementation PSCAddDocumentsBarButtonItem

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFBarButtonItem

- (UIBarButtonSystemItem)systemItem {
    return UIBarButtonSystemItemAdd;
}

- (NSString *)actionName {
    return PSPDFLocalize(@"Add Documents");
}

// override implementation so that we are *always* enabled.
- (void)updateBarButtonItem {
    self.enabled = YES;
}

- (id)presentAnimated:(BOOL)animated sender:(id)sender {
    PSPDFDocumentSelectorController *documentsController = [[PSPDFDocumentSelectorController alloc] initWithDirectory:@"/Bundle/Samples" delegate:self];
    UINavigationController *documentsNavController = [[UINavigationController alloc] initWithRootViewController:documentsController];
    return [self presentModalOrInPopover:documentsNavController sender:sender];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFDocumentSelectorControllerDelegate

- (void)documentSelectorController:(PSPDFDocumentSelectorController *)documentSelectorController didSelectDocument:(PSPDFDocument *)document {
    PSPDFTabbedViewController *tabbedViewController = (PSPDFTabbedViewController *)self.pdfController.parentViewController;

    // add new document, and set as current
    [tabbedViewController addDocuments:@[document] atIndex:NSUIntegerMax animated:YES];
    tabbedViewController.visibleDocument = document;

    // hide controller
    if (PSIsIpad())[self.class dismissPopoverAnimated:YES];
    else [documentSelectorController dismissViewControllerAnimated:YES completion:NULL];
}

@end
