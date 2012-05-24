//
//  PSPDFAddDocumentsBarButtonItem.m
//  TabbedExample
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFAddDocumentsBarButtonItem.h"
#import "PSPDFDocumentSelectorController.h"

@interface PSPDFAddDocumentsBarButtonItem () <PSPDFDocumentSelectorControllerDelegate>
@end

@implementation PSPDFAddDocumentsBarButtonItem

- (UIBarButtonSystemItem)systemItem {
    return UIBarButtonSystemItemAdd;
}

- (NSString *)actionName {
    return PSPDFLocalize(@"Add Documents");
}

- (id)presentAnimated:(BOOL)animated sender:(PSPDFBarButtonItem *)sender {
    PSPDFDocumentSelectorController *documentsController = [[PSPDFDocumentSelectorController alloc] init];
    documentsController.delegate = self;
    UINavigationController *documentsNavController = [[UINavigationController alloc] initWithRootViewController:documentsController];
    return [self presentModalOrInPopover:documentsNavController sender:sender];
}

- (void)dismissAnimated:(BOOL)animated {
    [self dismissModalOrPopoverAnimated:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFDocumentSelectorControllerDelegate

- (void)PDFDocumentSelectorController:(PSPDFDocumentSelectorController *)controller didSelectDocument:(PSPDFDocument *)document {
    PSPDFTabbedViewController *tabbedViewController = (PSPDFTabbedViewController *)self.pdfViewController.parentViewController;

    // add new document, and set as current
    NSMutableArray *newDocuments = [tabbedViewController.documents mutableCopy];
    [newDocuments addObject:document];
    tabbedViewController.documents = newDocuments;
    tabbedViewController.visibleDocument = document;

    [PSPDFBarButtonItem dismissPopoverAnimated:YES];
}

@end
