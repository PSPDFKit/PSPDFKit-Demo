//
//  PSCAddDocumentsBarButtonItem.m
//  PSPDFCatalog
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
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

- (id)presentAnimated:(BOOL)animated sender:(PSPDFBarButtonItem *)sender {
    PSCDocumentSelectorController *documentsController = [[PSCDocumentSelectorController alloc] init];
    documentsController.delegate = self;
    UINavigationController *documentsNavController = [[UINavigationController alloc] initWithRootViewController:documentsController];
    return [self presentModalOrInPopover:documentsNavController sender:sender];
}

- (void)dismissAnimated:(BOOL)animated {
    [self dismissModalOrPopoverAnimated:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFDocumentSelectorControllerDelegate

- (void)documentSelectorController:(PSCDocumentSelectorController *)controller didSelectDocument:(PSPDFDocument *)document {
    PSPDFTabbedViewController *tabbedViewController = (PSPDFTabbedViewController *)self.pdfController.parentViewController;

    // add new document, and set as current
    [tabbedViewController addDocuments:[NSArray arrayWithObject:document] atIndex:NSUIntegerMax animated:YES];
    tabbedViewController.visibleDocument = document;
}

@end
